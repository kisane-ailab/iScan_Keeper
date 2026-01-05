# iScanKeeper

iScan 장비 모니터링 및 관리 시스템

## 프로젝트 구조

```
iScan_Keeper/
└── apps/
    ├── window_app/      # Flutter Windows 앱
    └── dashboard_web/   # Next.js 대시보드 웹
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

## Dashboard Web 배포

```bash
cd apps/dashboard_web
deploy.bat
```

> deploy.bat이 빌드, 압축, 업로드, PM2 재시작을 자동으로 처리합니다.

## 컨벤션

커밋 및 브랜치 컨벤션은 [CONTRIBUTING.md](./CONTRIBUTING.md) 참고
