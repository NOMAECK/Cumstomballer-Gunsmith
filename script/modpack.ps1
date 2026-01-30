# === Basis-Hauptverzeichnis ermitteln ===
if ($MyInvocation.MyCommand.CommandType -eq "ExternalScript") {
    # wenn als PS1 gestartet
    $scriptDir = Split-Path -Parent (Split-Path -Parent $PSCommandPath)
} else {
    # wenn als EXE gestartet
    $scriptDir = Split-Path -Parent (Split-Path -Parent ([System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName))
}

# === Windows Forms UI für Eingabe + Button ===
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

# Hauptfenster
$form = New-Object System.Windows.Forms.Form
$form.Text = "Customballer Gunsmith Mod Pack Creator"
$form.Size = New-Object System.Drawing.Size(400,220)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false

# Label
$label = New-Object System.Windows.Forms.Label
$label.Text = "Enter a name for your Customballer Gunsmith Mod Pack:"
$label.AutoSize = $true
$label.Location = New-Object System.Drawing.Point(20,20)
$form.Controls.Add($label)

# TextBox
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(20,50)
$textBox.Width = 340
$textBox.MaxLength = 20
$form.Controls.Add($textBox)
# Eingabe prüfen
$textBox.Add_KeyPress({
    param($sender, $e)

    # Zeichen abfragen
    $char = $e.KeyChar

    # Prüfen ob erlaubt:
    if ($char -match '[a-zA-Z0-9\-_äÄöÖüÜß ]' -or [char]::IsControl($char)) {
        # Erlaubt (Buchstabe, Zahl, - _ Leerzeichen oder Steuerzeichen wie Backspace)
        $e.Handled = $false
    } else {
        # Verboten
        $e.Handled = $true
        [System.Windows.Forms.MessageBox]::Show("✖ Only letters, numbers, space, - and _ are allowed.")
    }
})

# Statuslabel
$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.ForeColor = [System.Drawing.Color]::Red
$statusLabel.AutoSize = $true
$statusLabel.Location = New-Object System.Drawing.Point(20,80)
$form.Controls.Add($statusLabel)

# Button
$button = New-Object System.Windows.Forms.Button
$button.Text = "Select Costumballer Gunsmith Mods"
$button.Location = New-Object System.Drawing.Point(20,110)
$button.AutoSize = $true
$form.Controls.Add($button)

# Ergebnisvariable
$customname = $null

# Klick-Event
$button.Add_Click({
    $input = $textBox.Text.Trim()

    # === Prüfungen wie bisher ===
    if ([string]::IsNullOrWhiteSpace($input)) {
        $statusLabel.Text = "❌ Please enter a name."
        return
    }

    if ($input.Length -gt 20) {
        $statusLabel.Text = "❌ Max 20 characters allowed."
        return
    }

    if ($input -notmatch '^[A-Za-zäöüÄÖÜ0-9\-_ ]+$') {
        $statusLabel.Text = "❌ Only (A-Z, a-z, ä, ö, ü), 0–9, '-', ' ' and '_' allowed."
        return
    }

    # Wenn alles ok
    $statusLabel.ForeColor = [System.Drawing.Color]::Green
    $statusLabel.Text = "✅ Name accepted!"

    # Wert setzen
    $script:customname = $input

    # Fenster schließen
    $form.Close()
})

# UI anzeigen (blockierend)
$form.ShowDialog() | Out-Null

# Abbrechen abfangen
if (-not $customname) {
    Write-Host "❌ User canceled input." -ForegroundColor Yellow
    return
}

Write-Host "✅ Name accepted: $customname" -ForegroundColor Green
Write-Host "`nSelect your Customballer-Mods to merge."



# === Ordner-Struktur bauen ===
$customnameUnderline = $customname -replace '\s','_'
$customnameNoSpaces = $customname -replace '\s',''

$modsDir   = Join-Path $scriptDir "Mod-Packs"
if (-not (Test-Path $modsDir)) { New-Item -ItemType Directory -Path $modsDir | Out-Null }

$baseFolder = Join-Path $modsDir ("{0}_CBG_NOMAECK" -f $customnameUnderline)
if (-not (Test-Path $baseFolder)) { New-Item -ItemType Directory -Path $baseFolder | Out-Null }

# === Manifest erstellen (Grundgerüst) ===
$manifestPath = Join-Path $baseFolder "manifest.json"
Set-Content -Path $manifestPath -Value @"
{
 	"`$schema": "https://raw.githubusercontent.com/atampy25/simple-mod-framework/main/Mod%20Manager/src/lib/manifest-schema.json",	
	"id": "${customnameNoSpaces}.CBG_NOMAECK",
	"name": "${customnameUnderline}_CBG_NOMAECK",
	"description": "User self created Weapon Mod-Pack created with NOMAECK's Customballer Gunsmith",
	"authors": ["NOMAECK"],
	"frameworkVersion": "2.33.27",
	"version": "1.0.0",
	"blobsFolders": ["blobs"],
	"thumbs": ["ConsoleCmd OnlineResources_Disable 1"],
	"options": [
"@


 #Project.json erstellen
    Set-Content -Path (Join-Path $baseFolder "project.json") -Value @"
{
    "customPaths": []
}
"@

# === Dateien kopieren ===
$customModsPath = Join-Path $scriptDir "Customballer-Mods"
$tempRoot = Join-Path $scriptDir "mod-packs\temp"
$excludedNames = @('manifest.json','project.json') | ForEach-Object { $_.ToLower() }
$imports = @()

# Temp-Verzeichnis neu anlegen
if (Test-Path $tempRoot) { Remove-Item $tempRoot -Recurse -Force }
New-Item -Path $tempRoot -ItemType Directory | Out-Null

if (Test-Path $customModsPath) {

    # === Datei-Dialog öffnen, um ZIPs auszuwählen ===
    Add-Type -AssemblyName System.Windows.Forms

    $dialog = New-Object System.Windows.Forms.OpenFileDialog
    $dialog.InitialDirectory = $customModsPath
    $dialog.Filter = "ZIP Files (*.zip)|*.zip"
    $dialog.Title = "Select one or more Mod ZIP files to merge"
    $dialog.Multiselect = $true

    $zipFiles = @()
    if ($dialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $zipFiles = $dialog.FileNames
    } else {
        Write-Host "❌ Merge canceled by user." -ForegroundColor Yellow
        return
    }

    # === Temp-Verzeichnis vorbereiten ===
    if (Test-Path $tempRoot) { Remove-Item $tempRoot -Recurse -Force }
    New-Item -Path $tempRoot -ItemType Directory | Out-Null

    foreach ($zipPath in $zipFiles) {
        $zip = Get-Item $zipPath
        Write-Host "📦 unzip $($zip.Name)..." -ForegroundColor Cyan

        $extractDest = Join-Path $tempRoot ([IO.Path]::GetFileNameWithoutExtension($zip.Name))
        Expand-Archive -Path $zip.FullName -DestinationPath $extractDest -Force

        # === Struktur prüfen
        $hauptordner = Get-ChildItem -Path $extractDest -Directory | Select-Object -First 1
        $unterordnerList = Get-ChildItem -Path $hauptordner.FullName -Directory

        foreach ($unter in $unterordnerList) {
            $targetBase = Join-Path $baseFolder $unter.Name
            Write-Host "→ copy '$($unter.FullName)' → '$targetBase'" -ForegroundColor Gray

            if (-not (Test-Path $targetBase)) {
                New-Item -Path $targetBase -ItemType Directory -Force | Out-Null
            }

            Get-ChildItem -Path $unter.FullName -Recurse -Force | ForEach-Object {
                if ($_.PSIsContainer) {
                    $rel = $_.FullName.Substring($unter.FullName.Length).TrimStart('\','/')
                    $dest = Join-Path $targetBase $rel
                    if (-not (Test-Path $dest)) { New-Item -ItemType Directory -Path $dest -Force | Out-Null }
                } else {
                    if ($excludedNames -notcontains $_.Name.ToLower()) {
                        $rel = $_.FullName.Substring($unter.FullName.Length).TrimStart('\','/')
                        $dest = Join-Path $targetBase $rel
                        Copy-Item $_.FullName $dest -Force
                    }
                }
            }
        }

        # === Manifest-Import-Dateien in allen Unterordnern prüfen
        $manifestImportFiles = Get-ChildItem -Path $hauptordner.FullName -Filter "manifestimport.txt" -Recurse -ErrorAction SilentlyContinue

            foreach ($file in $manifestImportFiles) {
            $importContent = Get-Content $file.FullName -Raw
            $imports += ,$importContent
            }

    }

    # Temp nach Abschluss löschen
    if (Test-Path $tempRoot) { Remove-Item $tempRoot -Recurse -Force }

} else {
    Write-Host "⚠️ No 'Customballer-Mods'-folder found: $customModsPath" -ForegroundColor Yellow
}




# === Alle Manifeste importieren ===
if ($imports.Count -gt 0) {
    # Alle Inhalte mit Komma getrennt in das Manifest einfügen
    $joinedImports = ($imports -join ",`n")
    Add-Content -Path $manifestPath -Value $joinedImports
}

# === Groups automatisch erkennen und Selects erzeugen ===
$manifestContent = Get-Content -Path $manifestPath -Raw

$groups = [regex]::Matches(
    $manifestContent,
    '"group"\s*:\s*"([^"]+)"'
) | ForEach-Object { $_.Groups[1].Value } |
    Sort-Object -Unique

if ($groups.Count -eq 0) {
    Write-Host "⚠️ Keine Groups gefunden – fahre ohne Selects fort"
} else {

    Write-Host "🔎 Gefundene Groups:" -ForegroundColor Cyan
    $groups | ForEach-Object { Write-Host " - $_" }

    $selects = foreach ($group in $groups) {
@"
        ,
        {
            "group": "$group",
            "name": "don't replace",
            "tooltip": "$group",
            "type": "select",
            "enabledByDefault": true
        }
"@
    }

    Add-Content -Path $manifestPath -Value ($selects -join "`n")
}


# Manifest schließen
Add-Content -Path $manifestPath -Value @"
        ]
}
"@

# === ZIP erstellen ===
$zipPath = Join-Path $modsDir ("{0}_CBG_NOMAECK.zip" -f $customnameUnderline)
if (Test-Path $zipPath) { Remove-Item $zipPath -Force }
Compress-Archive -Path $baseFolder -DestinationPath $zipPath

# === Ordner nach dem Packen löschen ===
if (Test-Path $baseFolder) {
   Remove-Item $baseFolder -Recurse -Force
}

# === Ordner im Explorer öffnen ===
$zipFolder = Split-Path $zipPath -Parent

$shell = New-Object -ComObject Shell.Application
$alreadyOpen = $false
foreach ($window in $shell.Windows()) {
    try {
        if ($window.FullName -like "*explorer.exe" -and 
            $window.Document.Folder.Self.Path -eq $zipFolder) {
            $alreadyOpen = $true
            break
        }
    } catch {}
}
if (-not $alreadyOpen) {
    Start-Process explorer.exe -ArgumentList $zipFolder
}
