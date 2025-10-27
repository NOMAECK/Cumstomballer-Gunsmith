@echo off
:: --------------------------------
:: CMD Style konfigurieren
:: --------------------------------
title Customballer-Gunsmith
color 4F

:: Optional: kleines Banner
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo                                              ================================
echo                                                   CUSTOMBALLER GUNSMITH
echo                                              ================================
echo.

set "SCRIPT_DIR=%~dp0"
set "FLAG=%SCRIPT_DIR%fastmode.flag"
set "PS_SCRIPT=%SCRIPT_DIR%script\Script.ps1"

if exist "%FLAG%" goto FASTMODE

timeout /t 2 /nobreak >nul
echo.
echo.
echo.
echo.
echo Check all .ps1 in "%SCRIPT_DIR%script%" if blocked...
timeout /t 2 /nobreak >nul
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "try { $base = '%SCRIPT_DIR%script'; Get-ChildItem -LiteralPath $base -Recurse -Filter '*.ps1' -File -ErrorAction SilentlyContinue | ForEach-Object { $p=$_.FullName; $zone = Get-Item -LiteralPath $p -ErrorAction Stop | Get-Item -Stream 'Zone.Identifier' -ErrorAction SilentlyContinue; if ($zone) { Write-Host 'unblock:' $p; Start-Sleep -Seconds 1; Unblock-File -LiteralPath $p; Write-Host 'successful:' $p; Start-Sleep -Seconds 1 } else { Write-Host 'not blocked:' $p; Start-Sleep -Seconds 1 } } } catch { Write-Host 'error while unblocking:' $_.Exception.Message; Start-Sleep -Seconds 1; exit 1 }"

echo 1 > "%FLAG%"

echo.
echo starting...
timeout /t 2 /nobreak >nul

:FASTMODE
timeout /t 1 /nobreak >nul
start "" powershell -WindowStyle Hidden -ExecutionPolicy Bypass -NoProfile -File "%PS_SCRIPT%"
timeout /t 1 /nobreak >nul
exit

