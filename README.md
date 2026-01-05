# iScanKeeper

iScan 장비 모니터링 및 관리 시스템

## 프로젝트 구조

```
iScan_Keeper/
└── apps/
    ├── window_app/      # Flutter Windows 앱
    └── dashboard_web/   # Next.js 대시보드 웹
```

## Dashboard Web 배포

### 배포 URL
- **운영 서버**: http://58.238.37.52:60500

### 배포 방법

`apps/dashboard_web` 폴더에서 `deploy.bat` 실행

```bash
cd apps/dashboard_web
deploy.bat
```

### 배포 프로세스

| 단계 | 설명 |
|------|------|
| 1/5 | Next.js 프로젝트 빌드 (`npm run build`) |
| 2/5 | standalone 파일 압축 (`dashboard_standalone.tar.gz`) |
| 3/5 | 배포 스크립트 생성 |
| 4/5 | 서버 업로드 및 PM2 재시작 |
| 5/5 | 임시 파일 정리 |

### 서버 정보

| 항목 | 값 |
|------|-----|
| 호스트 | 58.238.37.52 |
| 포트 | 60500 |
| 경로 | /home/iscan/Kisan/A31_Reco/iScanKeeper |
| PM2 앱 | dashboard-web |

## 컨벤션

커밋 및 브랜치 컨벤션은 [CONTRIBUTING.md](./CONTRIBUTING.md) 참고
