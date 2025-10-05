@echo off
if not "%1"=="min" (
    start /min "" cmd /c "%~f0" min
    exit /b
)
set "SCRIPT_DIR=%~dp0"
powershell.exe -File  "%SCRIPT_DIR%\script\Script.ps1"
exit /b
