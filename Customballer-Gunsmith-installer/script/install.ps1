# === Pfade ===
$scriptDir = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Definition)
$tempDir = Join-Path $scriptDir "temp_update"

# Temp-Ordner erstellen
if (-not (Test-Path $tempDir)) { New-Item -Path $tempDir -ItemType Directory | Out-Null }

$zipUrl = "https://github.com/NOMAECK/Cumstomballer-Gunsmith/releases/latest/download/Customballer-Gunsmith.zip
"
$tempZip = Join-Path $tempDir "Customballer-Gunsmith.zip"

# === ZIP herunterladen ===
Invoke-WebRequest -Uri $zipUrl -OutFile $tempZip -UseBasicParsing

# === ZIP entpacken (inkl. leere Ordner, PowerShell 5.1 kompatibel) ===
Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [System.IO.Compression.ZipFile]::OpenRead($tempZip)

foreach ($entry in $zip.Entries) {
    $targetPath = Join-Path $scriptDir $entry.FullName

    if ($entry.FullName.EndsWith("/")) {
        # Leeres Verzeichnis erstellen
        if (-not (Test-Path $targetPath)) {
            New-Item -Path $targetPath -ItemType Directory | Out-Null
        }
    } else {
        # Übergeordnete Verzeichnisse anlegen
        $targetDir = Split-Path $targetPath -Parent
        if (-not (Test-Path $targetDir)) { New-Item -Path $targetDir -ItemType Directory | Out-Null }

        # Datei extrahieren, vorhandene Dateien überschreiben
        $entryStream = $entry.Open()
        $fileStream = [System.IO.File]::Open($targetPath, [System.IO.FileMode]::Create)
        $entryStream.CopyTo($fileStream)
        $fileStream.Close()
        $entryStream.Close()
    }
}

$zip.Dispose()


# === Temp-Ordner löschen ===
Remove-Item -Path $tempDir -Recurse -Force

# === installREADME löschen ===
$installReadme = Join-Path $scriptDir "installREADME.txt"
Remove-Item -Path $installReadme -Force -ErrorAction SilentlyContinue


# === Hauptscript über Batch neu starten ===
$cmdPath = Join-Path $scriptDir "Run-Customballer-Gunsmith.cmd"
Start-Process -FilePath $cmdPath

# === sich selbst löschen ===
$installScript = $MyInvocation.MyCommand.Definition
Start-Sleep -Milliseconds 500  # kurz warten, bis alles fertig ist
Remove-Item -Path $installScript -Force
