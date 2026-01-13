# 테이블 스키마 (public)

## 1. users
직원/담당자 정보

| 컬럼 | 타입 | 옵션 | 기본값 | 설명 |
|------|------|------|--------|------|
| id | uuid | PK | gen_random_uuid() | |
| name | varchar | | | |
| email | varchar | unique | | |
| status | user_status | | 'offline' | 상태: online, offline |
| created_at | timestamptz | | now() | |
| updated_at | timestamptz | | now() | |
| organization_id | uuid | nullable, FK | | 주 소속 조직 |
| role | user_role | nullable | 'member' | admin, manager, member |

## 2. organizations
조직/기관 정보

| 컬럼 | 타입 | 옵션 | 기본값 | 설명 |
|------|------|------|--------|------|
| id | uuid | PK | gen_random_uuid() | |
| name | varchar | | | |
| code | varchar | nullable, unique | | 조직 고유 코드 |
| description | text | nullable | | |
| is_active | boolean | nullable | true | 활성화 여부 |
| created_at | timestamptz | nullable | now() | |
| updated_at | timestamptz | nullable | now() | |

## 3. user_organizations
사용자-조직 연결 (역할 포함)

| 컬럼 | 타입 | 옵션 | 기본값 | 설명 |
|------|------|------|--------|------|
| id | uuid | PK | gen_random_uuid() | |
| user_id | uuid | FK | | |
| organization_id | uuid | FK | | |
| role | user_role | | 'member' | admin, manager, member |
| is_primary | boolean | nullable | false | 주 소속 조직 여부 |
| joined_at | timestamptz | nullable | now() | |
| created_at | timestamptz | nullable | now() | |
| updated_at | timestamptz | nullable | now() | |

## 4. system_logs
범용 이벤트/에러 로그

| 컬럼 | 타입 | 옵션 | 기본값 | 설명 |
|------|------|------|--------|------|
| id | uuid | PK | gen_random_uuid() | |
| source | varchar | | | 로그 출처 (machine, web, app 등) |
| code | varchar | nullable | | 에러 코드 |
| log_level | log_level | nullable | 'info' | info, warning, error, critical |
| payload | jsonb | nullable | '{}' | 상세 데이터 |
| response_status | response_status | nullable | 'unresponded' | unchecked, in_progress, completed, unresponded |
| created_at | timestamptz | nullable | now() | |
| category | log_category | | 'event' | event, health_check |
| current_responder_id | uuid | nullable, FK | | 현재 대응중인 담당자 ID |
| current_responder_name | varchar | nullable | | 현재 대응중인 담당자 이름 |
| response_started_at | timestamptz | nullable | | 대응 시작 시간 |
| organization_id | uuid | nullable, FK | | 이벤트가 발생한 조직 |
| description | text | nullable | | 로그 설명/메시지 |
| attachments | jsonb | nullable | | 첨부파일/미디어 |
| environment | text | | 'production' | development, production |
| assigned_by_id | uuid | nullable, FK | | 할당한 관리자 ID |
| assigned_by_name | varchar | nullable | | 할당한 관리자 이름 |

## 5. response_logs
담당자의 대응 기록

| 컬럼 | 타입 | 옵션 | 기본값 | 설명 |
|------|------|------|--------|------|
| id | uuid | PK | gen_random_uuid() | |
| system_log_id | uuid | FK | | 대응 대상 이벤트 로그 |
| user_id | uuid | FK | | 담당자 |
| started_at | timestamptz | | now() | 대응 시작 시간 |
| completed_at | timestamptz | nullable | | 대응 완료 시간 |
| memo | text | nullable | | 메모/조치 내역 |
| created_at | timestamptz | | now() | |
| updated_at | timestamptz | | now() | |

---

## Enum 타입

### user_status
- online
- offline

### user_role
- admin
- manager
- member

### log_level
- info
- warning
- error
- critical

### log_category
- event
- health_check

### response_status
- unchecked
- in_progress
- completed
- unresponded
