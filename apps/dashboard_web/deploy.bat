@echo off
setlocal enabledelayedexpansion

echo ========================================
echo Next.js Deploy Script
echo ========================================
echo.

:: 환경변수 로드 (최상단 .env 파일에서)
set "ENV_FILE=..\..\.env"
if exist "%ENV_FILE%" (
    for /f "usebackq tokens=1,* delims==" %%a in ("%ENV_FILE%") do (
        set "line=%%a"
        if not "!line:~0,1!"=="#" (
            if not "%%a"=="" set "%%a=%%b"
        )
    )
    echo Loaded environment from %ENV_FILE%
) else (
    echo Warning: %ENV_FILE% not found, using defaults
    set "DASHBOARD_HOST=58.238.37.52"
    set "DASHBOARD_PORT=60500"
    set "DASHBOARD_URL=http://58.238.37.52:60500"
    set "DASHBOARD_SSH_USERNAME=iscan"
    set "DASHBOARD_SSH_PASSWORD="
    set "DASHBOARD_REMOTE_PATH=/home/iscan/Kisan/A31_Reco/iScanKeeper"
)
echo.

:: 1. 빌드
echo [1/4] Building...
call npm run build
if errorlevel 1 (
    echo Build failed!
    pause
    exit /b 1
)
echo Build successful!
echo.

:: 2. 압축
echo [2/4] Creating archive...
tar -czf dashboard_standalone.tar.gz .next/standalone .next/static public
echo Archive created!
echo.

:: 3. ssh2 패키지 확인 및 설치
echo [3/4] Checking ssh2 package...
if not exist "node_modules\ssh2" (
    echo Installing ssh2...
    call npm install ssh2 --save-dev
)
echo.

:: 4. 배포 스크립트 실행
echo [4/4] Running deploy script...
node deploy.js
if errorlevel 1 (
    echo Deployment failed!
    pause
    exit /b 1
)

echo.
echo ========================================
echo Done! !DASHBOARD_URL!
echo ========================================
pause
