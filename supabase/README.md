# Supabase 백엔드 백업

이 폴더는 Supabase DB 스키마 및 Edge Functions의 백업/문서화 용도입니다.

## 폴더 구조

```
supabase/
├── migrations/
│   └── 00001_initial_schema.sql    # 전체 스키마 (테이블, ENUM, 인덱스, Realtime)
├── functions/
│   ├── event-logs/                  # 이벤트 로그 생성 (공개 API)
│   ├── responses/                   # 대응 관리 (claim, cancel, complete)
│   ├── users/                       # 사용자 관리 (CRUD, 상태)
│   └── stats/                       # 통계 API
└── README.md
```

## 테이블 구조

### event_logs (범용 이벤트/에러 로그)
| 컬럼 | 타입 | 설명 |
|------|------|------|
| id | UUID | PK |
| source | VARCHAR | 로그 출처 (machine, web, app 등) |
| event_type | ENUM | 로그 유형 (event, health_check) |
| error_code | VARCHAR | 에러 코드 |
| log_level | ENUM | 로그 레벨 (info, warning, error, critical) |
| payload | JSONB | 상세 데이터 |
| response_status | ENUM | 대응 상태 (unchecked, in_progress, completed) |
| current_responder_id | UUID | 현재 대응중인 담당자 ID |
| current_responder_name | VARCHAR | 현재 대응중인 담당자 이름 |
| response_started_at | TIMESTAMPTZ | 대응 시작 시간 |
| created_at | TIMESTAMPTZ | 생성 시간 |

### users (직원/담당자)
| 컬럼 | 타입 | 설명 |
|------|------|------|
| id | UUID | PK |
| name | VARCHAR | 이름 |
| email | VARCHAR | 이메일 (UNIQUE) |
| status | ENUM | 상태 (available, busy, offline) |

### response_logs (대응 기록)
| 컬럼 | 타입 | 설명 |
|------|------|------|
| id | UUID | PK |
| event_log_id | UUID | FK → event_logs |
| user_id | UUID | FK → users |
| started_at | TIMESTAMPTZ | 대응 시작 시간 |
| completed_at | TIMESTAMPTZ | 완료 시간 |
| memo | TEXT | 메모 |

---

## Edge Functions

### 1. event-logs (JWT: false)
외부 기기에서 이벤트 로그를 생성하는 공개 API

```bash
# POST /event-logs - 이벤트 로그 생성
curl -X POST https://<PROJECT_REF>.supabase.co/functions/v1/event-logs \
  -H "Content-Type: application/json" \
  -d '{
    "source": "machine",
    "eventType": "event",
    "errorCode": "E001",
    "logLevel": "error",
    "payload": { "serialNumber": "SN-001" }
  }'
```

### 2. responses (JWT: true)
대응 관리 API

| Method | Endpoint | 설명 |
|--------|----------|------|
| POST | /responses/claim | 담당 선언 |
| DELETE | /responses/:id/cancel | 담당 취소 (포기) |
| PATCH | /responses/:id/complete | 대응 완료 |
| PATCH | /responses/:id/memo | 메모 수정 |
| GET | /responses | 대응 목록 (페이지네이션) |
| GET | /responses/my?userId=xxx | 내 대응 기록 |
| GET | /responses/:id | 대응 상세 |

### 3. users (JWT: true)
사용자 관리 API

| Method | Endpoint | 설명 |
|--------|----------|------|
| GET | /users | 사용자 목록 |
| GET | /users/available | 대기중 사용자 |
| GET | /users/me | 현재 로그인 사용자 |
| GET | /users/:id | 사용자 상세 |
| POST | /users | 사용자 생성 |
| PATCH | /users/:id/status | 상태 변경 |

### 4. stats (JWT: true)
통계 API

| Method | Endpoint | 설명 |
|--------|----------|------|
| GET | /stats/overview | 전체 개요 통계 |
| GET | /stats/user/:userId | 사용자별 통계 |
| GET | /stats/daily | 일별 통계 |
| GET | /stats/by-user/:userId | 사용자별 대응 목록 |
| GET | /stats/by-date | 날짜별 대응 목록 |

---

## 현재 설정 요약

| 항목 | 설정 |
|------|------|
| RLS | 모든 테이블 비활성화 |
| Realtime | event_logs 테이블 활성화 (INSERT, UPDATE) |
| Edge Functions | event-logs (공개), responses/users/stats (JWT 필요) |

## 배포 명령어

```bash
# Supabase CLI 로그인
supabase login

# 프로젝트 연결
supabase link --project-ref <프로젝트_ID>

# Edge Function 배포
supabase functions deploy event-logs --no-verify-jwt
supabase functions deploy responses
supabase functions deploy users
supabase functions deploy stats
```
