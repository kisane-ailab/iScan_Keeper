# Supabase 마이그레이션 가이드

싱가포르 리전에서 한국 리전으로 Supabase 프로젝트 마이그레이션을 위한 파일들입니다.

## 폴더 구조

```
supabase/
├── migrations/
│   └── 00001_initial_schema.sql    # 전체 스키마 (테이블, ENUM, 인덱스, Realtime)
├── functions/
│   └── machine-logs/
│       └── index.ts                 # Edge Function 코드
└── README.md
```

## 마이그레이션 순서

### 1. 새 Supabase 프로젝트 생성 (한국 리전)
- https://supabase.com/dashboard 에서 새 프로젝트 생성
- 리전: **Northeast Asia (Seoul)** 선택

### 2. 스키마 마이그레이션
1. Supabase Dashboard → SQL Editor 이동
2. `migrations/00001_initial_schema.sql` 내용 복사하여 실행

### 3. Edge Function 배포
```bash
# Supabase CLI 로그인
supabase login

# 프로젝트 연결
supabase link --project-ref <새_프로젝트_ID>

# Edge Function 배포 (JWT 검증 비활성화)
supabase functions deploy machine-logs --no-verify-jwt
```

### 4. 환경 변수 확인
Edge Function은 다음 환경 변수를 자동으로 사용합니다:
- `SUPABASE_URL`
- `SUPABASE_SERVICE_ROLE_KEY`

### 5. 클라이언트 설정 업데이트
앱의 `.env` 파일에서 Supabase URL과 API Key를 새 프로젝트 값으로 변경하세요.

## 현재 설정 요약

| 항목 | 설정 |
|------|------|
| RLS | 모든 테이블 비활성화 |
| Realtime | machine_logs 테이블 활성화 |
| Edge Functions | machine-logs (JWT 비활성화) |

## 데이터 마이그레이션

기존 데이터를 마이그레이션하려면:

```sql
-- 기존 프로젝트에서 데이터 추출
COPY users TO '/tmp/users.csv' WITH CSV HEADER;
COPY machine_logs TO '/tmp/machine_logs.csv' WITH CSV HEADER;
COPY response_logs TO '/tmp/response_logs.csv' WITH CSV HEADER;

-- 새 프로젝트에서 데이터 삽입
COPY users FROM '/tmp/users.csv' WITH CSV HEADER;
COPY machine_logs FROM '/tmp/machine_logs.csv' WITH CSV HEADER;
COPY response_logs FROM '/tmp/response_logs.csv' WITH CSV HEADER;
```

또는 Supabase Dashboard의 Table Editor에서 CSV로 Export/Import 가능합니다.
