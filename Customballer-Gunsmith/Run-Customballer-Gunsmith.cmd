@echo off
set "SCRIPT_DIR=%~dp0"
set "FLAG=%SCRIPT_DIR%fastmode.flag"
set "PS_SCRIPT=%SCRIPT_DIR%script\Script.ps1"

if exist "%FLAG%" goto FASTMODE

echo Check all .ps1 im "%SCRIPT_DIR%script%" if blocked...

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "try { $base = '%SCRIPT_DIR%script'; Get-ChildItem -LiteralPath $base -Recurse -Filter '*.ps1' -File -ErrorAction SilentlyContinue | ForEach-Object { $p=$_.FullName; $zone = Get-Item -LiteralPath $p -ErrorAction Stop | Get-Item -Stream 'Zone.Identifier' -ErrorAction SilentlyContinue; if ($zone) { Write-Host 'unblock:' $p; Unblock-File -LiteralPath $p; Write-Host 'successful:' $p } else { Write-Host 'not blocked:' $p } } } catch { Write-Host 'error while unblocking:' $_.Exception.Message; exit 1 }"

echo 1 > "%FLAG%"

:FASTMODE
start "" powershell -WindowStyle Hidden -ExecutionPolicy Bypass -NoProfile -File "%PS_SCRIPT%"
exit /b
