-- =============================================
-- 데이터셋 워크플로우 스키마
-- 최종 업데이트: 2026-01-27
-- =============================================

-- =============================================
-- 1. ENUM 타입 생성
-- =============================================

-- 데이터셋 상태 ENUM
CREATE TYPE dataset_state AS ENUM (
    's2_registered',      -- DB 등록됨
    's3_in_review',       -- 리뷰 중
    's4_review_done',     -- 리뷰 완료
    's5_admin_decision',  -- 관리자 결정 대기
    's6_published'        -- 퍼블리시 완료
);
COMMENT ON TYPE dataset_state IS '데이터셋 워크플로우 상태';

-- 관리자 결정 ENUM
CREATE TYPE admin_decision AS ENUM (
    'pending',   -- 결정 대기
    'approved',  -- 승인
    'rejected'   -- 반려
);
COMMENT ON TYPE admin_decision IS '관리자 승인/반려 결정';


-- =============================================
-- 2. 테이블 생성
-- =============================================

-- 데이터셋 테이블
CREATE TABLE datasets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- 기본 정보
    name VARCHAR NOT NULL,
    description TEXT,
    source_path VARCHAR NOT NULL,
    metadata JSONB DEFAULT '{}'::jsonb,

    -- 워크플로우 상태
    state dataset_state DEFAULT 's2_registered' NOT NULL,
    admin_decision admin_decision DEFAULT 'pending' NOT NULL,
    rejection_reason TEXT,

    -- 리뷰어 정보
    reviewer_id UUID REFERENCES users(id),
    reviewer_name VARCHAR,
    review_started_at TIMESTAMPTZ,
    review_completed_at TIMESTAMPTZ,
    review_note TEXT,

    -- 승인자 정보
    approver_id UUID REFERENCES users(id),
    approver_name VARCHAR,
    approved_at TIMESTAMPTZ,

    -- 퍼블리시 정보
    published_at TIMESTAMPTZ,
    published_path VARCHAR,

    -- 공통 필드
    environment VARCHAR DEFAULT 'production',
    organization_id UUID REFERENCES organizations(id),
    created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT now() NOT NULL
);

COMMENT ON TABLE datasets IS 'AI 학습용 데이터셋';
COMMENT ON COLUMN datasets.name IS '데이터셋 이름';
COMMENT ON COLUMN datasets.description IS '데이터셋 설명';
COMMENT ON COLUMN datasets.source_path IS '원본 데이터 경로';
COMMENT ON COLUMN datasets.metadata IS '추가 메타데이터 (JSONB)';
COMMENT ON COLUMN datasets.state IS '워크플로우 상태';
COMMENT ON COLUMN datasets.admin_decision IS '관리자 결정 (pending/approved/rejected)';
COMMENT ON COLUMN datasets.rejection_reason IS '반려 사유';
COMMENT ON COLUMN datasets.reviewer_id IS '리뷰어 ID (FK)';
COMMENT ON COLUMN datasets.reviewer_name IS '리뷰어 이름';
COMMENT ON COLUMN datasets.review_started_at IS '리뷰 시작 시간';
COMMENT ON COLUMN datasets.review_completed_at IS '리뷰 완료 시간';
COMMENT ON COLUMN datasets.review_note IS '리뷰 노트';
COMMENT ON COLUMN datasets.approver_id IS '승인자 ID (FK)';
COMMENT ON COLUMN datasets.approver_name IS '승인자 이름';
COMMENT ON COLUMN datasets.approved_at IS '승인/반려 결정 시간';
COMMENT ON COLUMN datasets.published_at IS '퍼블리시 시간';
COMMENT ON COLUMN datasets.published_path IS '퍼블리시된 경로';
COMMENT ON COLUMN datasets.environment IS '환경 (production/development)';
COMMENT ON COLUMN datasets.organization_id IS '소속 조직 (FK)';


-- =============================================
-- 3. 인덱스 생성
-- =============================================

CREATE INDEX idx_datasets_state ON datasets(state);
CREATE INDEX idx_datasets_admin_decision ON datasets(admin_decision);
CREATE INDEX idx_datasets_reviewer_id ON datasets(reviewer_id);
CREATE INDEX idx_datasets_approver_id ON datasets(approver_id);
CREATE INDEX idx_datasets_created_at ON datasets(created_at DESC);
CREATE INDEX idx_datasets_organization ON datasets(organization_id);
CREATE INDEX idx_datasets_environment ON datasets(environment);
CREATE INDEX idx_datasets_metadata ON datasets USING GIN (metadata);


-- =============================================
-- 4. RLS 비활성화 (현재 설정 유지)
-- =============================================

ALTER TABLE datasets DISABLE ROW LEVEL SECURITY;


-- =============================================
-- 5. Realtime 활성화
-- =============================================

ALTER PUBLICATION supabase_realtime ADD TABLE datasets;


-- =============================================
-- 6. 트리거: updated_at 자동 갱신
-- =============================================

CREATE OR REPLACE FUNCTION update_datasets_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_datasets_updated_at
    BEFORE UPDATE ON datasets
    FOR EACH ROW
    EXECUTE FUNCTION update_datasets_updated_at();


-- =============================================
-- 7. 트리거: 상태 전이 검증
-- =============================================

CREATE OR REPLACE FUNCTION validate_dataset_state_transition()
RETURNS TRIGGER AS $$
BEGIN
    -- 허용된 상태 전이만 허용
    -- s2_registered -> s3_in_review (리뷰 시작)
    -- s3_in_review -> s4_review_done (리뷰 완료)
    -- s4_review_done -> s5_admin_decision (리뷰 제출)
    -- s5_admin_decision -> s6_published (승인 후 퍼블리시)
    -- s5_admin_decision -> s3_in_review (반려 후 재리뷰)

    IF OLD.state = NEW.state THEN
        RETURN NEW;
    END IF;

    -- 유효한 전이 체크
    IF (OLD.state = 's2_registered' AND NEW.state = 's3_in_review') OR
       (OLD.state = 's3_in_review' AND NEW.state = 's4_review_done') OR
       (OLD.state = 's4_review_done' AND NEW.state = 's5_admin_decision') OR
       (OLD.state = 's5_admin_decision' AND NEW.state = 's6_published') OR
       (OLD.state = 's5_admin_decision' AND NEW.state = 's3_in_review') THEN
        RETURN NEW;
    END IF;

    RAISE EXCEPTION 'Invalid state transition from % to %', OLD.state, NEW.state;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_validate_dataset_state_transition
    BEFORE UPDATE ON datasets
    FOR EACH ROW
    WHEN (OLD.state IS DISTINCT FROM NEW.state)
    EXECUTE FUNCTION validate_dataset_state_transition();
