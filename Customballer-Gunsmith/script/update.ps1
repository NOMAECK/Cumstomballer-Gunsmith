# === Pfade ===
$scriptDir = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Definition)
$tempDir = Join-Path $scriptDir "temp_update"

# Temp-Ordner erstellen
if (-not (Test-Path $tempDir)) { New-Item -Path $tempDir -ItemType Directory | Out-Null }

$zipUrl = "https://github.com/NOMAECK/Cumstomballer-Gunsmith/releases/latest/download/Customballer-Gunsmith.zip"
$tempZip = Join-Path $tempDir "Customballer-Gunsmith.zip"
$updateScriptPath = Join-Path $scriptDir "script\update.ps1"
$updateBackup = Join-Path $tempDir "update_backup.ps1"

# === update.ps1 sichern ===
Copy-Item -Path $updateScriptPath -Destination $updateBackup -Force

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

# === update.ps1 wiederherstellen ===
Copy-Item -Path $updateBackup -Destination $updateScriptPath -Force

# === Temp-Ordner löschen ===
Remove-Item -Path $tempDir -Recurse -Force

# === Hauptscript über Batch neu starten ===
$batchPath = Join-Path $scriptDir "Run-Customballer-Gunsmith.bat"
Start-Process -FilePath $batchPath
