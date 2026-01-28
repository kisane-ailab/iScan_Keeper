-- =============================================
-- response_logs 테이블 마크다운 에디터 지원
-- 최종 업데이트: 2026-01-27
-- =============================================

-- =============================================
-- 1. response_logs에 content, attachments 컬럼 추가
-- =============================================

-- content: 마크다운 및 Delta 포맷 저장
-- {
--   "markdown": "## 조치내역\n- 서버 재시작...",
--   "delta": { ... },
--   "version": 1
-- }
ALTER TABLE response_logs
ADD COLUMN IF NOT EXISTS content JSONB DEFAULT '{}'::jsonb;

-- attachments: 첨부파일 목록
-- [
--   {
--     "id": "uuid",
--     "url": "https://...supabase.co/storage/...",
--     "type": "image",
--     "name": "screenshot.jpg",
--     "size": 102400
--   }
-- ]
ALTER TABLE response_logs
ADD COLUMN IF NOT EXISTS attachments JSONB DEFAULT '[]'::jsonb;

COMMENT ON COLUMN response_logs.content IS '마크다운/Delta 콘텐츠 (JSONB)';
COMMENT ON COLUMN response_logs.attachments IS '첨부파일 목록 (JSONB 배열)';


-- =============================================
-- 2. 기존 memo 데이터 마이그레이션
-- =============================================

-- 기존 memo 컬럼의 텍스트를 content.markdown으로 마이그레이션
UPDATE response_logs
SET content = jsonb_build_object(
    'markdown', COALESCE(memo, ''),
    'version', 1
)
WHERE memo IS NOT NULL
  AND memo != ''
  AND (content = '{}'::jsonb OR content IS NULL);


-- =============================================
-- 3. 인덱스 생성
-- =============================================

-- GIN 인덱스: JSONB 검색 최적화
CREATE INDEX IF NOT EXISTS idx_response_logs_content
ON response_logs USING GIN (content);

CREATE INDEX IF NOT EXISTS idx_response_logs_attachments
ON response_logs USING GIN (attachments);


-- =============================================
-- 4. Storage 버킷 생성 (수동 실행 필요)
-- =============================================
-- 아래 명령은 Supabase 대시보드 또는 Storage API를 통해 실행해야 합니다:
--
-- 버킷명: response-attachments
-- 공개 설정: Public (이미지 직접 접근)
-- 파일 크기 제한: 5MB
-- 허용 MIME: image/jpeg, image/png, image/webp, image/gif
--
-- SQL로는 직접 생성 불가 - Supabase Dashboard에서 생성:
-- 1. Storage > New bucket
-- 2. Name: response-attachments
-- 3. Public bucket: ON
-- 4. Allowed MIME types: image/jpeg, image/png, image/webp, image/gif
-- 5. File size limit: 5MB
