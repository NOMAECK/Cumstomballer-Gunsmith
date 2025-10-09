# === Pfade ===
$scriptDir = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Definition)
$tempDir = Join-Path $scriptDir "temp_update"

# Temp-Ordner erstellen
if (-not (Test-Path $tempDir)) { New-Item -Path $tempDir -ItemType Directory | Out-Null }

$zipUrl = "https://github.com/NOMAECK/Cumstomballer-Gunsmith/releases/latest/download/Customballer-Gunsmith.zip"
$tempZip = Join-Path $tempDir "Customballer-Gunsmith.zip"
$updateScriptPath = Join-Path $scriptDir "script\update.ps1"
$updateBackup = Join-Path $tempDir "update_backup.ps1"

# === ZIP herunterladen ===
Invoke-WebRequest -Uri $zipUrl -OutFile $tempZip -UseBasicParsing

# === ZIP entpacken (einzeln, PowerShell 5.1 kompatibel) ===
Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [System.IO.Compression.ZipFile]::OpenRead($tempZip)

foreach ($entry in $zip.Entries) {
    $targetPath = Join-Path $scriptDir $entry.FullName

    # Verzeichnisse anlegen
    $targetDir = Split-Path $targetPath -Parent
    if (-not (Test-Path $targetDir)) { New-Item -Path $targetDir -ItemType Directory | Out-Null }

    # Datei extrahieren, vorhandene Dateien überschreiben
    if (-not ($entry.FullName.EndsWith("/"))) {
        $entryStream = $entry.Open()
        $fileStream = [System.IO.File]::Open($targetPath, [System.IO.FileMode]::Create)
        $entryStream.CopyTo($fileStream)
        $fileStream.Close()
        $entryStream.Close()
    }
}
$zip.Dispose()

# === fastmode.flag löschen, falls vorhanden ===
$fastmodeFlag = Join-Path $scriptDir "fastmode.flag"
if (Test-Path $fastmodeFlag) {
    Remove-Item -Path $fastmodeFlag -Force
    Write-Output "fastmode.flag wurde gelöscht."
}

# === update.ps1 löschen, falls vorhanden ===
$updateold = Join-Path $scriptDir "script\update.ps1"
if (Test-Path $updateold) {
    Remove-Item -Path $updateold -Force
    Write-Output "update.ps1 wurde gelöscht."
}

# === Batch löschen, falls vorhanden ===
$batchold = Join-Path $scriptDir "Run-Customballer-Gunsmith.bat"
if (Test-Path $batchold) {
    Remove-Item -Path $batchold -Force
    Write-Output "Run-Customballer-Gunsmith.bat wurde gelöscht."
}


# === installREADME löschen ===
$installReadme = Join-Path $scriptDir "installREADME.txt"
if (Test-Path $installReadme) {
    Remove-Item -Path $installReadme -Force -ErrorAction SilentlyContinue
}

# === Temp-Ordner löschen ===
Remove-Item -Path $tempDir -Recurse -Force

# === Hauptscript über Batch neu starten ===
$cmdPath = Join-Path $scriptDir "Run-Customballer-Gunsmith.cmd"
Start-Process -FilePath $cmdPath
