-- system_logs 테이블에 is_muted 컬럼 추가
-- nullable, 기본값 없음 (null이면 mute 안됨)
ALTER TABLE public.system_logs
ADD COLUMN is_muted boolean DEFAULT NULL;

COMMENT ON COLUMN public.system_logs.is_muted IS '알림 무시 여부 (true: 무시됨, null/false: 정상)';
