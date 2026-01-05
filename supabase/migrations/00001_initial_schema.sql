-- =============================================
-- iScan Keeper Supabase 초기 스키마
-- 싱가포르 → 한국 리전 마이그레이션용
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

-- 기계 상태 로그 데이터 테이블
CREATE TABLE machine_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    serial_number VARCHAR NOT NULL,
    public_ip VARCHAR,
    company_name VARCHAR,
    vendor_name VARCHAR,
    db_key VARCHAR,
    error_code VARCHAR,
    run_mode VARCHAR DEFAULT 'base',
    log_level VARCHAR,
    system_info JSONB DEFAULT '{}'::jsonb,
    version_info JSONB DEFAULT '{}'::jsonb,
    settings JSONB DEFAULT '{}'::jsonb,
    response_status response_status DEFAULT 'unchecked',
    last_update TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT now()
);
COMMENT ON TABLE machine_logs IS '기계 상태 로그 데이터';
COMMENT ON COLUMN machine_logs.serial_number IS '장비 시리얼 번호';
COMMENT ON COLUMN machine_logs.public_ip IS '공인 IP 주소';
COMMENT ON COLUMN machine_logs.company_name IS '회사명';
COMMENT ON COLUMN machine_logs.vendor_name IS '벤더/대리점명';
COMMENT ON COLUMN machine_logs.db_key IS '데이터베이스 키';
COMMENT ON COLUMN machine_logs.error_code IS '에러 코드';
COMMENT ON COLUMN machine_logs.run_mode IS '실행 모드 (base, etc)';
COMMENT ON COLUMN machine_logs.log_level IS '로그 레벨 (info, warning, error 등)';
COMMENT ON COLUMN machine_logs.system_info IS '시스템 정보 (freeSpace, freeMemory, totalScanCount)';
COMMENT ON COLUMN machine_logs.version_info IS '버전 정보 (EdgeMan, ServMan, JetsonMan, Artis_AI, Artis_AI_Model)';
COMMENT ON COLUMN machine_logs.settings IS '설정 정보 (chatID, language, runningDbSync, runningAiTraining)';
COMMENT ON COLUMN machine_logs.last_update IS '마지막 업데이트 시간 (장비에서 전송)';

-- 담당자의 대응 기록 테이블
CREATE TABLE response_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    machine_log_id UUID NOT NULL,
    user_id UUID NOT NULL,
    started_at TIMESTAMPTZ DEFAULT now() NOT NULL,
    completed_at TIMESTAMPTZ,
    memo TEXT,
    created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT now() NOT NULL,
    CONSTRAINT response_logs_machine_log_id_fkey FOREIGN KEY (machine_log_id) REFERENCES machine_logs(id),
    CONSTRAINT response_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id)
);
COMMENT ON TABLE response_logs IS '담당자의 대응 기록';
COMMENT ON COLUMN response_logs.machine_log_id IS '대응 대상 기계 로그 (FK)';
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

-- machine_logs 인덱스
CREATE INDEX idx_machine_logs_serial ON machine_logs(serial_number);
CREATE INDEX idx_machine_logs_company ON machine_logs(company_name);
CREATE INDEX idx_machine_logs_vendor ON machine_logs(vendor_name);
CREATE INDEX idx_machine_logs_error ON machine_logs(error_code);
CREATE INDEX idx_machine_logs_created ON machine_logs(created_at DESC);

-- response_logs 인덱스
CREATE INDEX idx_response_logs_machine_log_id ON response_logs(machine_log_id);
CREATE INDEX idx_response_logs_user_id ON response_logs(user_id);
CREATE INDEX idx_response_logs_started_at ON response_logs(started_at DESC);
CREATE INDEX idx_response_logs_completed_at ON response_logs(completed_at DESC);
CREATE INDEX idx_response_logs_user_started ON response_logs(user_id, started_at DESC);
CREATE INDEX idx_response_logs_user_completed ON response_logs(user_id, completed_at DESC);
CREATE UNIQUE INDEX idx_response_logs_unique_machine ON response_logs(machine_log_id);


-- =============================================
-- 4. RLS 비활성화 (현재 설정 유지)
-- =============================================

ALTER TABLE users DISABLE ROW LEVEL SECURITY;
ALTER TABLE machine_logs DISABLE ROW LEVEL SECURITY;
ALTER TABLE response_logs DISABLE ROW LEVEL SECURITY;


-- =============================================
-- 5. Realtime 활성화
-- =============================================

-- machine_logs 테이블에 Realtime 활성화
ALTER PUBLICATION supabase_realtime ADD TABLE machine_logs;
