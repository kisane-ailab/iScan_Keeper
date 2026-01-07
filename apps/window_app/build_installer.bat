@echo off
cd /d "%~dp0"

echo ========================================
echo   iScan Keeper Installer Build
echo ========================================
echo.
echo Current directory: %cd%
echo.

:: Inno Setup path
set "ISCC=C:\Program Files (x86)\Inno Setup 6\ISCC.exe"

:: Check Inno Setup
if not exist "%ISCC%" (
    echo [ERROR] Inno Setup not found!
    echo.
    echo Expected path: %ISCC%
    echo.
    echo Please install Inno Setup from:
    echo https://jrsoftware.org/isdl.php
    echo.
    cmd /k
    exit
)

echo [1/2] Building Flutter Windows Release...
echo.
call flutter build windows --release
if %errorLevel% neq 0 (
    echo.
    echo [ERROR] Flutter build failed!
    echo.
    cmd /k
    exit
)

echo.
echo [2/2] Creating Installer with Inno Setup...
echo.
call "%ISCC%" installer\iScanKeeper.iss
if %errorLevel% neq 0 (
    echo.
    echo [ERROR] Inno Setup build failed!
    echo.
    cmd /k
    exit
)

echo.
echo ========================================
echo   [OK] Installer created successfully!
echo ========================================
echo.
echo   Location:
echo   %~dp0build\installer\iScanKeeper_Setup_1.0.0.exe
echo.
echo ========================================
echo.
cmd /k
