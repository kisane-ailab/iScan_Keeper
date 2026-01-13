# iScanKeeper 모노레포 컨벤션

## 프로젝트 구조

```
iScan_Keeper/
├── apps/
│   ├── window_app/      # Flutter Windows 앱
│   └── dashboard_web/   # Next.js 대시보드 웹
└── supabase/
    ├── migrations/      # DB 스키마 변경 SQL
    └── functions/       # Edge Functions 백업
```

---

## 브랜치 전략

| 브랜치 | 설명 |
|--------|------|
| `main` | 전체 프로젝트 안정 버전 |
| `app-main` | Window App 배포 버전 |
| `app-dev` | Window App 개발 브랜치 |
| `web-main` | Dashboard Web 배포 버전 |
| `web-dev` | Dashboard Web 개발 브랜치 |
| `back-main` | Supabase 백엔드 배포 버전 |
| `back-dev` | Supabase 백엔드 개발 브랜치 |

### 브랜치 플로우

```
main
 ├── app-main ← app-dev
 ├── web-main ← web-dev
 └── back-main ← back-dev
```

- 기능 개발: `app-dev`, `web-dev`, `back-dev`에서 작업
- 배포 준비: 각 `-main` 브랜치로 머지
- 전체 릴리즈: `main`으로 머지

### 기능 브랜치 네이밍

이슈 번호를 기반으로 브랜치를 생성합니다.

#### 형식

```
<타입>/#<이슈번호>
```

#### 타입

| 타입 | 설명 |
|------|------|
| `feat` | 새로운 기능 추가 |
| `fix` | 버그 수정 |

#### 예시

```
feat/#12
fix/#45
feat/#78
```

---

## 작업 흐름

1. 이슈 생성 (버그 리포트 또는 기능 요청)
2. 이슈 번호 확인
3. 브랜치 생성: `feat/#이슈번호` 또는 `fix/#이슈번호`
4. 작업 완료 후 PR 생성
5. PR에서 `Closes #이슈번호`로 이슈 연결

---

## 커밋 컨벤션

### 형식

```
<type>: [Scope] <description>
```

### Type (필수)

| Type | 설명 |
|------|------|
| `feat` | 새로운 기능 추가 |
| `fix` | 버그 수정 |
| `refactor` | 코드 리팩토링 (기능 변경 없음) |
| `style` | 코드 포맷팅, 세미콜론 누락 등 |
| `docs` | 문서 수정 |
| `test` | 테스트 코드 추가/수정 |
| `chore` | 빌드, 설정 파일 수정 |
| `perf` | 성능 개선 |

### Scope (필수)

| Scope | 설명 |
|-------|------|
| `[App]` | Window App (Flutter) 관련 |
| `[Web]` | Dashboard Web (Next.js) 관련 |
| `[Back]` | Supabase 백엔드 (DB, Edge Functions) 관련 |
| `[All]` | 전체 프로젝트 공통 |

### 예시

```bash
# 새 기능
feat: [App] 로그인 화면 추가
feat: [Web] 대시보드 차트 컴포넌트 구현
feat: [Back] responses Edge Function 추가

# 버그 수정
fix: [App] 윈도우 크기 조절 시 크래시 수정
fix: [Web] API 호출 타임아웃 처리
fix: [Back] event_logs RLS 정책 수정

# 리팩토링
refactor: [App] 상태 관리 로직 분리
refactor: [Web] 컴포넌트 폴더 구조 정리
refactor: [Back] 마이그레이션 파일 정리

# 기타
docs: [All] 컨트리뷰팅 가이드 추가
docs: [Back] Edge Functions API 문서화
chore: [Web] 패키지 의존성 업데이트
style: [App] 코드 포맷팅 적용
```

---

## 개발 환경

### Window App (Flutter)

```bash
cd apps/window_app
flutter pub get
flutter run -d windows
```

### Dashboard Web (Next.js)

```bash
cd apps/dashboard_web
npm install
npm run dev
```

### Supabase 백엔드

`supabase/` 폴더는 Supabase DB 및 Edge Functions의 백업/문서화 용도입니다.

```
supabase/
├── migrations/          # DB 스키마 변경 SQL 백업
│   └── YYYYMMDD_description.sql
└── functions/           # Edge Functions 코드 백업
    ├── event-logs/
    ├── responses/
    ├── users/
    └── stats/
```

**용도**:
- DB 스키마 변경 시 마이그레이션 SQL 백업
- Edge Functions 배포 코드 버전 관리
- API 변경 이력 문서화
