# Supabase 설정 가이드

## 폴더 구조

```
supabase/
├── migrations/
│   └── 00001_initial_schema.sql    # 전체 스키마 (테이블, ENUM, 인덱스, Realtime)
├── functions/
│   └── event-logs/
│       └── index.ts                 # Edge Function 코드
└── README.md
```

## 테이블 구조

### event_logs (범용 이벤트/에러 로그)
| 컬럼 | 타입 | 설명 |
|------|------|------|
| id | UUID | PK |
| source | VARCHAR | 로그 출처 (machine, web, app 등) |
| error_code | VARCHAR | 에러 코드 |
| log_level | VARCHAR | 로그 레벨 (info, warning, error) |
| payload | JSONB | 상세 데이터 |
| response_status | ENUM | 대응 상태 (unchecked, in_progress, completed) |
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

## Edge Function 사용법

### event-logs
```bash
curl -X POST https://<PROJECT_REF>.supabase.co/functions/v1/event-logs \
  -H "Content-Type: application/json" \
  -d '{
    "source": "machine",
    "errorCode": "E001",
    "logLevel": "error",
    "payload": {
      "serialNumber": "SN-001",
      "ipAddress": "192.168.1.1",
      "additionalInfo": "..."
    }
  }'
```

## 현재 설정 요약

| 항목 | 설정 |
|------|------|
| RLS | 모든 테이블 비활성화 |
| Realtime | event_logs 테이블 활성화 |
| Edge Functions | event-logs (JWT 비활성화) |

## 배포 명령어

```bash
# Supabase CLI 로그인
supabase login

# 프로젝트 연결
supabase link --project-ref <프로젝트_ID>

# Edge Function 배포 (JWT 검증 비활성화)
supabase functions deploy event-logs --no-verify-jwt
```
