-- system_logs 테이블에 updated_at 컬럼 추가
-- 자동 업데이트 트리거 포함

-- updated_at 컬럼 추가 (기본값: created_at과 동일)
ALTER TABLE public.system_logs
ADD COLUMN updated_at TIMESTAMPTZ DEFAULT now();

-- 기존 데이터의 updated_at을 created_at으로 설정
UPDATE public.system_logs
SET updated_at = created_at
WHERE updated_at IS NULL;

-- updated_at 컬럼 NOT NULL 제약조건 추가
ALTER TABLE public.system_logs
ALTER COLUMN updated_at SET NOT NULL;

COMMENT ON COLUMN public.system_logs.updated_at IS '마지막 업데이트 시간';

-- updated_at 자동 업데이트 트리거 함수
CREATE OR REPLACE FUNCTION update_system_logs_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 트리거 생성 (UPDATE 시 자동 updated_at 갱신)
CREATE TRIGGER trigger_update_system_logs_updated_at
    BEFORE UPDATE ON system_logs
    FOR EACH ROW
    EXECUTE FUNCTION update_system_logs_updated_at();

-- updated_at 인덱스 추가
CREATE INDEX idx_system_logs_updated_at ON system_logs(updated_at DESC);
