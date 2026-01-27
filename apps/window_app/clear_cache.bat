@echo off
cd /d "%~dp0"

echo ========================================
echo   iScan Keeper - Clear Local Cache
echo ========================================
echo.

:: 앱 종료 (캐시 파일 잠금 해제)
echo Closing iScan Keeper app...
taskkill /f /im window_app.exe >nul 2>&1
timeout /t 1 /nobreak >nul

set "CACHE_DIR=%USERPROFILE%\Documents"

echo Cache directory: %CACHE_DIR%
echo.

echo Deleting cache files...
echo.

:: System logs realtime cache
if exist "%CACHE_DIR%\system_logs_realtime_cache.hive" (
    del /f "%CACHE_DIR%\system_logs_realtime_cache.hive" 2>nul
    echo   [OK] system_logs_realtime_cache.hive
)
if exist "%CACHE_DIR%\system_logs_realtime_cache.lock" (
    del /f "%CACHE_DIR%\system_logs_realtime_cache.lock" 2>nul
    echo   [OK] system_logs_realtime_cache.lock
)

:: Datasets realtime cache
if exist "%CACHE_DIR%\datasets_realtime_cache.hive" (
    del /f "%CACHE_DIR%\datasets_realtime_cache.hive" 2>nul
    echo   [OK] datasets_realtime_cache.hive
)
if exist "%CACHE_DIR%\datasets_realtime_cache.lock" (
    del /f "%CACHE_DIR%\datasets_realtime_cache.lock" 2>nul
    echo   [OK] datasets_realtime_cache.lock
)

:: Read status cache
if exist "%CACHE_DIR%\read_status_cache.hive" (
    del /f "%CACHE_DIR%\read_status_cache.hive" 2>nul
    echo   [OK] read_status_cache.hive
)
if exist "%CACHE_DIR%\read_status_cache.lock" (
    del /f "%CACHE_DIR%\read_status_cache.lock" 2>nul
    echo   [OK] read_status_cache.lock
)

echo.
echo ========================================
echo   [DONE] Cache cleared successfully!
echo ========================================
echo.
pause
