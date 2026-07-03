@echo off
chcp 65001 >nul
echo.
echo  Installerer Node.js og OpenCode...
echo  Dette tar ca. 1-2 minutter. Ikke lukk dette vinduet.
echo.

powershell -ExecutionPolicy Bypass -File "%~dp0script.ps1"

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo  Noe gikk galt. Se feilmeldingen over.
    pause
)
