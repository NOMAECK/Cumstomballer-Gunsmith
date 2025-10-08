@echo off
REM ================================
REM Install-Customballer-Gunsmith.cmd
REM ================================

REM Pfad zum PowerShell-Skript
set "PS_SCRIPT=%~dp0script\install.ps1"

echo check if "%PS_SCRIPT%" is blocked...

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "try { $path = '%PS_SCRIPT%'; $zone = Get-Item -LiteralPath $path -ErrorAction Stop | Get-Item -Stream 'Zone.Identifier' -ErrorAction SilentlyContinue; if ($zone) { Write-Host 'File is blocked, unblock...'; Unblock-File -Path $path; Write-Host 'File successfull unblocked.' } else { Write-Host 'File is not blocked' } } catch { Write-Host 'Error:'; Write-Host $_.Exception.Message }"

if errorlevel 1 (
  echo.
  echo Error while unblocking.
  pause
)

echo.
echo Start PowerShell-Installer...
powershell -NoProfile -ExecutionPolicy Bypass -File "%PS_SCRIPT%"

REM Datei selbst löschen (2 Sekunden warten, dann löschen)
cmd /c timeout /t 2 /nobreak >nul & del "%~f0"

echo.
pause
