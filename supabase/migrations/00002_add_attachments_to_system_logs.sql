-- =============================================
-- system_logs에 첨부파일/이미지 URL 저장용 JSONB 컬럼 추가
-- 작성일: 2026-01-08
-- =============================================

-- attachments 컬럼 추가
ALTER TABLE system_logs
ADD COLUMN IF NOT EXISTS attachments JSONB DEFAULT '[]'::jsonb;

-- 컬럼 설명
COMMENT ON COLUMN system_logs.attachments IS '첨부파일 목록 (이미지 URL, 파일 경로 등) - 예: [{"type": "image", "url": "https://..."}, {"type": "file", "path": "/logs/error.log"}]';

-- GIN 인덱스 추가 (JSONB 검색 성능)
CREATE INDEX IF NOT EXISTS idx_system_logs_attachments ON system_logs USING GIN (attachments);
