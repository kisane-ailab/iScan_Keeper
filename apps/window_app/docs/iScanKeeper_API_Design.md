# iScanKeeper 실시간 고객 대응 시스템

## 시스템 개요

여러 기계에서 IP, 포트, 상태코드를 POST로 전송하여 로그를 저장하고, 심각한 상태코드 발생 시 담당자에게 실시간 알림을 보내 대응하는 시스템입니다.

---

## 데이터베이스 스키마

### 1. users (직원/담당자)
| 컬럼 | 타입 | 설명 |
|------|------|------|
| `id` | UUID | PK (자동생성) |
| `name` | VARCHAR(100) | 이름 |
| `email` | VARCHAR(255) | 이메일 (UNIQUE) |
| `status` | ENUM | `available`, `busy`, `offline` |
| `created_at` | TIMESTAMPTZ | 생성일시 |
| `updated_at` | TIMESTAMPTZ | 수정일시 (자동) |

### 2. machine_logs (기계 로그)
| 컬럼 | 타입 | 설명 |
|------|------|------|
| `id` | UUID | PK (자동생성) |
| `ip_address` | VARCHAR(45) | IPv4/IPv6 주소 |
| `port_number` | INTEGER | 포트번호 |
| `status_code` | INTEGER | 상태코드 |
| `response_status` | ENUM | `unchecked`, `in_progress`, `completed` |
| `created_at` | TIMESTAMPTZ | 생성일시 |

### 3. response_logs (대응 기록)
| 컬럼 | 타입 | 설명 |
|------|------|------|
| `id` | UUID | PK (자동생성) |
| `machine_log_id` | UUID | FK → machine_logs (UNIQUE) |
| `user_id` | UUID | FK → users |
| `started_at` | TIMESTAMPTZ | 대응 시작 |
| `completed_at` | TIMESTAMPTZ | 대응 완료 (NULL=진행중) |
| `memo` | TEXT | 메모/조치내역 |
| `created_at` | TIMESTAMPTZ | 생성일시 |
| `updated_at` | TIMESTAMPTZ | 수정일시 (자동) |

### 인덱스 목록
| 테이블 | 인덱스명 | 컬럼 | 용도 |
|--------|----------|------|------|
| `machine_logs` | `idx_machine_logs_created_at_desc` | created_at DESC | 최신순 페이지네이션 |
| `machine_logs` | `idx_machine_logs_ip` | ip_address | IP 검색 |
| `machine_logs` | `idx_machine_logs_port` | port_number | 포트 검색 |
| `machine_logs` | `idx_machine_logs_status_code` | status_code | 상태코드 필터 |
| `machine_logs` | `idx_machine_logs_response_status` | response_status | 응답상태 필터 |
| `machine_logs` | `idx_machine_logs_response_created` | (response_status, created_at DESC) | 복합 필터 |
| `response_logs` | `idx_response_logs_user_completed` | (user_id, completed_at DESC) | **사용자별 처리목록** |
| `response_logs` | `idx_response_logs_user_started` | (user_id, started_at DESC) | **사용자별 처리목록** |
| `response_logs` | `idx_response_logs_started_at` | started_at DESC | **날짜별 조회** |
| `response_logs` | `idx_response_logs_completed_at` | completed_at DESC | **날짜별 조회** |

---

## 워크플로우 다이어그램

```
┌─────────────┐     POST /machine-logs      ┌──────────────┐
│   기계들    │ ─────────────────────────▶  │ machine_logs │
│ (다수 장비) │   IP, Port, StatusCode       │   테이블     │
└─────────────┘                              └──────┬───────┘
                                                    │
                                    심각한 status_code 감지
                                      (Realtime 구독)
                                                    │
                                                    ▼
┌─────────────┐     회원가입                 ┌──────────────┐
│   담당자    │ ◀───────────────────────────│    users     │
│  (로그인)   │                              │    테이블    │
└──────┬──────┘                              └──────────────┘
       │
       │  강제 팝업 알림!
       │  "심각한 오류 발생"
       │
       ▼
  ┌─────────────────┐
  │ 담당하시겠습니까? │
  │  [예]    [아니오] │
  └────────┬────────┘
           │
           │ [예] 클릭
           ▼
    ┌─────────────────────────────────────┐
    │        트랜잭션 시작                 │
    │  1. response_logs INSERT            │
    │  2. machine_logs.response_status    │
    │     → 'in_progress'                 │
    │  3. users.status → 'busy'           │
    │        트랜잭션 커밋                 │
    └─────────────────────────────────────┘
           │
           ├──── [취소] 실수로 눌렀을 때 ────┐
           │                                │
           │                                ▼
           │                  ┌─────────────────────────────┐
           │                  │     트랜잭션 시작           │
           │                  │  1. response_logs DELETE    │
           │                  │  2. machine_logs.status     │
           │                  │     → 'unchecked'           │
           │                  │  3. users.status            │
           │                  │     → 'available'           │
           │                  │     트랜잭션 커밋           │
           │                  └─────────────────────────────┘
           │
           ▼
    ┌─────────────────┐
    │   대응 진행중    │
    │  메모 작성 가능  │
    └────────┬────────┘
             │
             │ [완료] 클릭
             ▼
    ┌─────────────────────────────────────┐
    │        트랜잭션 시작                 │
    │  1. response_logs.completed_at SET  │
    │  2. machine_logs.response_status    │
    │     → 'completed'                   │
    │  3. users.status → 'available'      │
    │        트랜잭션 커밋                 │
    └─────────────────────────────────────┘
```

---

## API 목록

### 1. 인증 (Auth)
| Method | Endpoint | 설명 | 트랜잭션 |
|--------|----------|------|:--------:|
| `POST` | `/auth/signup` | 회원가입 → users 생성 | - |
| `POST` | `/auth/login` | 로그인 → status를 'available'로 | ✅ |
| `POST` | `/auth/logout` | 로그아웃 → status를 'offline'로 | ✅ |

### 2. 사용자 (Users)
| Method | Endpoint | 설명 | 트랜잭션 |
|--------|----------|------|:--------:|
| `GET` | `/users` | 담당자 목록 조회 | - |
| `GET` | `/users/:id` | 담당자 상세 조회 | - |
| `PATCH` | `/users/:id/status` | 상태 수동 변경 | - |
| `GET` | `/users/available` | 대기중인 담당자 목록 | - |

### 3. 기계 로그 (Machine Logs)
| Method | Endpoint | 설명 | 트랜잭션 |
|--------|----------|------|:--------:|
| `POST` | `/machine-logs` | 기계에서 로그 전송 (공개 API) | - |
| `GET` | `/machine-logs` | 로그 목록 (페이지네이션) | - |
| `GET` | `/machine-logs/:id` | 로그 상세 조회 | - |
| `GET` | `/machine-logs/unchecked` | 미확인 로그만 조회 | - |
| `GET` | `/machine-logs/critical` | 심각한 상태코드만 조회 | - |

### 4. 대응 (Responses) - 핵심
| Method | Endpoint | 설명 | 트랜잭션 |
|--------|----------|------|:--------:|
| `POST` | `/responses/claim` | **담당 선언** (경쟁 조건 처리) | ✅ |
| `DELETE` | `/responses/:id/cancel` | **담당 취소** (실수로 눌렀을 때) | ✅ |
| `PATCH` | `/responses/:id/complete` | **대응 완료** | ✅ |
| `PATCH` | `/responses/:id/memo` | 메모 수정 | - |
| `GET` | `/responses` | 대응 기록 목록 | - |
| `GET` | `/responses/:id` | 대응 상세 조회 | - |
| `GET` | `/responses/my` | 내 대응 기록 | - |

### 5. 조회/통계 (Query) - 페이지네이션
| Method | Endpoint | 설명 | Query Params |
|--------|----------|------|--------------|
| `GET` | `/responses/by-user/:userId` | **사용자별 처리 목록** | `page`, `limit`, `status` |
| `GET` | `/responses/by-date` | **날짜별 처리 목록** | `page`, `limit`, `from`, `to`, `status` |
| `GET` | `/responses/stats/user/:userId` | 사용자별 통계 | `from`, `to` |
| `GET` | `/responses/stats/daily` | 일별 통계 | `from`, `to` |

### 6. 실시간 (Realtime)
| 채널 | 이벤트 | 설명 |
|------|--------|------|
| `machine_logs` | `INSERT` | 새 로그 감지 → 심각도 체크 → 알림 |
| `machine_logs` | `UPDATE` | 상태 변경 시 UI 동기화 |
| `response_logs` | `INSERT` | 누군가 담당 선언 → 다른 사용자 팝업 닫기 |

---

## 페이지네이션 API 상세

### GET `/responses/by-user/:userId`
특정 사용자가 처리한 대응 목록을 페이지네이션으로 조회

**Query Parameters:**
| 파라미터 | 타입 | 필수 | 기본값 | 설명 |
|----------|------|:----:|--------|------|
| `page` | number | - | 1 | 페이지 번호 |
| `limit` | number | - | 20 | 페이지당 항목 수 (max: 100) |
| `status` | string | - | all | `in_progress`, `completed`, `all` |

**Response:**
```json
{
  "data": [
    {
      "id": "uuid",
      "machine_log": {
        "id": "uuid",
        "ip_address": "192.168.1.100",
        "port_number": 8080,
        "status_code": 500,
        "created_at": "2024-01-15T10:30:00Z"
      },
      "started_at": "2024-01-15T10:31:00Z",
      "completed_at": "2024-01-15T10:45:00Z",
      "memo": "서버 재시작으로 해결"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 150,
    "totalPages": 8
  }
}
```

### GET `/responses/by-date`
날짜 범위로 대응 목록을 페이지네이션으로 조회

**Query Parameters:**
| 파라미터 | 타입 | 필수 | 기본값 | 설명 |
|----------|------|:----:|--------|------|
| `page` | number | - | 1 | 페이지 번호 |
| `limit` | number | - | 20 | 페이지당 항목 수 (max: 100) |
| `from` | string | - | 7일 전 | 시작 날짜 (ISO 8601) |
| `to` | string | - | 오늘 | 종료 날짜 (ISO 8601) |
| `status` | string | - | all | `in_progress`, `completed`, `all` |
| `userId` | string | - | - | 특정 사용자 필터 (optional) |

**Response:**
```json
{
  "data": [
    {
      "id": "uuid",
      "user": {
        "id": "uuid",
        "name": "홍길동",
        "email": "hong@example.com"
      },
      "machine_log": {
        "id": "uuid",
        "ip_address": "192.168.1.100",
        "port_number": 8080,
        "status_code": 500,
        "created_at": "2024-01-15T10:30:00Z"
      },
      "started_at": "2024-01-15T10:31:00Z",
      "completed_at": "2024-01-15T10:45:00Z",
      "memo": "서버 재시작으로 해결"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 45,
    "totalPages": 3
  }
}
```

### GET `/responses/stats/user/:userId`
특정 사용자의 대응 통계

**Response:**
```json
{
  "userId": "uuid",
  "userName": "홍길동",
  "period": {
    "from": "2024-01-01",
    "to": "2024-01-31"
  },
  "stats": {
    "totalResponses": 45,
    "completed": 42,
    "inProgress": 3,
    "avgResponseTime": "14m 32s"
  }
}
```

### GET `/responses/stats/daily`
일별 대응 통계

**Response:**
```json
{
  "period": {
    "from": "2024-01-01",
    "to": "2024-01-07"
  },
  "daily": [
    { "date": "2024-01-01", "total": 12, "completed": 12 },
    { "date": "2024-01-02", "total": 8, "completed": 7 },
    { "date": "2024-01-03", "total": 15, "completed": 15 }
  ]
}
```

---

## 트랜잭션이 필요한 핵심 로직

### 1. 담당 선언 (`POST /responses/claim`)

```sql
BEGIN;
  -- 1. 이미 다른 사람이 담당했는지 확인 (경쟁 조건 방지)
  SELECT id FROM response_logs
  WHERE machine_log_id = $1 FOR UPDATE;

  -- 2. response_logs 생성
  INSERT INTO response_logs (machine_log_id, user_id)
  VALUES ($1, $2);

  -- 3. machine_logs 상태 변경
  UPDATE machine_logs
  SET response_status = 'in_progress'
  WHERE id = $1;

  -- 4. users 상태 변경
  UPDATE users SET status = 'busy' WHERE id = $2;
COMMIT;
```

### 2. 담당 취소 (`DELETE /responses/:id/cancel`)

```sql
BEGIN;
  -- 1. response_logs에서 machine_log_id 조회
  SELECT machine_log_id, user_id FROM response_logs
  WHERE id = $1;

  -- 2. response_logs 삭제
  DELETE FROM response_logs WHERE id = $1;

  -- 3. machine_logs 상태 복원
  UPDATE machine_logs
  SET response_status = 'unchecked'
  WHERE id = $machine_log_id;

  -- 4. users 상태 복원
  UPDATE users SET status = 'available' WHERE id = $user_id;
COMMIT;
```

### 3. 대응 완료 (`PATCH /responses/:id/complete`)

```sql
BEGIN;
  -- 1. response_logs 완료 처리
  UPDATE response_logs
  SET completed_at = NOW(), memo = $memo
  WHERE id = $1;

  -- 2. machine_logs 상태 변경
  UPDATE machine_logs
  SET response_status = 'completed'
  WHERE id = $machine_log_id;

  -- 3. users 상태 복원
  UPDATE users SET status = 'available' WHERE id = $user_id;
COMMIT;
```

---

## API 개수 요약

| 카테고리 | 개수 |
|----------|------|
| Auth | 3 |
| Users | 4 |
| Machine Logs | 5 |
| Responses | 7 |
| Query/Stats | 4 |
| **합계** | **23개** |

---

## 구현 고려사항

### 경쟁 조건 (Race Condition) 처리
- 여러 담당자가 동시에 "담당" 버튼을 누를 수 있음
- `SELECT ... FOR UPDATE`로 행 잠금
- `response_logs.machine_log_id`에 UNIQUE 제약조건으로 중복 방지

### 실시간 알림 구현
- Supabase Realtime을 사용하여 `machine_logs` 테이블 구독
- 심각한 `status_code` (예: 500번대) 감지 시 클라이언트에 알림
- 담당자가 선언되면 다른 사용자의 팝업 자동 닫기

### 상태코드 기준 (예시)
| 코드 범위 | 심각도 | 알림 |
|-----------|--------|------|
| 200-299 | 정상 | X |
| 400-499 | 경고 | 선택적 |
| 500-599 | 심각 | 강제 팝업 |

### 페이지네이션 성능 최적화
- Cursor 기반 페이지네이션 권장 (대용량 데이터)
- 복합 인덱스 활용: `(user_id, completed_at DESC)`
- LIMIT + OFFSET 대신 `WHERE completed_at < $cursor` 사용 고려
