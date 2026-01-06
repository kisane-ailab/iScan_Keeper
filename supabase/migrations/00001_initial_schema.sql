-- =============================================
-- iScan Keeper Supabase 초기 스키마
-- 최종 업데이트: 2026-01-06
-- =============================================

-- =============================================
-- 1. ENUM 타입 생성
-- =============================================

-- 사용자 상태 ENUM
CREATE TYPE user_status AS ENUM ('available', 'busy', 'offline');

-- 대응 상태 ENUM
CREATE TYPE response_status AS ENUM ('unresponded', 'in_progress', 'completed');

-- 로그 카테고리 ENUM (기존 event_type에서 리네임)
CREATE TYPE log_category AS ENUM ('event', 'health_check');

-- 로그 레벨 ENUM
CREATE TYPE log_level AS ENUM ('info', 'warning', 'error', 'critical');


-- =============================================
-- 2. 테이블 생성
-- =============================================

-- 조직 테이블
CREATE TABLE organizations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now() NOT NULL
);
COMMENT ON TABLE organizations IS '조직 정보';

-- 직원/담당자 정보 테이블
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR NOT NULL,
    email VARCHAR NOT NULL UNIQUE,
    status user_status DEFAULT 'offline' NOT NULL,
    organization_id UUID REFERENCES organizations(id),
    role VARCHAR DEFAULT 'member',
    created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT now() NOT NULL
);
COMMENT ON TABLE users IS '직원/담당자 정보';
COMMENT ON COLUMN users.status IS '상태: available(대기중), busy(대응중), offline(오프라인)';
COMMENT ON COLUMN users.organization_id IS '소속 조직 (FK)';
COMMENT ON COLUMN users.role IS '역할: admin, member';

-- 범용 시스템 로그 테이블
CREATE TABLE system_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    source VARCHAR NOT NULL,
    description TEXT,
    category log_category DEFAULT 'event' NOT NULL,
    code VARCHAR,
    log_level log_level DEFAULT 'info',
    payload JSONB DEFAULT '{}'::jsonb,
    response_status response_status DEFAULT 'unresponded',
    current_responder_id UUID REFERENCES users(id),
    current_responder_name VARCHAR,
    response_started_at TIMESTAMPTZ,
    organization_id UUID REFERENCES organizations(id),
    created_at TIMESTAMPTZ DEFAULT now()
);
COMMENT ON TABLE system_logs IS '범용 시스템 로그';
COMMENT ON COLUMN system_logs.source IS '로그 출처 (machine, web, app 등)';
COMMENT ON COLUMN system_logs.description IS '로그 설명';
COMMENT ON COLUMN system_logs.category IS '로그 카테고리 (event: 단발 이벤트, health_check: 주기적 헬스체크)';
COMMENT ON COLUMN system_logs.code IS '코드 (에러코드, 상태코드 등)';
COMMENT ON COLUMN system_logs.log_level IS '로그 레벨 (info, warning, error, critical)';
COMMENT ON COLUMN system_logs.payload IS '상세 데이터 (JSONB)';
COMMENT ON COLUMN system_logs.response_status IS '대응 상태';
COMMENT ON COLUMN system_logs.current_responder_id IS '현재 대응중인 담당자 ID';
COMMENT ON COLUMN system_logs.current_responder_name IS '현재 대응중인 담당자 이름';
COMMENT ON COLUMN system_logs.response_started_at IS '대응 시작 시간';
COMMENT ON COLUMN system_logs.organization_id IS '소속 조직 (FK)';

-- 담당자의 대응 기록 테이블
CREATE TABLE response_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    system_log_id UUID NOT NULL REFERENCES system_logs(id),
    user_id UUID NOT NULL REFERENCES users(id),
    started_at TIMESTAMPTZ DEFAULT now() NOT NULL,
    completed_at TIMESTAMPTZ,
    memo TEXT,
    created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT now() NOT NULL
);
COMMENT ON TABLE response_logs IS '담당자의 대응 기록';
COMMENT ON COLUMN response_logs.system_log_id IS '대응 대상 시스템 로그 (FK)';
COMMENT ON COLUMN response_logs.user_id IS '담당자 (FK)';
COMMENT ON COLUMN response_logs.started_at IS '대응 시작 시간';
COMMENT ON COLUMN response_logs.completed_at IS '대응 완료 시간 (NULL이면 진행중)';
COMMENT ON COLUMN response_logs.memo IS '메모/조치 내역';


-- =============================================
-- 3. 인덱스 생성
-- =============================================

-- users 인덱스
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_status ON users(status);
CREATE INDEX idx_users_organization ON users(organization_id);

-- system_logs 인덱스
CREATE INDEX idx_system_logs_source ON system_logs(source);
CREATE INDEX idx_system_logs_category ON system_logs(category);
CREATE INDEX idx_system_logs_code ON system_logs(code);
CREATE INDEX idx_system_logs_log_level ON system_logs(log_level);
CREATE INDEX idx_system_logs_created_at ON system_logs(created_at DESC);
CREATE INDEX idx_system_logs_payload ON system_logs USING GIN (payload);
CREATE INDEX idx_system_logs_organization ON system_logs(organization_id);

-- response_logs 인덱스
CREATE INDEX idx_response_logs_system_log_id ON response_logs(system_log_id);
CREATE INDEX idx_response_logs_user_id ON response_logs(user_id);
CREATE INDEX idx_response_logs_started_at ON response_logs(started_at DESC);
CREATE INDEX idx_response_logs_completed_at ON response_logs(completed_at DESC);
CREATE UNIQUE INDEX idx_response_logs_unique_system_log ON response_logs(system_log_id);


-- =============================================
-- 4. RLS 비활성화 (현재 설정 유지)
-- =============================================

ALTER TABLE organizations DISABLE ROW LEVEL SECURITY;
ALTER TABLE users DISABLE ROW LEVEL SECURITY;
ALTER TABLE system_logs DISABLE ROW LEVEL SECURITY;
ALTER TABLE response_logs DISABLE ROW LEVEL SECURITY;


-- =============================================
-- 5. Realtime 활성화
-- =============================================

ALTER PUBLICATION supabase_realtime ADD TABLE system_logs;


-- =============================================
-- 6. 트리거: response_started_at 자동 설정
-- =============================================

CREATE OR REPLACE FUNCTION set_response_started_at()
RETURNS TRIGGER AS \$\$
BEGIN
    IF NEW.response_status = 'in_progress'
       AND (OLD.response_status IS NULL OR OLD.response_status != 'in_progress')
       AND NEW.response_started_at IS NULL THEN
        NEW.response_started_at = NOW();
    END IF;
    RETURN NEW;
END;
\$\$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_set_response_started_at
    BEFORE UPDATE ON system_logs
    FOR EACH ROW
    EXECUTE FUNCTION set_response_started_at();
