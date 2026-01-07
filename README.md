# iScanKeeper

iScan 장비 모니터링 및 관리 시스템

## 프로젝트 구조

```
iScan_Keeper/
├── .github/workflows/     # GitHub Actions
├── releases/              # 업데이트 메타데이터
└── apps/
    ├── window_app/        # Flutter Windows 앱
    └── dashboard_web/     # Next.js 대시보드 웹
```

## 환경 설정

최상단 `.env` 파일에 서버 정보 설정 (`.env.example` 참고)

## Flutter 앱

자세한 내용은 [apps/window_app/README.md](./apps/window_app/README.md) 참고

```bash
cd apps/window_app
fvm flutter pub get
fvm flutter pub run build_runner build --delete-conflicting-outputs
fvm flutter run
```

## Windows 앱 배포

### 설치 및 업데이트 흐름

```
┌─────────────────────────────────────────────────────────────┐
│  최초 설치                                                   │
│  ─────────                                                   │
│  사용자가 iScanKeeper_Setup_x.x.x.exe 실행                   │
│  → 설치 마법사 → 시작 메뉴/바탕화면 바로가기 생성 → 완료     │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  이후 업데이트 (자동)                                        │
│  ─────────────────────                                       │
│  앱 실행 시 자동으로 새 버전 확인 → 다이얼로그 → 업데이트     │
│  (인스톨러 다시 받을 필요 없음, desktop_updater가 처리)       │
└─────────────────────────────────────────────────────────────┘
```

---

## 최초 인스톨러 만들기 (Inno Setup)

### Step 1: Inno Setup 설치

1. https://jrsoftware.org/isdl.php 에서 **Inno Setup 6** 다운로드
2. 설치 진행 (기본 옵션으로 OK)
3. 설치 완료 후 자동으로 PATH에 추가됨
   - 기본 경로: `C:\Program Files (x86)\Inno Setup 6`

### Step 2: Flutter 릴리스 빌드

```bash
cd apps/window_app
flutter build windows --release
```

결과물: `build/windows/x64/runner/Release/` 폴더에 실행 파일 생성

### Step 3: 인스톨러 생성

**방법 A: 배치 파일 사용 (권장)**
```bash
cd apps/window_app
build_installer.bat
```

**방법 B: 직접 실행**
```bash
cd apps/window_app
iscc installer/iScanKeeper.iss
```

### Step 4: 결과 확인

```
build/installer/iScanKeeper_Setup_1.0.0.exe  (약 68MB)
```

이 파일 하나만 사용자에게 전달하면 됩니다!

### 사용자 설치 방법

1. `iScanKeeper_Setup_1.0.0.exe` 더블클릭
2. 설치 마법사 따라 진행
3. 완료 후 바탕화면 또는 시작 메뉴에서 실행

> 인증서 설치 등 추가 작업 없이 바로 설치 가능

---

## 버전 업데이트 릴리스

### 로컬에서 업데이트 빌드

```bash
cd apps/window_app

# 1. 릴리스 빌드 (desktop_updater CLI)
dart run desktop_updater:release windows

# 2. 아카이브 생성 (hashes.json 포함)
dart run desktop_updater:archive windows

# 결과: dist/1/1.0.0+1-windows/ 폴더
```

### GitHub Actions 자동 릴리스

```bash
# 1. pubspec.yaml 버전 업데이트
# version: 1.0.1+2

# 2. (선택) installer/iScanKeeper.iss 버전 업데이트
# #define MyAppVersion "1.0.1"

# 3. 커밋 및 태그
git add .
git commit -m "chore: Bump version to 1.0.1"
git tag window-app/v1.0.1
git push origin main --tags
```

GitHub Actions가 자동으로:
1. `desktop_updater:release` 및 `desktop_updater:archive` 실행
2. ZIP 파일 생성 후 GitHub Release에 업로드
3. `releases/app-archive.json` 자동 업데이트

---

## 앱 내 자동 업데이트 동작

1. 앱 시작 3초 후 `releases/app-archive.json`에서 새 버전 확인
2. 새 버전 발견 시 업데이트 다이얼로그 표시
3. 사용자가 "업데이트" 클릭 → 다운로드 → 앱 재시작
4. 설정 → 앱 정보에서 수동 확인도 가능

---

## 환경 변수

`.env` 파일에 다음 설정 필요:
```
GITHUB_OWNER=kisane
GITHUB_REPO=iScan_Keeper
```

---

## 파일 구조 요약

```
apps/window_app/
├── installer/
│   └── iScanKeeper.iss          # Inno Setup 스크립트
├── build_installer.bat           # 인스톨러 빌드 스크립트
├── build/
│   ├── windows/x64/runner/Release/  # Flutter 빌드 결과
│   └── installer/
│       └── iScanKeeper_Setup_1.0.0.exe  # 최종 인스톨러
└── dist/
    └── 1/1.0.0+1-windows/        # desktop_updater 아카이브
```

---

## Dashboard Web 배포

```bash
cd apps/dashboard_web
deploy.bat
```

> deploy.bat이 빌드, 압축, 업로드, PM2 재시작을 자동으로 처리합니다.

## 컨벤션

커밋 및 브랜치 컨벤션은 [CONTRIBUTING.md](./CONTRIBUTING.md) 참고
