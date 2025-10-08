@echo off
REM ================================
REM Install-Customballer-Gunsmith.cmd
REM ================================

REM Pfad zum PowerShell-Skript
set "PS_SCRIPT=%~dp0script\install.ps1"

echo Prüfe, ob "%PS_SCRIPT%" blockiert ist...

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "try { $path = '%PS_SCRIPT%'; $zone = Get-Item -LiteralPath $path -ErrorAction Stop | Get-Item -Stream 'Zone.Identifier' -ErrorAction SilentlyContinue; if ($zone) { Write-Host 'Datei ist blockiert – entblocke...'; Unblock-File -Path $path; Write-Host 'Datei erfolgreich entblockt.' } else { Write-Host 'Datei ist nicht blockiert.' } } catch { Write-Host 'Fehler beim Prüfen oder Entblocken:'; Write-Host $_.Exception.Message }"

if errorlevel 1 (
  echo.
  echo [FEHLER] beim Entblocken.
  pause
)

echo.
echo Starte PowerShell-Installer...
powershell -NoProfile -ExecutionPolicy Bypass -File "%PS_SCRIPT%"

REM Datei selbst löschen (2 Sekunden warten, dann löschen)
cmd /c timeout /t 2 /nobreak >nul & del "%~f0"

echo.
pause
