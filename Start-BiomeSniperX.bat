@echo off
setlocal EnableExtensions
title Madness BiomeSniperX
cd /d "%~dp0"
set "EV=33.2.1"
set "RT=%~dp0runtime"
set "EXE=%RT%\Madness BiomeSniperX.exe"

if exist "%EXE%" goto sync

echo.
echo  Madness BiomeSniperX - first-time setup (one time only)
echo  Downloading the app runtime, about 100 MB. Please wait...
echo.
if exist "%RT%" rmdir /s /q "%RT%"
mkdir "%RT%"
curl.exe -L --fail --progress-bar -o "%TEMP%\mbx-runtime.zip" "https://github.com/electron/electron/releases/download/v%EV%/electron-v%EV%-win32-x64.zip"
if errorlevel 1 goto fail
echo  Unpacking...
tar.exe -xf "%TEMP%\mbx-runtime.zip" -C "%RT%"
if errorlevel 1 goto fail
del "%TEMP%\mbx-runtime.zip" >nul 2>&1
ren "%RT%\electron.exe" "Madness BiomeSniperX.exe"
if errorlevel 1 goto fail
powershell -NoProfile -ExecutionPolicy Bypass -Command "$s=(New-Object -ComObject WScript.Shell).CreateShortcut([Environment]::GetFolderPath('Desktop')+'\Madness BiomeSniperX.lnk');$s.TargetPath='%EXE%';$s.WorkingDirectory='%RT%';$s.Save()" >nul 2>&1

:sync
if exist "%RT%\resources\app" rmdir /s /q "%RT%\resources\app"
xcopy "%~dp0app" "%RT%\resources\app" /e /i /y /q >nul
if errorlevel 1 goto fail
start "" "%EXE%"
exit /b 0

:fail
echo.
echo  Setup failed. Check your internet connection and run this file again.
echo  (If it keeps failing, download electron-v%EV%-win32-x64.zip from github.com/electron/electron/releases
echo   and unzip it into a folder named runtime next to this file.)
pause
exit /b 1
