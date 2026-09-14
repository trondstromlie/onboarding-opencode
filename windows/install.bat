@echo off
chcp 65001 >nul
echo.
echo  Installerer Node.js og OpenCode...
echo  Dette tar ca. 1-2 minutter. Ikke lukk dette vinduet.
echo.

if not exist "%~dp0script.ps1" (
    echo  Du har startet install.bat direkte fra ZIP-filen uten a pakke den ut.
    echo.
    echo  Slik gjor du:
    echo   1. Lukk dette vinduet
    echo   2. Hoyreklikk pa opencode-setup-windows.zip og velg "Pakk ut alle..."
    echo   3. Apne mappen som ble laget, og dobbeltklikk pa install.bat der
    echo.
    pause
    exit /b 1
)

powershell -ExecutionPolicy Bypass -Command "$p = Get-ExecutionPolicy -Scope CurrentUser; if ($p -eq 'Restricted' -or $p -eq 'Undefined') { try { Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force -ErrorAction Stop } catch {} }"
powershell -ExecutionPolicy Bypass -File "%~dp0script.ps1"

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo  Noe gikk galt. Se feilmeldingen over.
    pause
)
