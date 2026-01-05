-- =============================================
-- iScan Keeper Supabase 초기 스키마
-- =============================================

-- =============================================
-- 1. ENUM 타입 생성
-- =============================================

-- 사용자 상태 ENUM
CREATE TYPE user_status AS ENUM ('available', 'busy', 'offline');

-- 대응 상태 ENUM
CREATE TYPE response_status AS ENUM ('unchecked', 'in_progress', 'completed');


-- =============================================
-- 2. 테이블 생성
-- =============================================

-- 직원/담당자 정보 테이블
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR NOT NULL,
    email VARCHAR NOT NULL UNIQUE,
    status user_status DEFAULT 'offline' NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT now() NOT NULL
);
COMMENT ON TABLE users IS '직원/담당자 정보';
COMMENT ON COLUMN users.status IS '상태: available(대기중), busy(대응중), offline(오프라인)';

-- 범용 이벤트/에러 로그 테이블
CREATE TABLE event_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    source VARCHAR NOT NULL,
    error_code VARCHAR,
    log_level VARCHAR DEFAULT 'info',
    payload JSONB DEFAULT '{}'::jsonb,
    response_status response_status DEFAULT 'unchecked',
    created_at TIMESTAMPTZ DEFAULT now()
);
COMMENT ON TABLE event_logs IS '범용 이벤트/에러 로그';
COMMENT ON COLUMN event_logs.source IS '로그 출처 (machine, web, app 등)';
COMMENT ON COLUMN event_logs.error_code IS '에러 코드';
COMMENT ON COLUMN event_logs.log_level IS '로그 레벨 (info, warning, error)';
COMMENT ON COLUMN event_logs.payload IS '상세 데이터 (JSONB)';
COMMENT ON COLUMN event_logs.response_status IS '대응 상태';

-- 담당자의 대응 기록 테이블
CREATE TABLE response_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_log_id UUID NOT NULL,
    user_id UUID NOT NULL,
    started_at TIMESTAMPTZ DEFAULT now() NOT NULL,
    completed_at TIMESTAMPTZ,
    memo TEXT,
    created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT now() NOT NULL,
    CONSTRAINT response_logs_event_log_id_fkey FOREIGN KEY (event_log_id) REFERENCES event_logs(id),
    CONSTRAINT response_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id)
);
COMMENT ON TABLE response_logs IS '담당자의 대응 기록';
COMMENT ON COLUMN response_logs.event_log_id IS '대응 대상 이벤트 로그 (FK)';
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

-- event_logs 인덱스
CREATE INDEX idx_event_logs_source ON event_logs(source);
CREATE INDEX idx_event_logs_error_code ON event_logs(error_code);
CREATE INDEX idx_event_logs_log_level ON event_logs(log_level);
CREATE INDEX idx_event_logs_created_at ON event_logs(created_at DESC);
CREATE INDEX idx_event_logs_payload ON event_logs USING GIN (payload);

-- response_logs 인덱스
CREATE INDEX idx_response_logs_event_log_id ON response_logs(event_log_id);
CREATE INDEX idx_response_logs_user_id ON response_logs(user_id);
CREATE INDEX idx_response_logs_started_at ON response_logs(started_at DESC);
CREATE INDEX idx_response_logs_completed_at ON response_logs(completed_at DESC);
CREATE INDEX idx_response_logs_user_started ON response_logs(user_id, started_at DESC);
CREATE INDEX idx_response_logs_user_completed ON response_logs(user_id, completed_at DESC);
CREATE UNIQUE INDEX idx_response_logs_unique_event ON response_logs(event_log_id);


-- =============================================
-- 4. RLS 비활성화 (현재 설정 유지)
-- =============================================

ALTER TABLE users DISABLE ROW LEVEL SECURITY;
ALTER TABLE event_logs DISABLE ROW LEVEL SECURITY;
ALTER TABLE response_logs DISABLE ROW LEVEL SECURITY;


-- =============================================
-- 5. Realtime 활성화
-- =============================================

-- event_logs 테이블에 Realtime 활성화
ALTER PUBLICATION supabase_realtime ADD TABLE event_logs;
