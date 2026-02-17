Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$global:ActiveScript = "ICA19"


# === Basis-Hauptverzeichnis ermitteln ===
if ($MyInvocation.MyCommand.CommandType -eq "ExternalScript") {
    # wenn als PS1 gestartet
    $scriptDir = Split-Path -Parent (Split-Path -Parent $PSCommandPath)
} else {
    # wenn als EXE gestartet
    $scriptDir = Split-Path -Parent (Split-Path -Parent ([System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName))
}

# === Versionsprüfung ===
$localVersionPath = Join-Path $PSScriptRoot "version.txt"
$updateAvailable = $false

try {
    # Lokale Version lesen
    if (Test-Path $localVersionPath) {
        $localVersionRaw = Get-Content $localVersionPath -Raw
        $localVersion = [version](([string]$localVersionRaw).Trim())
    }
    else {
        Write-Host "Local version.txt not found."
        return
    }

    # Remote-Version abrufen (RAW!)
    $remoteVersionUrl = "https://raw.githubusercontent.com/NOMAECK/Cumstomballer-Gunsmith/main/version.txt"

    try {
        $remoteVersionRaw = Invoke-RestMethod -Uri $remoteVersionUrl -UseBasicParsing -TimeoutSec 5
        if ($remoteVersionRaw) {
            $remoteVersion = [version](([string]$remoteVersionRaw).Trim())            
            if ($remoteVersion -gt $localVersion) {
                $updateAvailable = $true
                Write-Host "Update available! Remote: $remoteVersion | Local: $localVersion"
            }
            else {
                Write-Host "Latest version installed. Remote: $remoteVersion | Local: $localVersion"
            }
        }
    }
    catch {
        Write-Host "No internet connection or GitHub not available."
        $updateAvailable = $false
    }
}
catch {
    Write-Host "Error during version check: $($_.Exception.Message)"
    $updateAvailable = $false
}


# === Form ===
$form = New-Object System.Windows.Forms.Form
$form.Text = "Customballer Gunsmith"
$form.Size = New-Object System.Drawing.Size(801,935)
$form.StartPosition = "CenterScreen"
# === Menüleiste erstellen ===
$menu = New-Object System.Windows.Forms.MenuStrip
$menu.RenderMode = [System.Windows.Forms.ToolStripRenderMode]::System

# Menü "Tool"
$ToolMenu = New-Object System.Windows.Forms.ToolStripMenuItem
$ToolMenu.Text = "Tool"

# Menüpunkt "Close"
$exitItem = New-Object System.Windows.Forms.ToolStripMenuItem
$exitItem.Text = "Close"
$exitItem.Add_Click({ $form.Close() })
[void]$ToolMenu.DropDownItems.Add($exitItem)

# Menü "Merge"
$MergeMenu = New-Object System.Windows.Forms.ToolStripMenuItem
$MergeMenu.Text = "Merge"
$mergePath = Join-Path $scriptDir "script\modpack.ps1"
$MergeMenu.Add_Click({
    Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -NoProfile -File `"$mergePath`""
})


# Menü "Import"
$ImportMenu = New-Object System.Windows.Forms.ToolStripMenuItem
$ImportMenu.Text = "Import"
$ImportMenu.Visible = $true

# Menü "Import1"
$ImportMenu1 = New-Object System.Windows.Forms.ToolStripMenuItem
$ImportMenu1.Text = "Import"
$ImportMenu1.Visible = $false

#Seiten einbinden
$ica19Path = Join-Path $scriptDir "script\ICA19.ps1"
. $ica19Path

$BullpupPath = Join-Path $scriptDir "script\Bullpup.ps1"
. $BullpupPath

$page1MenuItem = New-Object System.Windows.Forms.ToolStripMenuItem "ICA19"
$page1MenuItem.Add_Click({
    $global:ActiveScript = "ICA19"
    $panel.Visible = $true
    $ImportMenu.Visible = $true
    $panel1.Visible = $false
    $ImportMenu1.Visible = $false
})

$page2MenuItem = New-Object System.Windows.Forms.ToolStripMenuItem "Bullpup Sniper"
$page2MenuItem.Add_Click({
    $global:ActiveScript = "Bullpup"
    $panel.Visible = $false
    $ImportMenu.Visible = $false
    $panel1.Visible = $true
    $ImportMenu1.Visible = $true
})

# Menüs zur Menüleiste hinzufügen
[void]$menu.Items.Add($ToolMenu)
[void]$menu.Items.Add($MergeMenu)
[void]$menu.Items.Add($ImportMenu)
[void]$menu.Items.Add($ImportMenu1)
[void]$menu.Items.Add($page1MenuItem)
[void]$menu.Items.Add($page2MenuItem)



$panel.Visible = $true
$form.Controls.Add($panel)

$panel1.Visible = $false
$form.Controls.Add($panel1)

# Menüleiste dem Formular hinzufügen
$form.MainMenuStrip = $menu
[void]$form.Controls.Add($menu)

# ToolTip erstellen
$toolTip = New-Object System.Windows.Forms.ToolTip
$toolTip.ShowAlways = $true


# === created + Version ===
$lblcreated = New-Object System.Windows.Forms.Label
$lblcreated.Text = "created by NOMAECK"
$lblcreated.Location = New-Object System.Drawing.Point(662,877)
$lblcreated.AutoSize = $true
$lblcreated.ForeColor = [System.Drawing.Color]::DimGray
$form.Controls.Add($lblcreated)
$lblcreated.BringToFront()


$lblversion = New-Object System.Windows.Forms.Label
$lblversion.Text = "v$localVersion"
$lblversion.Location = New-Object System.Drawing.Point(7,877)
$lblversion.AutoSize = $true
$lblversion.ForeColor = [System.Drawing.Color]::DimGray
$form.Controls.Add($lblversion)
$lblversion.BringToFront()




# === Show Form ===
[void]$form.ShowDialog()

