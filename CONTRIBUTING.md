# iScanKeeper 모노레포 컨벤션

## 프로젝트 구조

```
iScan_Keeper/
└── apps/
    ├── window_app/      # Flutter Windows 앱
    └── dashboard_web/   # Next.js 대시보드 웹
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

### 브랜치 플로우

```
main
 ├── app-main ← app-dev
 └── web-main ← web-dev
```

- 기능 개발: `app-dev` 또는 `web-dev`에서 작업
- 배포 준비: `app-main` 또는 `web-main`으로 머지
- 전체 릴리즈: `main`으로 머지

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
| `[All]` | 전체 프로젝트 공통 |

### 예시

```bash
# 새 기능
feat: [App] 로그인 화면 추가
feat: [Web] 대시보드 차트 컴포넌트 구현

# 버그 수정
fix: [App] 윈도우 크기 조절 시 크래시 수정
fix: [Web] API 호출 타임아웃 처리

# 리팩토링
refactor: [App] 상태 관리 로직 분리
refactor: [Web] 컴포넌트 폴더 구조 정리

# 기타
docs: [All] 컨트리뷰팅 가이드 추가
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
