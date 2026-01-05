@echo off
setlocal enabledelayedexpansion

echo ========================================
echo Next.js Deploy Script
echo ========================================
echo.

:: 1. 빌드
echo [1/9] Building...
call npm run build
if errorlevel 1 (
    echo Build failed!
    pause
    exit /b 1
)
echo Build successful!
echo.

:: 2. 압축
echo [2/9] Creating archive...
tar -czf dashboard_standalone.tar.gz .next/standalone .next/static public
echo Archive created!
echo.

:: 3. Python 스크립트 생성
echo [3/9] Creating deploy script...
(
echo import subprocess
echo import sys
echo.
echo try:
echo     import paramiko
echo except ImportError:
echo     print^("Installing paramiko..."^)
echo     subprocess.check_call^([sys.executable, "-m", "pip", "install", "paramiko", "--quiet"]^)
echo     import paramiko
echo.
echo server = "58.238.37.52"
echo username = "iscan"
echo password = "KiSaN)@@@)$&*()"
echo remote_path = "/home/iscan/Kisan/A31_Reco/iScanKeeper"
echo.
echo print^("Uploading..."^)
echo ssh = paramiko.SSHClient^(^)
echo ssh.set_missing_host_key_policy^(paramiko.AutoAddPolicy^(^)^)
echo ssh.connect^(server, username=username, password=password^)
echo.
echo sftp = ssh.open_sftp^(^)
echo sftp.put^("dashboard_standalone.tar.gz", f"{remote_path}/dashboard_standalone.tar.gz"^)
echo sftp.close^(^)
echo print^("Upload successful!"^)
echo.
echo print^("Deploying..."^)
echo deploy_cmd = f"cd {remote_path} && tar -xzf dashboard_standalone.tar.gz && cp -r .next/static .next/standalone/.next/ && cp -r public .next/standalone/ && cd .next/standalone && pm2 delete dashboard-web 2^>/dev/null ^|^| true && PORT=60500 HOSTNAME=0.0.0.0 pm2 start server.js --name 'dashboard-web' && pm2 save"
echo stdin, stdout, stderr = ssh.exec_command^(deploy_cmd^)
echo print^(stdout.read^(^).decode^(^)^)
echo ssh.close^(^)
echo print^("Done! http://58.238.37.52:60500"^)
) > deploy_script.py

:: 4. Python 스크립트 실행
echo [4/9] Running deploy script...
python deploy_script.py
if errorlevel 1 (
    del deploy_script.py
    echo Deployment failed!
    pause
    exit /b 1
)

:: 5. 정리
del deploy_script.py

echo.
echo ========================================
echo Done! http://58.238.37.52:60500
echo ========================================
pause