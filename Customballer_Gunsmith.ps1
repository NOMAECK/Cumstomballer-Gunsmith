Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# === Basis-Skriptverzeichnis ermitteln ===
if ($MyInvocation.MyCommand.CommandType -eq "ExternalScript") {
    # wenn als PS1 gestartet
    $scriptDir = Split-Path -Parent $PSCommandPath
} else {
    # wenn als EXE gestartet
    $scriptDir = Split-Path -Parent ([System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName)
}

# === Form ===
$form = New-Object System.Windows.Forms.Form
$form.Text = "Customballer Gunsmith"
$form.Size = New-Object System.Drawing.Size(801,925)
$form.StartPosition = "CenterScreen"

# === Positions Variabeln ===
$X1lbl = 30  #Bauteil-Label X Start Position
$X2lbl = 420 #Bauteil-Color-Label X Start Position
$X1cmb = 200 #Bauteil-Combobox X Start Position = Dropdown
$X2cmb = 565 #Bauteil-Color-Combobox X Start Position = Dropdown
$Xcmbsize = 190 #Combobox X Größe
$Ycmbsize = 30  #Combobox Y Größe
$lineheight = 2 #Trennlinien Höhe
$linewidth = 725 #Trennlinien Breite
$Yline = 62 #Erste Trennlinien Y Startposition
$Ylbl = 30 #Erste Label Y Startposition
$Ycmb = 27 #Erste Combobox Y Startposition
$Yplus = 50 #50 Pixel



# === Scrollbares Panel ===
$panel = New-Object System.Windows.Forms.Panel
$panel.Dock = "Fill"          # Füllt das Fenster aus
$panel.AutoScroll = $true     # Scrollbalken aktivieren
#$panel.BackColor = [System.Drawing.Color]::Red
$form.Controls.Add($panel)

# ToolTip erstellen
$toolTip = New-Object System.Windows.Forms.ToolTip
$toolTip.ShowAlways = $true

# Panel MouseMove Event
$panel.Add_MouseMove({
    param($sender, $e)
    
    $found = $false
    
    # Alle Controls im Panel durchsuchen
    foreach ($ctrl in $panel.Controls) {
        if ($ctrl -is [System.Windows.Forms.ComboBox] -and -not $ctrl.Enabled) {
            # Prüfen, ob Maus über ComboBox ist
            if ($ctrl.Bounds.Contains($e.Location)) {
                $toolTip.SetToolTip($panel, "Not available for your selected gun parts.")
                $found = $true
                break
            }
        }
    }

    # Wenn keine gesperrte ComboBox unter der Maus, Tooltip entfernen
    if (-not $found) {
        $toolTip.SetToolTip($panel, "")
    }
})

# === 1. created ===
$lblcreated = New-Object System.Windows.Forms.Label
$lblcreated.Text = "created by NOMAECK"
$lblcreated.Location = New-Object System.Drawing.Point(662,866)
$lblcreated.AutoSize = $true
$lblcreated.ForeColor = [System.Drawing.Color]::DimGray
$panel.Controls.Add($lblcreated)




# === 1. Weapon to replace ===
$lblWeapon = New-Object System.Windows.Forms.Label
$lblWeapon.Text = "Weapon to replace:"
$lblWeapon.Location = New-Object System.Drawing.Point($x1lbl,$Ylbl)
$lblWeapon.AutoSize = $true
$panel.Controls.Add($lblWeapon)

$cmbWeapon = New-Object System.Windows.Forms.ComboBox
$cmbWeapon.Location = New-Object System.Drawing.Point($x1cmb,$Ycmb)
$cmbWeapon.Size = New-Object System.Drawing.Size($xcmbsize, $ycmbsize)
$cmbWeapon.DropDownStyle = "DropDownList"
$cmbWeapon.DropDownHeight = "600"
$cmbWeapon.Items.AddRange(@(
    "ICA19",
    "Silverballer",
    "Silverballer S2",
    "ICA19 Chrome",
    "Black Lilly",
    "Goldballer",
    "Classic Baller",
    "Shortballer",
    "Striker",
    "ICA19 F/A",
    "ICA19 F/A Stealth"
))
$panel.Controls.Add($cmbWeapon)

# === 1.1 New Custom-Baller Name ===
$lblCustomName = New-Object System.Windows.Forms.Label
$lblCustomName.Text = "New Customballer name:"
$lblCustomName.Location = New-Object System.Drawing.Point($x2lbl,$Ylbl)
$lblCustomName.AutoSize = $true
$panel.Controls.Add($lblCustomName)

$txtCustomName = New-Object System.Windows.Forms.TextBox
$txtCustomName.Location = New-Object System.Drawing.Point($x2cmb,$Ycmb)
$txtCustomName.Size = New-Object System.Drawing.Size($xcmbsize, $ycmbsize)
$txtCustomName.MaxLength = 25 

# Eingabe prüfen
$txtCustomName.Add_KeyPress({
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

$panel.Controls.Add($txtCustomName)

#Trennlinie 1
$line1 = New-Object System.Windows.Forms.Label
$line1.BorderStyle = "Fixed3D"
$line1.AutoSize = $false
$line1.Height = $lineheight
$line1.Width = $linewidth
$line1.Location = New-Object System.Drawing.Point($x1lbl,$Yline)
$panel.Controls.Add($line1)
$Yline += $Yplus
$Ylbl += $Yplus
$Ycmb += $Yplus


# === 2. Barrel ===
$lblBarrel = New-Object System.Windows.Forms.Label
$lblBarrel.Text = "Choose a barrel:"
$lblBarrel.Location = New-Object System.Drawing.Point($x1lbl,$Ylbl)
$lblBarrel.AutoSize = $true
$panel.Controls.Add($lblBarrel)

$cmbBarrel = New-Object System.Windows.Forms.ComboBox
$cmbBarrel.Location = New-Object System.Drawing.Point($x1cmb,$Ycmb)
$cmbBarrel.Size = New-Object System.Drawing.Size($xcmbsize, $ycmbsize)
$cmbBarrel.DropDownStyle = "DropDownList"
$cmbBarrel.DropDownHeight = "600"
$cmbBarrel.Items.AddRange(@(
    "short barrel",
    "long barrel"
))
$panel.Controls.Add($cmbBarrel)


# === 2.1 Barrel Color ===
$lblBarrelColor = New-Object System.Windows.Forms.Label
$lblBarrelColor.Text = "Barrel color:"
$lblBarrelColor.Location = New-Object System.Drawing.Point($x2lbl,$Ylbl)
$lblBarrelColor.AutoSize = $true
$lblBarrelColor.Enabled = $false
$panel.Controls.Add($lblBarrelColor)

$cmbBarrelColor = New-Object System.Windows.Forms.ComboBox
$cmbBarrelColor.Location = New-Object System.Drawing.Point($x2cmb,$Ycmb)
$cmbBarrelColor.Size = New-Object System.Drawing.Size($xcmbsize, $ycmbsize)
$cmbBarrelColor.DropDownStyle = "DropDownList"
$cmbBarrelColor.DropDownHeight = "600"
$cmbBarrelColor.Enabled = $false
$panel.Controls.Add($cmbBarrelColor)

#Trennlinie 2
$line2 = New-Object System.Windows.Forms.Label
$line2.BorderStyle = "Fixed3D"
$line2.AutoSize = $false
$line2.Height = $lineheight
$line2.Width = $linewidth
$line2.Location = New-Object System.Drawing.Point($x1lbl,$Yline)
$panel.Controls.Add($line2)
$Yline += $Yplus
$Ylbl += $Yplus
$Ycmb += $Yplus

# === 3. Frame ===
$lblFrame = New-Object System.Windows.Forms.Label
$lblFrame.Text = "Choose a frame:"
$lblFrame.Location = New-Object System.Drawing.Point($x1lbl,$Ylbl)
$lblFrame.AutoSize = $true
$panel.Controls.Add($lblFrame)

$cmbFrame = New-Object System.Windows.Forms.ComboBox
$cmbFrame.Location = New-Object System.Drawing.Point($x1cmb,$Ycmb)
$cmbFrame.Size = New-Object System.Drawing.Size($xcmbsize, $ycmbsize)
$cmbFrame.DropDownStyle = "DropDownList"
$cmbFrame.DropDownHeight = "600"
$cmbFrame.Items.AddRange(@(
    "1911 Standard",
    "Black with Rail",
    "Black Tomb Raider"
    #"Spraypaint"
))
$panel.Controls.Add($cmbFrame)

# === 3.1 Frame Color ===
$lblFrameColor = New-Object System.Windows.Forms.Label
$lblFrameColor.Text = "Frame color:"
$lblFrameColor.Location = New-Object System.Drawing.Point($x2lbl,$Ylbl)
$lblFrameColor.AutoSize = $true
$lblFrameColor.Enabled = $false
$panel.Controls.Add($lblFrameColor)

$cmbFrameColor = New-Object System.Windows.Forms.ComboBox
$cmbFrameColor.Location = New-Object System.Drawing.Point($x2cmb,$Ycmb)
$cmbFrameColor.Size = New-Object System.Drawing.Size($xcmbsize, $ycmbsize)
$cmbFrameColor.DropDownStyle = "DropDownList"
$cmbFrameColor.DropDownHeight = "600"
$cmbFrameColor.Items.AddRange(@(
    "black",
    "silver matt",
    "silver chrome",
    "Matador",
    "gold",
    "chrome",
    "black shiny",
    "tan",
    "dark chrome",
    "silver shiny (black safeguard)",
    "yellow (ducky)",
    "steel floral",
    "cherry floral"
))
$cmbFrameColor.Enabled = $false
$panel.Controls.Add($cmbFrameColor)

#Trennlinie 3
$line3 = New-Object System.Windows.Forms.Label
$line3.BorderStyle = "Fixed3D"
$line3.AutoSize = $false
$line3.Height = $lineheight
$line3.Width = $linewidth
$line3.Location = New-Object System.Drawing.Point($x1lbl,$Yline)
$panel.Controls.Add($line3)
$Yline += $Yplus
$Ylbl += $Yplus
$Ycmb += $Yplus

# === 4. Hammer ===
$lblHammer = New-Object System.Windows.Forms.Label
$lblHammer.Text = "Choose a hammer:"
$lblHammer.Location = New-Object System.Drawing.Point($x1lbl,$Ylbl)
$lblHammer.AutoSize = $true
$panel.Controls.Add($lblHammer)

$cmbHammer = New-Object System.Windows.Forms.ComboBox
$cmbHammer.Location = New-Object System.Drawing.Point($x1cmb,$Ycmb)
$cmbHammer.Size = New-Object System.Drawing.Size($xcmbsize, $ycmbsize)
$cmbHammer.DropDownStyle = "DropDownList"
$cmbHammer.DropDownHeight = "600"
$cmbHammer.Items.AddRange(@(
    "Classic Chrome Hammer",
    "Ring Hammer"
))
$panel.Controls.Add($cmbHammer)

# === 4.1 Hammer Color (nur bei Ring Hammer) ===
$lblHammerColor = New-Object System.Windows.Forms.Label
$lblHammerColor.Text = "Hammer color:"
$lblHammerColor.Location = New-Object System.Drawing.Point($x2lbl,$Ylbl)
$lblHammerColor.AutoSize = $true
$lblHammerColor.Enabled = $false
$panel.Controls.Add($lblHammerColor)

$cmbHammerColor = New-Object System.Windows.Forms.ComboBox
$cmbHammerColor.Location = New-Object System.Drawing.Point($x2cmb,$Ycmb)
$cmbHammerColor.Size = New-Object System.Drawing.Size($xcmbsize, $ycmbsize)
$cmbHammerColor.DropDownStyle = "DropDownList"
$cmbHammerColor.DropDownHeight = "600"
$cmbHammerColor.Enabled = $false
$panel.Controls.Add($cmbHammerColor)

#Trennlinie 4
$line4 = New-Object System.Windows.Forms.Label
$line4.BorderStyle = "Fixed3D"
$line4.AutoSize = $false
$line4.Height = $lineheight
$line4.Width = $linewidth
$line4.Location = New-Object System.Drawing.Point($x1lbl,$Yline)
$panel.Controls.Add($line4)
$Yline += $Yplus
$Ylbl += $Yplus
$Ycmb += $Yplus

# === 5. Trigger ===
$lblTrigger = New-Object System.Windows.Forms.Label
$lblTrigger.Text = "Choose a trigger:"
$lblTrigger.Location = New-Object System.Drawing.Point($x1lbl,$Ylbl)
$lblTrigger.AutoSize = $true
$panel.Controls.Add($lblTrigger)

$cmbTrigger = New-Object System.Windows.Forms.ComboBox
$cmbTrigger.Location = New-Object System.Drawing.Point($x1cmb,$Ycmb)
$cmbTrigger.Size = New-Object System.Drawing.Size(($xcmbsize, $ycmbsize))
$cmbTrigger.DropDownStyle = "DropDownList"
$cmbTrigger.DropDownHeight = "600"
$cmbTrigger.Items.AddRange(@(
    "long hole",
    "three holes",
    "solid",
    "arrow"
))
$panel.Controls.Add($cmbTrigger)

# === 5.1 Trigger Color ===
$lblTriggerColor = New-Object System.Windows.Forms.Label
$lblTriggerColor.Text = "Trigger color:"
$lblTriggerColor.Location = New-Object System.Drawing.Point($x2lbl,$Ylbl)
$lblTriggerColor.AutoSize = $true
$lblTriggerColor.Enabled = $false
$panel.Controls.Add($lblTriggerColor)

$cmbTriggerColor = New-Object System.Windows.Forms.ComboBox
$cmbTriggerColor.Location = New-Object System.Drawing.Point($x2cmb,$Ycmb)
$cmbTriggerColor.Size = New-Object System.Drawing.Size($xcmbsize, $ycmbsize)
$cmbTriggerColor.DropDownStyle = "DropDownList"
$cmbTriggerColor.DropDownHeight = "600"
$cmbTriggerColor.Enabled = $false
$panel.Controls.Add($cmbTriggerColor)

#Trennlinie 5
$line5 = New-Object System.Windows.Forms.Label
$line5.BorderStyle = "Fixed3D"
$line5.AutoSize = $false
$line5.Height = $lineheight
$line5.Width = $linewidth
$line5.Location = New-Object System.Drawing.Point($x1lbl,$Yline)
$panel.Controls.Add($line5)
$Yline += $Yplus
$Ylbl += $Yplus
$Ycmb += $Yplus

# === 6. Slide ===
$lblSlide = New-Object System.Windows.Forms.Label
$lblSlide.Text = "Choose a slide:"
$lblSlide.Location = New-Object System.Drawing.Point($x1lbl,$Ylbl)
$lblSlide.AutoSize = $true
$panel.Controls.Add($lblSlide)

$cmbSlide = New-Object System.Windows.Forms.ComboBox
$cmbSlide.Location = New-Object System.Drawing.Point($x1cmb,$Ycmb)
$cmbSlide.Size = New-Object System.Drawing.Size($xcmbsize, $ycmbsize)
$cmbSlide.DropDownStyle = "DropDownList"
$cmbSlide.DropDownHeight = "600"
$cmbSlide.Items.AddRange(@(
    "1911 standard",
    "Barcode",
    "Season 2",
    "Steel Blue",
    "Special",
    "Olive Tan",
    "Black Hitman Insignia",
    "Silver shiny dimpled (red sight)",
    "Black Hexagons"
    #"Spraypaint"
))
$panel.Controls.Add($cmbSlide)


# === 6.x Slide Color ===
$lblSlideColor = New-Object System.Windows.Forms.Label
$lblSlideColor.Text = "Slide color:"
$lblSlideColor.Location = New-Object System.Drawing.Point($x2lbl,$Ylbl)
$lblSlideColor.AutoSize = $true
$lblSlideColor.Enabled = $false
$panel.Controls.Add($lblSlideColor)

$cmbSlideColor = New-Object System.Windows.Forms.ComboBox
$cmbSlideColor.Location = New-Object System.Drawing.Point($x2cmb,$Ycmb)
$cmbSlideColor.Size = New-Object System.Drawing.Size($xcmbsize, $ycmbsize)
$cmbSlideColor.DropDownStyle = "DropDownList"
$cmbSlideColor.DropDownHeight = "600"
$cmbSlideColor.Enabled = $false
$panel.Controls.Add($cmbSlideColor)

#Trennlinie 6
$line6 = New-Object System.Windows.Forms.Label
$line6.BorderStyle = "Fixed3D"
$line6.AutoSize = $false
$line6.Height = $lineheight
$line6.Width = $linewidth
$line6.Location = New-Object System.Drawing.Point($x1lbl,$Yline)
$panel.Controls.Add($line6)
$Yline += $Yplus
$Ylbl += $Yplus
$Ycmb += $Yplus


# === 7. Grip ===
$lblGrip = New-Object System.Windows.Forms.Label
$lblGrip.Text = "Choose a grip:"
$lblGrip.Location = New-Object System.Drawing.Point($x1lbl,$Ylbl)
$lblGrip.AutoSize = $true
$panel.Controls.Add($lblGrip)

$cmbGrip = New-Object System.Windows.Forms.ComboBox
$cmbGrip.Location = New-Object System.Drawing.Point($x1cmb,$Ycmb)
$cmbGrip.Size = New-Object System.Drawing.Size($xcmbsize, $ycmbsize)
$cmbGrip.DropDownStyle = "DropDownList"
$cmbGrip.DropDownHeight = "600"
$cmbGrip.Items.AddRange(@(
    "Standard",
    "Wood",
    "Wood full ergo",
    "Black"
    #"Spraypaint"
))
$panel.Controls.Add($cmbGrip)


# === 7.x Grip Color ===
$lblGripColor = New-Object System.Windows.Forms.Label
$lblGripColor.Text = "Grip color:"
$lblGripColor.Location = New-Object System.Drawing.Point($x2lbl,$Ylbl)
$lblGripColor.AutoSize = $true
$lblGripColor.Enabled = $false
$panel.Controls.Add($lblGripColor)

$cmbGripColor = New-Object System.Windows.Forms.ComboBox
$cmbGripColor.Location = New-Object System.Drawing.Point($x2cmb,$Ycmb)
$cmbGripColor.Size = New-Object System.Drawing.Size($xcmbsize, $ycmbsize)
$cmbGripColor.DropDownStyle = "DropDownList"
$cmbGrip.DropDownHeight = "600"
$cmbGripColor.Enabled = $false
$panel.Controls.Add($cmbGripColor)

#Trennlinie 7
$line7 = New-Object System.Windows.Forms.Label
$line7.BorderStyle = "Fixed3D"
$line7.AutoSize = $false
$line7.Height = $lineheight
$line7.Width = $linewidth
$line7.Location = New-Object System.Drawing.Point($x1lbl,$Yline)
$panel.Controls.Add($line7)
$Yline += $Yplus
$Ylbl += $Yplus
$Ycmb += $Yplus


# === 8. Grip Cover ===
$lblGripCover = New-Object System.Windows.Forms.Label
$lblGripCover.Text = "Choose a grip cover:"
$lblGripCover.Location = New-Object System.Drawing.Point($x1lbl,$Ylbl)
$lblGripCover.AutoSize = $true
$lblGripCover.Enabled = $false
$panel.Controls.Add($lblGripCover)

$cmbGripCover = New-Object System.Windows.Forms.ComboBox
$cmbGripCover.Location = New-Object System.Drawing.Point($x1cmb,$Ycmb)
$cmbGripCover.Size = New-Object System.Drawing.Size($xcmbsize, $ycmbsize)
$cmbGripCover.DropDownStyle = "DropDownList"
$cmbGripCover.DropDownHeight = "600"
$cmbGripCover.Items.AddRange(@(
    "No gripcover",
    "Leathercover"
))
$cmbGripCover.Enabled = $false
$panel.Controls.Add($cmbGripCover)

# === 8.1 Grip Cover Color ===
$lblGripCoverColor = New-Object System.Windows.Forms.Label
$lblGripCoverColor.Text = "Gripcover color:"
$lblGripCoverColor.Location = New-Object System.Drawing.Point($x2lbl,$Ylbl)
$lblGripCoverColor.AutoSize = $true
$lblGripCoverColor.Enabled = $false
$panel.Controls.Add($lblGripCoverColor)

$cmbGripCoverColor = New-Object System.Windows.Forms.ComboBox
$cmbGripCoverColor.Location = New-Object System.Drawing.Point($x2cmb,$Ycmb)
$cmbGripCoverColor.Size = New-Object System.Drawing.Size($xcmbsize, $ycmbsize)
$cmbGripCoverColor.DropDownStyle = "DropDownList"
$cmbGripCoverColor.DropDownHeight = "600"
$cmbGripCoverColor.Enabled = $false
$panel.Controls.Add($cmbGripCoverColor)

#Trennlinie 8
$line8 = New-Object System.Windows.Forms.Label
$line8.BorderStyle = "Fixed3D"
$line8.AutoSize = $false
$line8.Height = $lineheight
$line8.Width = $linewidth
$line8.Location = New-Object System.Drawing.Point($x1lbl,$Yline)
$panel.Controls.Add($line8)
$Yline += $Yplus
$Ylbl += $Yplus
$Ycmb += $Yplus


# === 9. Grip Safety ===
$lblGripSafety = New-Object System.Windows.Forms.Label
$lblGripSafety.Text = "Choose a grip safety:"
$lblGripSafety.Location = New-Object System.Drawing.Point($x1lbl,$Ylbl)
$lblGripSafety.AutoSize = $true
$panel.Controls.Add($lblGripSafety)

$cmbGripSafety = New-Object System.Windows.Forms.ComboBox
$cmbGripSafety.Location = New-Object System.Drawing.Point($x1cmb,$Ycmb)
$cmbGripSafety.Size = New-Object System.Drawing.Size($xcmbsize, $ycmbsize)
$cmbGripSafety.DropDownStyle = "DropDownList"
$cmbGripSafety.DropDownHeight = "600"
$cmbGripSafety.Items.AddRange(@(
    "small",
    "big"
))
$panel.Controls.Add($cmbGripSafety)


# === 9.1 Grip Safety Color ===
$lblGripSafetyColor = New-Object System.Windows.Forms.Label
$lblGripSafetyColor.Text = "Grip safety color:"
$lblGripSafetyColor.Location = New-Object System.Drawing.Point($x2lbl,$Ylbl)
$lblGripSafetyColor.AutoSize = $true
$lblGripSafetyColor.Enabled = $false
$panel.Controls.Add($lblGripSafetyColor)

$cmbGripSafetyColor = New-Object System.Windows.Forms.ComboBox
$cmbGripSafetyColor.Location = New-Object System.Drawing.Point($x2cmb,$Ycmb)
$cmbGripSafetyColor.Size = New-Object System.Drawing.Size($xcmbsize, $ycmbsize)
$cmbGripSafetyColor.DropDownStyle = "DropDownList"
$cmbGripSafetyColor.DropDownHeight = "600"
$cmbGripSafetyColor.Enabled = $false
$panel.Controls.Add($cmbGripSafetyColor)

#Trennlinie 9
$line9 = New-Object System.Windows.Forms.Label
$line9.BorderStyle = "Fixed3D"
$line9.AutoSize = $false
$line9.Height = $lineheight
$line9.Width = $linewidth
$line9.Location = New-Object System.Drawing.Point($x1lbl,$Yline)
$panel.Controls.Add($line9)
$Yline += $Yplus
$Ylbl += $Yplus
$Ycmb += $Yplus

# === 10. Magazine ===
$lblMagazine = New-Object System.Windows.Forms.Label
$lblMagazine.Text = "Choose a magazine:"
$lblMagazine.Location = New-Object System.Drawing.Point($x1lbl,$Ylbl)
$lblMagazine.AutoSize = $true
$panel.Controls.Add($lblMagazine)

$cmbMagazine = New-Object System.Windows.Forms.ComboBox
$cmbMagazine.Location = New-Object System.Drawing.Point($x1cmb,$Ycmb)
$cmbMagazine.Size = New-Object System.Drawing.Size($xcmbsize, $ycmbsize)
$cmbMagazine.DropDownStyle = "DropDownList"
$cmbMagazine.DropDownHeight = "600"
$cmbMagazine.Items.AddRange(@(
    "short",
    "short 1911 standard",
    "long 1911",
    "chrome extended"
))
$panel.Controls.Add($cmbMagazine)

# === 10.1 Magazine Color ===
$lblMagazineColor = New-Object System.Windows.Forms.Label
$lblMagazineColor.Text = "Magazine color:"
$lblMagazineColor.Location = New-Object System.Drawing.Point($x2lbl,$Ylbl)
$lblMagazineColor.AutoSize = $true
$lblMagazineColor.Enabled = $false
$panel.Controls.Add($lblMagazineColor)

$cmbMagazineColor = New-Object System.Windows.Forms.ComboBox
$cmbMagazineColor.Location = New-Object System.Drawing.Point($x2cmb,$Ycmb)
$cmbMagazineColor.Size = New-Object System.Drawing.Size($xcmbsize, $ycmbsize)
$cmbMagazineColor.DropDownStyle = "DropDownList"
$cmbMagazineColor.DropDownHeight = "600"
$cmbMagazineColor.Enabled = $false
$panel.Controls.Add($cmbMagazineColor)

#Trennlinie 10
$line10 = New-Object System.Windows.Forms.Label
$line10.BorderStyle = "Fixed3D"
$line10.AutoSize = $false
$line10.Height = $lineheight
$line10.Width = $linewidth
$line10.Location = New-Object System.Drawing.Point($x1lbl,$Yline)
$panel.Controls.Add($line10)
$Yline += $Yplus
$Ylbl += $Yplus
$Ycmb += $Yplus

# === 11. muzzle extension ===
$lblMuzzleExtension = New-Object System.Windows.Forms.Label
$lblMuzzleExtension.Text = "Choose a muzzle extension:"
$lblMuzzleExtension.Location = New-Object System.Drawing.Point($x1lbl,$Ylbl)
$lblMuzzleExtension.AutoSize = $true
$panel.Controls.Add($lblMuzzleExtension)

$cmbMuzzleExtension = New-Object System.Windows.Forms.ComboBox
$cmbMuzzleExtension.Location = New-Object System.Drawing.Point($x1cmb,$Ycmb)
$cmbMuzzleExtension.Size = New-Object System.Drawing.Size($xcmbsize, $ycmbsize)
$cmbMuzzleExtension.DropDownStyle = "DropDownList"
$cmbMuzzleExtension.DropDownHeight = "600"
$cmbMuzzleExtension.Items.AddRange(@(
    "No extension",
    #"Muzzle brake",
    "Striker compensator",
    "Round Suppressor",
    "Short round Suppressor",
    "Rus Suppressor",
    "Square suppressor",
    "Striker compensator 2 (more holes)",
    #"Spray paint can",
    "Round suppressor ducky"
    #"Spray paint can yellow"
))
$panel.Controls.Add($cmbMuzzleExtension)

# === 11.x muzzle extension color (dynamisch sichtbar) ===
$lblMuzzleExtensionColor = New-Object System.Windows.Forms.Label
$lblMuzzleExtensionColor.Text = "Muzzle extension color:"
$lblMuzzleExtensionColor.Location = New-Object System.Drawing.Point($x2lbl,$Ylbl)
$lblMuzzleExtensionColor.AutoSize = $true
$lblMuzzleExtensionColor.Enabled = $false
$panel.Controls.Add($lblMuzzleExtensionColor)

$cmbMuzzleExtensionColor = New-Object System.Windows.Forms.ComboBox
$cmbMuzzleExtensionColor.Location = New-Object System.Drawing.Point($x2cmb,$Ycmb)
$cmbMuzzleExtensionColor.Size = New-Object System.Drawing.Size($xcmbsize, $ycmbsize)
$cmbMuzzleExtensionColor.DropDownStyle = "DropDownList"
$cmbMuzzleExtensionColor.DropDownHeight = "600"
$cmbMuzzleExtensionColor.Enabled = $false
$panel.Controls.Add($cmbMuzzleExtensionColor)

#Trennlinie 11
$line11 = New-Object System.Windows.Forms.Label
$line11.BorderStyle = "Fixed3D"
$line11.AutoSize = $false
$line11.Height = $lineheight
$line11.Width = $linewidth
$line11.Location = New-Object System.Drawing.Point($x1lbl,$Yline)
$panel.Controls.Add($line11)
$Yline += $Yplus
$Ylbl += $Yplus
$Ycmb += $Yplus

# === 12. Gun Sound ===
$lblSound = New-Object System.Windows.Forms.Label
$lblSound.Text = "Choose a gun sound:"
$lblSound.Location = New-Object System.Drawing.Point($x1lbl,$Ylbl)
$lblSound.AutoSize = $true
$panel.Controls.Add($lblSound)

$cmbSound = New-Object System.Windows.Forms.ComboBox
$cmbSound.Location = New-Object System.Drawing.Point($x1cmb,$Ycmb)
$cmbSound.Size = New-Object System.Drawing.Size($xcmbsize, $ycmbsize)
$cmbSound.DropDownStyle = "DropDownList"
$cmbSound.DropDownHeight = "600"
$cmbSound.Items.AddRange(@(
    "loud",
    "suppressed"
))
$panel.Controls.Add($cmbSound)

# === 12.x Sound Style ===
$lblSoundStyle = New-Object System.Windows.Forms.Label
$lblSoundStyle.Text = "Sound style:"
$lblSoundStyle.Location = New-Object System.Drawing.Point($x2lbl,$Ylbl)
$lblSoundStyle.AutoSize = $true
$lblSoundStyle.Enabled = $false
$panel.Controls.Add($lblSoundStyle)

$cmbSoundStyle = New-Object System.Windows.Forms.ComboBox
$cmbSoundStyle.Location = New-Object System.Drawing.Point($x2cmb,$Ycmb)
$cmbSoundStyle.Size = New-Object System.Drawing.Size($xcmbsize, $ycmbsize)
$cmbSoundStyle.DropDownStyle = "DropDownList"
$cmbSoundStyle.DropDownHeight = "600"
$cmbSoundStyle.Enabled = $false
$panel.Controls.Add($cmbSoundStyle)

#Trennlinie 12
$line12 = New-Object System.Windows.Forms.Label
$line12.BorderStyle = "Fixed3D"
$line12.AutoSize = $false
$line12.Height = $lineheight
$line12.Width = $linewidth
$line12.Location = New-Object System.Drawing.Point($x1lbl,$Yline)
$panel.Controls.Add($line12)
$Yline += $Yplus
$Ylbl += $Yplus
$Ycmb += $Yplus

# === 13. Scope ===
$lblScope = New-Object System.Windows.Forms.Label
$lblScope.Text = "Choose a scope:"
$lblScope.Location = New-Object System.Drawing.Point($x1lbl,$Ylbl)
$lblScope.AutoSize = $true
$panel.Controls.Add($lblScope)

$cmbScope = New-Object System.Windows.Forms.ComboBox
$cmbScope.Location = New-Object System.Drawing.Point($x1cmb,$Ycmb)
$cmbScope.Size = New-Object System.Drawing.Size($xcmbsize, $ycmbsize)
$cmbScope.DropDownStyle = "DropDownList"
$cmbScope.DropDownHeight = "600"
$cmbScope.Items.AddRange(@(
    "No scope",
    "Holo",
    "Aimpoint",
    "Reflex",
    "Reflex 2"
))
$panel.Controls.Add($cmbScope)

# === 13.1 Scope Color ===
$lblScopeColor = New-Object System.Windows.Forms.Label
$lblScopeColor.Text = "Scope color:"
$lblScopeColor.Location = New-Object System.Drawing.Point($x2lbl,$Ylbl)
$lblScopeColor.AutoSize = $true
$lblScopeColor.Enabled = $false
$panel.Controls.Add($lblScopeColor)

$cmbScopeColor = New-Object System.Windows.Forms.ComboBox
$cmbScopeColor.Location = New-Object System.Drawing.Point($x2cmb,$Ycmb)
$cmbScopeColor.Size = New-Object System.Drawing.Size($xcmbsize, $ycmbsize)
$cmbScopeColor.DropDownStyle = "DropDownList"
$cmbScopeColor.DropDownHeight = "600"
$cmbScopeColor.Enabled = $false
$panel.Controls.Add($cmbScopeColor)

#Trennlinie 13
$line13 = New-Object System.Windows.Forms.Label
$line13.BorderStyle = "Fixed3D"
$line13.AutoSize = $false
$line13.Height = $lineheight
$line13.Width = $linewidth
$line13.Location = New-Object System.Drawing.Point($x1lbl,$Yline)
$panel.Controls.Add($line13)
$Yline += $Yplus
$Ylbl += $Yplus
$Ycmb += $Yplus

# === 14. Firemod ===
$lblFireMode = New-Object System.Windows.Forms.Label
$lblFireMode.Text = "Choose a fire mode"
$lblFireMode.Location = New-Object System.Drawing.Point($x1lbl,$Ylbl)
$lblFireMode.AutoSize = $true
$panel.Controls.Add($lblFireMode)

$cmbFireMode = New-Object System.Windows.Forms.ComboBox
$cmbFireMode.Location = New-Object System.Drawing.Point($x1cmb,$Ycmb)
$cmbFireMode.Size = New-Object System.Drawing.Size($xcmbsize, $ycmbsize)
$cmbFireMode.DropDownStyle = "DropDownList"
$cmbFireMode.DropDownHeight = "600"
$cmbFireMode.Items.AddRange(@(
    "single fire",
    "full auto"
))
$panel.Controls.Add($cmbFireMode)

#Trennlinie 14
$line14 = New-Object System.Windows.Forms.Label
$line14.BorderStyle = "Fixed3D"
$line14.AutoSize = $false
$line14.Height = $lineheight
$line14.Width = $linewidth
$line14.Location = New-Object System.Drawing.Point($x1lbl,$Yline)
$panel.Controls.Add($line14)
$Yline += $Yplus
$Ylbl += $Yplus
$Ycmb += $Yplus



# === Logik: Barrel-Auswahl ===
$cmbBarrel.Add_SelectedIndexChanged({
    $lblBarrelColor.Enabled = $true
    $cmbBarrelColor.Enabled = $true
    $cmbBarrelColor.Items.Clear()

    switch ($cmbBarrel.SelectedItem) {
        "short barrel" {
            $cmbBarrelColor.Items.AddRange(@(
               "black",
               "chrome",
               "silver matt",
               "gold",
               "grey"
            ))
        }
        "long barrel" {
            $cmbBarrelColor.Items.AddRange(@(
               "black",
               "chrome",
               "silver matt"
            ))
        }
        default {
            $lblBarrelColor.Enabled = $false
            $cmbBarrelColor.Enabled = $false
        }
    }
})


# === Logik: Frame-Auswahl ===
$cmbFrame.Add_SelectedIndexChanged({
    $show = ($cmbFrame.SelectedItem -eq "1911 Standard")
    $lblFrameColor.Enabled = $show
    $cmbFrameColor.Enabled = $show
# Falls Black Tomb Raider gewählt wird folgendes ausblenden:
    if ($cmbFrame.SelectedItem -eq "Black Tomb Raider") {
        $lblFrameColor.Enabled = $false
        $cmbFrameColor.Enabled = $false
        $cmbGripColor.Enabled = $false
        $lblGripColor.Enabled = $false
        $lblGripCover.Enabled = $false
        $cmbGripCover.Enabled = $false
        $lblGripCoverColor.Enabled = $false
        $cmbGripCoverColor.Enabled = $false
        $lblGrip.Enabled = $false
        $cmbGrip.Enabled = $false
        $lblTriggerColor.Enabled = $false
        $cmbTriggerColor.Enabled = $false
        $lblTrigger.Enabled = $false
        $cmbTrigger.Enabled = $false
        $lblMuzzleExtensionColor.Enabled = $false
        $cmbMuzzleExtensionColor.Enabled = $false
        $lblMuzzleExtension.Enabled = $false
        $cmbMuzzleExtension.Enabled = $false
        

        # Text/Selection zurücksetzen
        $cmbFrameColor.SelectedIndex = -1
        $cmbGrip.SelectedIndex = -1
        $cmbGripColor.SelectedIndex = -1
        $cmbGripCover.SelectedIndex = -1
        $cmbGripCoverColor.SelectedIndex = -1
        $cmbTrigger.SelectedIndex = -1
        $cmbTriggerColor.SelectedIndex = -1
        $cmbMuzzleExtension.SelectedIndex = -1
        $cmbMuzzleExtensionColor.SelectedIndex = -1

        }
        else {
        # Reaktivieren
        $lblGrip.Enabled = $true
        $cmbGrip.Enabled = $true
        $lblTrigger.Enabled = $true
        $cmbTrigger.Enabled = $true
        $lblMuzzleExtension.Enabled = $true
        $cmbMuzzleExtension.Enabled = $true
        }       
})

# === Logik: Hammer-Auswahl ===
$cmbHammer.Add_SelectedIndexChanged({
    $lblHammerColor.Enabled = $true
    $cmbHammerColor.Enabled = $true
    $cmbHammerColor.Items.Clear()

    switch ($cmbHammer.SelectedItem) {
        "Ring Hammer" {
            $cmbHammerColor.Items.AddRange(@(
                "black",
                "chrome",
                "silver matt"
                
            ))
        }
        default {
            $lblHammerColor.Enabled = $false
            $cmbHammerColor.Enabled = $false
        }
        }
})

# === Logik: Trigger-Auswahl ===

$cmbTrigger.Add_SelectedIndexChanged({
    $lblTriggerColor.Enabled = $true
    $cmbTriggerColor.Enabled = $true
    $cmbTriggerColor.Items.Clear()
    
    switch ($cmbTrigger.SelectedItem) {
        "long hole" {
            $cmbTriggerColor.Items.AddRange(@(
                "black",
                "silver matt",
                "chrome"
            ))
        }
        "three holes" {
            $cmbTriggerColor.Items.AddRange(@(
                "black",
                "silver matt",
                "chrome",
                "gold"
            ))
        }
        "Solid" {
            $cmbTriggerColor.Items.AddRange(@(
                "black",
                "silver matt",
                "chrome"
            ))
        }
        default {
            $lblTriggerColor.Enabled = $false
            $cmbTriggerColor.Enabled = $false
        }
    }
})

# === Logik: Slide-Auswahl ===
$cmbSlide.Add_SelectedIndexChanged({
    $lblSlideColor.Enabled = $true
    $cmbSlideColor.Enabled = $true
    $cmbSlideColor.Items.Clear()

    switch ($cmbSlide.SelectedItem) {
        "1911 standard" {
            $cmbSlideColor.Items.AddRange(@(
                "black",
                "silver matt",
                "silver chrome",
                "gold matador",
                "gold",
                "silver shiny kimber",
                "chrome arrows",
                "silver shiny dimpled"
            ))
        }
        "Barcode" {
            $cmbSlideColor.Items.AddRange(@(
                "black",
                "silver shiny"
            ))
        }
        "Special" {
            $cmbSlideColor.Items.AddRange(@(
                "black kimber big hitman insignia",
                "hexagons",
                "steel floral",
                "cherry floral"
            ))
        }
        default {
            $lblSlideColor.Enabled = $false
            $cmbSlideColor.Enabled = $false
        }
    }
})

# === Logik: Grip-Auswahl ===
$cmbGrip.Add_SelectedIndexChanged({
    $cmbGripColor.Items.Clear()
    $lblGripColor.Enabled = $true
    $cmbGripColor.Enabled = $true
    $lblGripCover.Enabled = $true
    $cmbGripCover.Enabled = $true

    switch ($cmbGrip.SelectedItem) {
        "Standard" {
            $cmbGripColor.Items.AddRange(@(
                "black rubber fish scales",
                "black plastic",
                "white skull",
                "white snake",
                "red",
                "grey rubber squares",
                "metal blue striped",
                "metal blue dimpled",
                "orange ducky"
            ))
        }
        "Wood" {
            $cmbGripColor.Items.AddRange(@(
                "orange brown",
                "light brown",
                "cherry brown",
                "black snake",
                "brown floral",
                "cherry pink floral"
            ))
        }
        "Wood full ergo" {
            $lblGripColor.Enabled = $false
            $cmbGripColor.Enabled = $false
            $lblGripCover.Enabled = $false
            $cmbGripCover.Enabled = $false
            $lblGripCoverColor.Enabled = $false
            $cmbGripCoverColor.Enabled = $false
        }
        "Black" {
            $cmbGripColor.Items.AddRange(@(
                "black snake skin",
                "black"
            ))
        }
        "Spraypaint" {
            $lblGripColor.Enabled = $false
            $cmbGripColor.Enabled = $false
        }
        default {
            $lblGripColor.Enabled = $false
            $cmbGripColor.Enabled = $false
        }
    }
})

# === Logik: Grip Cover-Auswahl ===
$cmbGripCover.Add_SelectedIndexChanged({
    $show = ($cmbGripCover.SelectedItem -eq "Leathercover" -and $cmbGrip.SelectedItem -ne "Wood full ergo")
    $lblGripCoverColor.Enabled = $show
    $cmbGripCoverColor.Enabled = $show

    if ($show) {
        $cmbGripCoverColor.Items.Clear()
        $cmbGripCoverColor.Items.AddRange(@(
            "black (silver circle, black screw)",
            "black (red circle)",
            "black (black circle, white screw)",
            "black matt (silver circle, black screw)",
            "black big insignia"

        ))
    }
})

# === Logik: Grip-Safety-Auswahl ===
$cmbGripSafety.Add_SelectedIndexChanged({
    $lblGripSafetyColor.Enabled = $true
    $cmbGripSafetyColor.Enabled = $true
    $cmbGripSafetyColor.Items.Clear()

    switch ($cmbGripSafety.SelectedItem) {
        "small" {
            $cmbGripSafetyColor.Items.AddRange(@(
                "black",
                "silver matt",
                "silver chrome"


            ))
        }
        "big" {
            $cmbGripSafetyColor.Items.AddRange(@(
                "black",
                "silver matt",
                "chrome",
                "gold",
                "black blue"
            ))
        }
        default {
            $lblGripSafetyColor.Enabled = $false
            $cmbGripSafetyColor.Enabled = $false
        }
    }
})

# === Logik: Magazine-Auswahl ===
$cmbMagazine.Add_SelectedIndexChanged({
    $lblMagazineColor.Enabled = $true
    $cmbMagazineColor.Enabled = $true
    $cmbMagazineColor.Items.Clear()

    switch ($cmbMagazine.SelectedItem) {
        "Short" {
            $cmbMagazineColor.Items.AddRange(@(
                    "black",
                    "chrome",
                    "silver matt"
            ))
        }
        "short 1911 standard" {
            $cmbMagazineColor.Items.AddRange(@(
                "black",
                    "chrome",
                    "silver matt",
                    "gold"
            ))
        }
        "long 1911" {
            $cmbMagazineColor.Items.AddRange(@(
                "black",
                "chrome",
                "silver matt",
                "black hexagons"
            ))
        }
        default {
            $lblMagazineColor.Enabled = $false
            $cmbMagazineColor.Enabled = $false
        }
    }
})

# === Logik: MuzzleExtension-Auswahl steuert die Farb-Liste ===
$cmbMuzzleExtension.Add_SelectedIndexChanged({
    $lblMuzzleExtensionColor.Enabled = $true
    $cmbMuzzleExtensionColor.Enabled = $true
    $cmbMuzzleExtensionColor.Items.Clear()

    switch ($cmbMuzzleExtension.SelectedItem) {
        "Striker compensator" {
            $cmbMuzzleExtensionColor.Items.AddRange(@(
                "chrome",
                "silver shiny"
            ))
        }
        "Round Suppressor" {
            $cmbMuzzleExtensionColor.Items.AddRange(@(
                "black (white text)",
                "silver chrome",
                "black (black text)",
                "gold",
                "black floral",
                "cherry floral"
            ))
        }
        "Striker compensator 2 (more holes)" {
            $cmbMuzzleExtensionColor.Items.AddRange(@(
                "chrome ",
                "silver matt"
            ))
        }
        default {
            $lblMuzzleExtensionColor.Enabled = $false
            $cmbMuzzleExtensionColor.Enabled = $false
        }
    }
    # Falls Suppressor gewählt, folgendes ausblenden:
    if ($cmbMuzzleExtension.SelectedItem -like "*Suppressor*") {
        $lblSound.Enabled = $false
        $cmbSound.Enabled = $false
        $lblSoundStyle.Enabled = $false
        $cmbSoundStyle.Enabled = $false


        # Text/Selection zurücksetzen
        $cmbSound.SelectedIndex = -1
        $cmbSoundStyle.SelectedIndex = -1
    }
    else {
        $lblSound.Enabled = $true
        $cmbSound.Enabled = $true
    }

})

# === Logik: Sound Style Auswahl ===
$cmbSound.Add_SelectedIndexChanged({
        $lblSoundStyle.Enabled = $true
        $cmbSoundStyle.Enabled = $true
        $cmbSoundStyle.Items.Clear()

    switch ($cmbSound.SelectedItem) {
        "loud" {
            $cmbSoundStyle.Items.AddRange(@(
                "ICA19 FA",
                "Classicballer",
                "Striker"
            ))
    }
        default {
            $lblSoundstyle.Enabled = $false
            $cmbSoundstyle.Enabled = $false
        }
    }
})

# === Logik: Scope-Auswahl ===
$cmbScope.Add_SelectedIndexChanged({
        $lblScopeColor.Enabled = $true
        $cmbScopeColor.Enabled = $true
        $cmbScopeColor.Items.Clear()

    switch ($cmbScope.SelectedItem) {
        "Aimpoint" {
            $cmbScopeColor.Items.AddRange(@(
                "green",
                "red"
            ))
    }
        default {
            $lblScopeColor.Enabled = $false
            $cmbScopeColor.Enabled = $false
        }
    }
})





function Set-SelectedVariables {
    # --- Weapon Mapping ---
    $WeaponMap = @{
        "ICA19" =@{
        Code = "73875794-5a86-410e-84a4-1b5b2f7e5a54"
        LocalizationWeaponHSH = "0024A5A15AC9CC2F"
        LocalizationTitleHSH = "2889860233"
        LocalizationDesc = "4188608219"
        Replace = "ICA19"
    } 
        "Silverballer" =@{
        Code = "e70adb5b-0646-4f88-bd4a-85bea7a2a654"
        LocalizationWeaponHSH = "0072D1A320470342"
        LocalizationTitleHSH = "257149234"
        LocalizationDesc = "4188608219"
        Replace = "ICA19 Silverballer"
    }
        "Silverballer S2" =@{
        Code = "4bbe3b64-8bce-416e-a3e9-00bcd1571980"
        LocalizationWeaponHSH = "0072D1A320470342"
        LocalizationTitleHSH = "947915283"
        LocalizationDesc = "1830213697"
        Replace = "ICA19 Silverballer S2"
    }
        "ICA19 Chrome" =@{
        Code = "341ba426-d52d-4ae3-97a9-40b9b3633d76"
        LocalizationWeaponHSH = "0072D1A320470342"
        LocalizationTitleHSH = "3915418648"
        LocalizationDesc = "4188608219"
        Replace = "ICA19 Chrome"
    }
        "Black Lilly" =@{
        Code = "f93b99a3-aef6-419f-b303-59470577696d"
        LocalizationWeaponHSH = "0072D1A320470342"
        LocalizationTitleHSH = "2998331766"
        LocalizationDesc = "3877649188"
        Replace = "ICA19 Black Lilly"
    }
        "Goldballer" =@{
        Code = "028bcbf4-a0a3-42b5-beaf-163a777164e8"
        LocalizationWeaponHSH = "0072D1A320470342"
        LocalizationTitleHSH = "4120886973"
        LocalizationDesc = "2684972271"
        Replace = "ICA19 Goldballer"
    }
        "Classic Baller" =@{
        Code = "ff340698-bc83-479c-8917-16d99b39406c"
        LocalizationWeaponHSH = "006986A5A3F98191"
        LocalizationTitleHSH = "3819572738"
        LocalizationDesc = "3057441872"
        Replace = "ICA19 Classicballer"
    }
        "Shortballer" =@{
        Code = "ebff0c9a-e04d-4bc2-8f7a-e9c3cd6d6a93"
        LocalizationWeaponHSH = "006986A5A3F98191"
        LocalizationTitleHSH = "3351602240"
        LocalizationDesc = "2454959634"
        Replace = "ICA19 Shortballer"
    }
        "Striker" = @{
        Code = "15291f69-88d0-4a8f-b31b-71605ba5ff38"
        LocalizationWeaponHSH = "0072D1A320470342"
        LocalizationTitleHSH = "1313064352"
        LocalizationDesc = "466950130"
        Replace = "Striker"
    }
    "ICA19 F/A" =@{
        Code = "be4e7b4e-d895-47c1-979d-d79bfbe79a02"
        LocalizationWeaponHSH = "0072D1A320470342"
        LocalizationTitleHSH = "3940476283"
        LocalizationDesc = "2316018806"
        Replace = "ICA19 F/A"
    } 
    "ICA19 F/A Stealth" =@{
        Code = "214004ec-5c86-4c26-8403-9e83a9bcdd24"
        LocalizationWeaponHSH = "0072D1A320470342"
        LocalizationTitleHSH = "2839309394"
        LocalizationDesc = "4239048192"
        Replace = "ICA19 F/A Stealth"
    } 
    }


    $BarrelMap = @{
        "short barrel" = "0"
        "long barrel"  = "1"
    }

    $BarrelColorMap = @{
        "black"       = "0"
        "chrome"      = "1"
        "silver matt" = "2"
        "gold"        = "3"
        "grey"  = "4"
    }

    $FrameMap = @{
        "1911 Standard"     = "0"
        "Black with Rail"   = "1"
        "Black Tomb Raider" = "3"
        "Spraypaint"        = "4"
    }

    $FrameColorMap = @{
        "Black"                     = "0"
        "Silver Matt"               = "1"
        "Silver Chrome"             = "2"
        "Matador"                   = "3"
        "Gold"                      = "4"
        "Chrome"                    = "5"
        "Black shiny"               = "6"
        "Tan"                       = "7"
        "dark chrome"               = "8"
        "Silver Shiny (black safeguard)" = "9"
        "Yellow (ducky)"            = "10"
        "Steel Floral"              =  "11"
        "Cherry Floral"             =  "12"
        ""                          =  "0"
    }

    $HammerMap = @{
        "Classic Chrome Hammer" =  "0"
        "Ring Hammer"           =  "1"
    }

    $HammerColorMap = @{
        "black"       =  "0"
        "chrome"      =  "1"
        "silver matt" =  "2"
        "gold"        =  "3"
        ""            =  "0"
    }

    $TriggerMap = @{
        "long hole"   = "0"
        "three holes" = "1"
        "solid"       = "2"
        "arrow"       = "3"
    }

    $TriggerColorMap = @{
        "black"       = "0"
        "chrome"      = "1"
        "silver matt" = "2"
        "gold"        = "3"
        "black blue"            = "4"
    }

    $SlideMap = @{
        "1911 standard"                = "0"
        "Barcode"                      = "1"
        "Season 2"                     = "2"
        "Steel Blue"                   = "3"
        "Special"                      = "4"
        "Olive Tan"                        = "5"
        "Black Hitman Insignia"        = "6"
        "Silver shiny dimpled (red sight)" = "7"
        "Black Hexagons"       = "8"
        "Spraypaint"                   = "9"
    }

    $SlideColorMap = @{
        "black"                        = "0"
        "silver matt"                  = "1"
        "silver chrome"                = "2"
        "gold matador"                 = "3"
        "gold"                         = "4"
        "silver shiny kimber"          = "5"
        "chrome arrows"                = "6"
        "silver shiny dimpled"         = "7"
        "silver shiny"                 = "1"
        "black kimber big hitman insignia" = "0"
        "hexagons"                     = "1"
        "steel floral"                 = "2"
        "cherry floral"                = "3"
        ""                             = "0"
    }

        $GripMap = @{
        "Standard"       = "0"
        "Wood"           = "1"
        "Wood full ergo" = "2"
        "Black"          = "3"
        "Spraypaint"     = "5"
    }

    $GripColorMap = @{
        "black rubber fish scales" = "0"
        "black plastic"            = "1"
        "white skull"              = "2"
        "white snake"              = "3"
        "red"                      = "4"
        "grey rubber squares"      = "5"
        "metal blue striped"       = "6"
        "metal blue dimpled"       = "7"
        "orange ducky"             = "8"
        "orange brown"             = "0"
        "light brown"              = "1"
        "cherry brown"             = "2"
        "black snake"              = "4"
        "brown floral"             = "5"
        "cherry pink floral"       = "6"
        "black snake skin"         = "0"
        "black"                    = "1"
        ""                         = "0"
    }

    $GripCoverMap = @{
        "No gripcover"  = "0"
        "Leathercover"  = "1"
    }

    $GripCoverColorMap = @{
        "black (silver circle, black screw)"   = "0"
        "black (red circle)"                   = "1"
        "black (black circle, white screw)"  = "2"
        "black matt (silver circle, black screw)"                           = "3"
        "black big insignia"                   = "4"

    }

    $GripSafetyMap = @{
    "small" = "0"
    "big"   = "1"
    }

    $GripSafetyColorMap = @{
        "black"      = "0"
        "chrome"     = "1"
        "silver matt"= "2"
        "gold"       = "3"
        "black blue" = "4"
    }

    $MagazineMap = @{
        "short"              = "0"
        "short 1911 standard"= "1"
        "long 1911"               = "2"
        "chrome extended"          = "3"
    }

    $MagazineColorMap = @{
        "black"      = "0"
        "chrome"     = "1"
        "silver matt"= "2"
        "gold"       = "3"
        "black blue" = "4"
        "black hexagons" = "3"
    }

    # === Mapping: Muzzle Extension ===
    $MuzzleExtensionMap = @{
        "No extension"                         = "0"
        "Muzzle brake"                         = "1"
        "Striker compensator"                  = "2"
        "Round Suppressor"                     = "3"
        "Short round Suppressor"               = "4"
        "Rus Suppressor"                       = "5"
        "Square suppressor"                    = "7"
        "Striker compensator 2 (more holes)"   = "8"
        "Spray paint can"                      = "9"
        "Round suppressor ducky"               = "10"
        "Spray paint can yellow"               = "11"
    }

    # === Mapping: Muzzle Extension Colors ===
    $MuzzleExtensionColorMap = @{
        # Striker compensator
        "chrome"         = "0"
        "Silver shiny"   = "1"

        # Round Suppressor
        "black (white text)" = "0"
        "silver chrome"      = "1"
        "black (black text)" = "2"
        "gold"               = "3"
        "black floral"       = "4"
        "cherry floral"      = "5"

        # Striker compensator 2
        "chrome "       = "0"
        "Silver matt"   = "1"
    }
    
    # === Mapping: Gun Sound Perk ===
    $SoundMap = @{
        "loud"                         = ''
        "suppressed"                   = '"suppressor",'

    }

    # === Mapping: SoundStyle ===
    $SoundStyleMap = @{
        "ICA19 FA" =@{
        Soundstyle = "ICA19 FA"
        AudioHeadType = "eWBC_AudioHeadTailType_Normal"
        AudioTailType = "eWBC_AudioHeadTailType_Silenced"
        AudioWeaponFamily = "eWBC_AudioFamily_Light"
        } 
        "Classicballer" =@{
        Soundstyle = "Classicballer"
        AudioHeadType = "eWBC_AudioHeadTailType_Normal"
        AudioTailType = "eWBC_AudioHeadTailType_Normal"
        AudioWeaponFamily = "eWBC_AudioFamily_Heavy"
        }
        "Striker" =@{
        Soundstyle = "Striker"
        AudioHeadType = "eWBC_AudioHeadTailType_SilencedSweetener"
        AudioTailType = "eWBC_AudioHeadTailType_DryFire"
        AudioWeaponFamily = "eWBC_AudioFamily_Heavy"
        }
        "suppressed" =@{
        Soundstyle = "suppressed"
        AudioHeadType = "eWBC_AudioHeadTailType_Silenced"
        AudioTailType = "eWBC_AudioHeadTailType_Silenced"
        AudioWeaponFamily = "eWBC_AudioFamily_Heavy"
        }
    }
    
    #Mapping Scope
    $ScopeMap = @{
        "No scope" = "0"
        "Holo"     = "1"
        "Aimpoint" = "2"
        "Reflex"   = "3"
        "Reflex 2" = "4"
        "Scope 5"  = "5"
    }

    $ScopeColorMap = @{
        "green"   = "0"
        "red"     = "1"
        "Color 2" = "2"
        "Color 3" = "3"
        "Color 4" = "4"
    }

    # === Mapping: Fire mode Applied modifiers ===
    $FireModeMap = @{
        "single fire" =@{
        fullauto = ""
        firemode = ""
        } 
        "full auto" =@{
        fullauto = '"fullauto",'
        firemode = '"1761542f-d967-417c-8902-4853583acbd1",'
        }
    }



    # --- Variablen setzen ---
    #Weapon Replace
    #Alter Code: Invoke-Expression ('$global:Weapon = ' + $WeaponMap[$cmbWeapon.SelectedItem])
    #Neuer Code:
    $selectedWeapon = $cmbWeapon.SelectedItem
    $entry = $WeaponMap[$selectedWeapon]

    # Weapon-Code setzen
    $global:Weapon = $entry.Code

    # Localizations setzen
    $global:localizationWeaponhsh = $entry.LocalizationWeaponHSH
    $global:localizationTitleHSH = $entry.LocalizationTitleHSH
    $global:LocalizationDesc = $entry.LocalizationDesc

    #replaced weapon setzen
    $global:replace = $entry.Replace


    #New Customballer Name
    $global:customname = $txtCustomName.Text
    
    #Barrel
    $global:Barrel = $BarrelMap[$cmbBarrel.SelectedItem]
    #Barrelcolor
    $global:BarrelColor = $BarrelColorMap[$cmbBarrelColor.SelectedItem]
    
    #Frame
    $global:Frame = $FrameMap[$cmbFrame.SelectedItem]
    #Framecolor
    if ($cmbFrameColor.Enabled) {
        $global:FrameColor = $FrameColorMap[$cmbFrameColor.SelectedItem]
    } else {
        #Framecolor: Wenn nicht wählbar, automatisch "0" setzen
        $global:FrameColor = "0"
    }
    #Hammer
    $global:Hammer = $HammerMap[$cmbHammer.SelectedItem]
    #Hammercolor
    if ($cmbHammerColor.Enabled) {
         $global:HammerColor = $HammerColorMap[$cmbHammerColor.SelectedItem]
    } else {
        #Hammercolor: wenn nicht wählbar, automatisch "0" setzen
        $global:HammerColor = "0"
    }

    #Trigger
    if ($cmbTrigger.Enabled) {
        $global:Trigger = $TriggerMap[$cmbTrigger.SelectedItem]
    } else {
        #wenn nicht wählbar, automatisch "-1" setzen
        $global:Trigger = "-1"
    }
    #Triggercolor
    if ($cmbTriggercolor.Enabled) {
        $global:TriggerColor = $TriggerColorMap[$cmbTriggerColor.SelectedItem]
    } else {
        #wenn nicht wählbar, automatisch "0" setzen
        $global:TriggerColor = "0"
    }
    #Slide
    if ($cmbSlide.Enabled) {
        $global:Slide = $SlideMap[$cmbSlide.SelectedItem]
    } else {
        #wenn nicht wählbar, automatisch "-1" setzen
        $global:Slide = "-1"
    }
    #Slidecolor
    if ($cmbSlideColor.Enabled) {
        $global:SlideColor = $SlideColorMap[$cmbSlideColor.SelectedItem]
    }else {
    # wenn nicht wählbar, automatisch "0" setzen
    $global:SlideColor = "0"
    }

    #Grip
    if ($cmbGrip.Enabled) {
    $global:Grip = $GripMap[$cmbGrip.SelectedItem]
    } else {
        #wenn nicht wählbar, automatisch "-1" setzen
        $global:Grip = "-1"
    }
    #Gripcolor
    if ($cmbGripColor.Enabled) {
        $global:GripColor = $GripColorMap[$cmbGripColor.SelectedItem]
    } else {
        $global:GripColor = "0"
    }
    #Gripcover
    if ($cmbGripCover.Enabled) {
        $global:GripCover = $GripCoverMap[$cmbGripCover.SelectedItem]
    } else {
        $global:GripCover = "0"
    }
    #Gripcovercolor
    if ($cmbGripCoverColor.Enabled) {
        $global:GripCoverColor = $GripCoverColorMap[$cmbGripCoverColor.SelectedItem]
    } else {
        $global:GripCoverColor = "0"
    }
    #Gripsafety & color
    $global:GripSafety = $GripSafetyMap[$cmbGripSafety.SelectedItem]
    $global:GripSafetyColor = $GripSafetyColorMap[$cmbGripSafetyColor.SelectedItem]
    
    #Magazine
    $global:Magazine = $MagazineMap[$cmbMagazine.SelectedItem]
    #Magazine color
    if ($cmbMagazineColor.Enabled) {
    $global:MagazineColor = $MagazineColorMap[$cmbMagazineColor.SelectedItem]
    } else {
        $global:MagazineColor = "0"
    #Magazine apllied modifier
    }
    if ($cmbMagazine.SelectedItem -eq "long 1911") { 
        $global:MagazineBullets = '"33649882-efae-40f5-a57b-2380794038ca",'
    }
    if ($cmbMagazine.SelectedItem -eq "chrome extended") { 
        $global:MagazineBullets = '"ed35305b-1d03-42f9-9e5f-e246d85fcab6",'
    } 
    if ($cmbMagazine.SelectedItem -like "*short*") { 
        $global:MagazineBullets = ""
    }
        
        

    #Muzzle Extension 
    if ($cmbMuzzleExtension.SelectedItem) {
        $global:MuzzleExtension = $MuzzleExtensionMap[$cmbMuzzleExtension.SelectedItem]
     }else {
    # wenn nicht wählbar, automatisch "0" setzen
    $global:MuzzleExtension = "0"
    }

    #Muzzle Extension Color
    if ($cmbMuzzleExtensionColor.Enabled -and $cmbMuzzleExtensionColor.SelectedItem) {
        $global:MuzzleExtensionColor = $MuzzleExtensionColorMap[$cmbMuzzleExtensionColor.SelectedItem]
    } else {
        $global:MuzzleExtensionColor = "0"  # Default-Wert falls keine Farbauswahl sichtbar
    }

    #Gun Sound Perk
    if ($cmbSound.SelectedItem) {
        $global:Sound = $SoundMap[$cmbSound.SelectedItem]
    } else {
        $global:Sound = '"suppressor",'
    }
    if ($global:Sound -eq '"suppressor",') {
        $global:SoundModifier = '"470304c8-0fda-4706-9a61-5f01890f2843",'
    } else {
        $global:SoundModifier = ""
    }

    #Gun Soundstyle
    if ($cmbSoundStyle.Enabled -and $cmbSoundStyle.SelectedItem) {
    $selectedSoundStyle = $cmbSoundStyle.SelectedItem
    } else {
    # Combobox deaktiviert -> automatisch suppressed
    $selectedSoundStyle = "suppressed"
    }
    #$SoundStyleMap[$selectedSoundStyle]
    $global:SoundStyle = $SoundStyleMap[$selectedSoundStyle].Soundstyle
    $global:AudioHeadType = $SoundStyleMap[$selectedSoundStyle].AudioHeadType
    $global:AudioTailType = $SoundStyleMap[$selectedSoundStyle].AudioTailType
    if ($cmbFireMode.SelectedItem -eq "full auto"){
        $global:AudioWeaponFamily =  "eWBC_AudioFamily_Light"
    } else {   
        $global:AudioWeaponFamily = $SoundStyleMap[$selectedSoundStyle].AudioWeaponFamily
    }



        # Scope
    if ($cmbScope.SelectedItem) {
        $global:Scope = $ScopeMap[$cmbScope.SelectedItem]

        if ($cmbScope.SelectedItem -eq "No scope") {
            $global:rail = "0"
        } else {
            $global:rail = "1"
        }
    }

    # Scope Color
    if ($cmbScopeColor.Enabled -and $cmbScopeColor.SelectedItem) {
        $global:ScopeColor = $ScopeColorMap[$cmbScopeColor.SelectedItem]
    } else {
        $global:ScopeColor = "0"
    }

    #Fire mode Appliedmodifiers & Perk 
    $selectedFireMode = $cmbFireMode.SelectedItem

    $global:FireMode = $FireModeMap[$selectedFireMode].firemode
    $global:FullAuto = $FireModeMap[$selectedFireMode].fullauto
    


    #Icon
        #ICA19 F/A Stealth
    if ($cmbMuzzleExtension.SelectedItem -like "*suppressor*" -and ($cmbMagazine.SelectedItem -like "*long*" -or $cmbMagazine.SelectedItem -like "*extended*")) {
        $global:Icon = "7095748747080151"
    }
        #Silverballer
    if ($cmbMuzzleExtension.SelectedItem -like "*suppressor*" -and $cmbMagazine.SelectedItem -like "*short*") {
        $global:Icon = "71067511183484367"
    }
     #ICA 19
    if ($cmbMuzzleExtension.SelectedItem -like "*suppressor*" -and $cmbMagazine.SelectedItem -like "*short*" -and $cmbGripCover.SelectedItem -eq "no gripcover") {
        $global:Icon = "4141865262312528"
    }
        #Shortballer
    if ($cmbMuzzleExtension.SelectedItem -eq "short round suppressor" -and $cmbMagazine.SelectedItem -like "*short*") {
        $global:Icon = "64511491488113169"
    }
        #Black Lilly V3
    if ($cmbMuzzleExtension.SelectedItem -eq "square suppressor" -and $cmbMagazine.SelectedItem -like "*short*") {
        $global:Icon = "33548860454932567"
    }
        #Striker V3
    if ($cmbMuzzleExtension.SelectedItem -like "*compensator*" -and ($cmbMagazine.SelectedItem -like "*long*" -or $cmbMagazine.SelectedItem -like "*extended*")) {
        $global:Icon = "27729699436066054"
    }
        #Striker
    if ($cmbMuzzleExtension.SelectedItem -like "*compensator*" -and $cmbMagazine.SelectedItem -like "*short*") {
        $global:Icon = "12189976785575908"
    }
        #ICA19 F/A
    if (($cmbMuzzleExtension.SelectedItem -eq "no extension" -or -not $cmbMuzzleExtension.Enabled) -and ($cmbMagazine.SelectedItem -like "*long*" -or $cmbMagazine.SelectedItem -like "*extended*")) {
        $global:Icon = "25672887702161340"
    }
        #Classicballer
    if (($cmbMuzzleExtension.SelectedItem -eq "no extension" -or -not $cmbMuzzleExtension.Enabled) -and $cmbMagazine.SelectedItem -like "*short*") {
        $global:Icon = "12901663890188398"
    }

}

# === Generate-Mod-Button ===
$btnGenerate = New-Object System.Windows.Forms.Button
$btnGenerate.Text = "Generate Mod"
$btnGenerate.Location = New-Object System.Drawing.Point(331,$Ylbl)
$btnGenerate.Font = New-Object System.Drawing.Font("Segoe UI", 12)  
#$btnGenerate.Font = New-Object System.Drawing.Font($btnGenerate.Font.FontFamily, 12, $btnGenerate.Font.Style)
$btnGenerate.AutoSize = $true
$btnGenerate.Add_Click({
    # === Eingaben prüfen ===
    $customname = $txtCustomName.Text
    if ([string]::IsNullOrWhiteSpace($customname)) {
        [System.Windows.Forms.MessageBox]::Show("✖ Error: Please enter a new Customballer name.")
        return
    }

    # Prüfen, ob alle sichtbaren & aktivierten Comboboxen eine Auswahl haben
    $allValid = $true
    foreach ($ctrl in $panel.Controls) {
        if ($ctrl -is [System.Windows.Forms.ComboBox] -and $ctrl.Visible -and $ctrl.Enabled) {
            if (-not $ctrl.SelectedItem) {
                $allValid = $false
                break
            }
        }
    }

    if (-not $allValid) {
        [System.Windows.Forms.MessageBox]::Show("✖ Error: Please select a value in all active dropdown lists.")
        return
    }

        # === Variablen setzen ===
    Set-SelectedVariables

    # === Ordner-Struktur bauen ===
    # === Customname mit Underline erzeugen ===
    $customnameUnderline = $customname -replace '\s','_'
    # $scriptDir wurde oben ermittelt
    $modsDir   = Join-Path $scriptDir "Customballer-Mods"

    if (-not (Test-Path $modsDir)) { New-Item -ItemType Directory -Path $modsDir | Out-Null }

    $baseFolder = Join-Path $modsDir ("{0}_CBG_NOMAECK" -f $customnameUnderline)
    $blobsFolder = Join-Path $baseFolder "blobs\images\unlockables_override"
    $modelFolder = Join-Path $baseFolder ("{0}\Model\chunk0" -f $customnameUnderline)

    New-Item -ItemType Directory -Force -Path $blobsFolder | Out-Null
    New-Item -ItemType Directory -Force -Path $modelFolder | Out-Null

    # Platzhalter-Dateien
    #Manifest.json
    $schema = '$schema'

    # Customname ohne Leerzeichen erzeugen
    $customnameNoSpaces = $customname -replace '\s',''

    
    Set-Content -Path (Join-Path $baseFolder "manifest.json") -Value @"
{
 	"$schema": "https://raw.githubusercontent.com/atampy25/simple-mod-framework/main/Mod%20Manager/src/lib/manifest-schema.json",	
	"id": "${customnameNoSpaces}.CBG_NOMAECK",
	"name": "${customnameUnderline}_CBG_NOMAECK",
	"description": "User self created Customballer that replaces $replace, created with NOMAECK's Customballer Gunsmith",
	"authors": ["NOMAECK"],
	"frameworkVersion": "2.33.27",
	"version": "1.0.0",
	"blobsFolders": ["blobs"],
	"thumbs": ["ConsoleCmd OnlineResources_Disable 1"],
	"options":[
		{
			"group": "$customnameUnderline",
			"name": "$customname",
			"type": "checkbox",
			"enabledByDefault": true,
			"image": "blobs/images/unlockables_override/Customballer.jpg",
			"contentFolders": ["$customnameUnderline/Model"],
			"localisationOverrides": {
			"$localizationWeaponhsh": {
			"english": {"$localizationTitleHSH": "$customname", "$LocalizationDesc": "Tactical custom pistol, created with NOMAECK's Customballer Gunsmith"},
			"french": {"$localizationTitleHSH": "$customname", "$LocalizationDesc": "Pistolet tactique personnalisé, créé avec le Customballer Gunsmith de NOMAECK"},
			"italian": {"$localizationTitleHSH": "$customname", "$LocalizationDesc": "Pistola tattica personalizzata, creata con Customballer Gunsmith di NOMAECK"},
			"german": {"$localizationTitleHSH": "$customname", "$LocalizationDesc": "Taktische Custom-Pistole, erstellt mit NOMAECKs Customballer Gunsmith"},
			"spanish": {"$localizationTitleHSH": "$customname", "$LocalizationDesc": "Pistola táctica personalizada, creada con Customballer Gunsmith de NOMAECK"},
			"russian": {"$localizationTitleHSH": "$customname", "$LocalizationDesc": "Tactical custom pistol, created with NOMAECK's Customballer Gunsmith"},
			"chineseSimplified": {"$localizationTitleHSH": "$customname", "$LocalizationDesc": "Tactical custom pistol, created with NOMAECK's Customballer Gunsmith"},
			"chineseTraditional": {"$localizationTitleHSH": "$customname", "$LocalizationDesc": "Tactical custom pistol, created with NOMAECK's Customballer Gunsmith"},
			"japanese": {"$localizationTitleHSH": "$customname", "$LocalizationDesc": "Tactical custom pistol, created with NOMAECK's Customballer Gunsmith"}
					}
				}
		}
        ]
}
"@
    
    #Project.json
    Set-Content -Path (Join-Path $baseFolder "project.json") -Value @"
{
    "customPaths": []
}
"@


    Set-Content -Path (Join-Path $modelFolder ("{0}.repository.json" -f $customnameUnderline)) -Value @"
{
    "$Weapon":{
        "AppliedModifiers":[
            $FireMode
            $MagazineBullets
            $SoundModifier
            "6e197137-e6d3-44c7-bf19-8d59094312f6"
        ],        
	    "Image":"images/unlockables_override/Customballer.jpg",
	    "ModelBodyPartSelections":[$Barrel, $Grip, $Gripcover, $Magazine, $Hammer, $Frame, $Gripsafety, $Rail, $Slide, $Trigger],
	    "ModelSkinSelections":[$Barrelcolor, $Gripcolor, $Gripcovercolor, $Magazinecolor, $Hammercolor, $Framecolor, $Gripsafetycolor, 0, $Slidecolor, $Triggercolor, 0],
	    "ModelMuzzleExtensionSelection":$Muzzleextension,
	    "ModelMuzzleExtensionSkinSelection":$Muzzleextensioncolor,
	    "ModelScopeSelection":$Scope,
	    "ModelScopeSkinSelection":$Scopecolor,
        "Perks": [
		        $FullAuto
		        $Sound
		        "steadyaim"
	    ],
        "AudioHeadType": "$AudioHeadType",
        "AudioTailType": "$AudioTailType",
        "AudioWeaponFamily": "$AudioWeaponFamily",
        "HudIcon": "$Icon"
	}
}
"@

    # Bild kopieren
    $sourceImage = Join-Path $scriptDir "images\customballer.jpg"
    $destImage   = Join-Path $blobsFolder "customballer.jpg"
    if (Test-Path $sourceImage) { Copy-Item -Path $sourceImage -Destination $destImage -Force }
    if (-not (Test-Path $sourceImage)) {[System.Windows.Forms.MessageBox]::Show("You deleted Customballer.jpg from Customballer_Gunsmith\images folder. Do not delete Customballer Gunsmith files! Restore the files, otherwise your Customballer mods will not work fully!")
    }

    # === ZIP erstellen ===
    $zipPath = Join-Path $modsDir ("{0}_CBG_NOMAECK.zip" -f $customnameUnderline)
    if (Test-Path $zipPath) { Remove-Item $zipPath -Force }
    Compress-Archive -Path $baseFolder -DestinationPath $zipPath

    # === Ordner nach dem Packen löschen ===
if (Test-Path $baseFolder) {
   Remove-Item $baseFolder -Recurse -Force
}

    [System.Windows.Forms.MessageBox]::Show("✔ Mod created successfully:
    `n$zipPath")

# === Ordner im Explorer öffnen ===
$zipFolder = Split-Path $zipPath -Parent

# COM-Objekt holen
$shell = New-Object -ComObject Shell.Application
$alreadyOpen = $false

foreach ($window in $shell.Windows()) {
    try {
        if ($window.FullName -like "*explorer.exe" -and 
            $window.Document.Folder.Self.Path -eq $zipFolder) {
            $alreadyOpen = $true
            break
        }
    } catch {
        # Ignorieren: Nicht alle Fenster haben Document.Folder
    }
}

if (-not $alreadyOpen) {
    Start-Process explorer.exe -ArgumentList $zipFolder
}


})
$panel.Controls.Add($btnGenerate)






# === Test-Button ===
$btnTest = New-Object System.Windows.Forms.Button
$btnTest.Text = "Test"
$btnTest.Location = New-Object System.Drawing.Point($X1lbl,($Ylbl+3))
$btnTest.Add_Click({
    Set-SelectedVariables
    # --- Testausgabe ---
    [System.Windows.Forms.MessageBox]::Show(
    "Weapon: $Weapon`nCustom Name: $Customname`nBarrel: $Barrel`nBarrel Color: $BarrelColor`nFrame: $Frame`nFrame Color: $FrameColor`nHammer: $Hammer`nHammer Color: $HammerColor`nTrigger: $Trigger`nTrigger Color: $TriggerColor`nSlide: $Slide`nSlide Color: $SlideColor`nGrip: $Grip`nGrip Color: $GripColor`nGrip Cover: $GripCover`nGrip Cover Color: $GripCoverColor`nGrip Safety: $GripSafety`nGrip Safety Color: $GripSafetyColor`nMagazine: $Magazine`nMagazine Color: $MagazineColor`nMagazine Bullets: $MagazineBullets`nMuzzle Extension: $MuzzleExtension`nMuzzle Extension Color: $MuzzleExtensionColor`nScope: $Scope`nScope Color: $ScopeColor`nRail: $rail`nSound: $Sound`nSoundstyle: $SoundStyle`nAudioHeadType: $AudioHeadType`nAudioTailType: $AudioTailType`nAudioWeaponFamily: $AudioWeaponFamily`nSound Modifier: $SoundModifier`nFull Auto: $FullAuto`nFire Mode applied modifier: $FireMode`nIcon: $Icon",
    "Auswahlübersicht"
)

})
#$panel.Controls.Add($btnTest)

$Yline += $Yplus
$Ylbl += $Yplus
$Ycmb += $Yplus

# === Donation ===
$panelLabelDonation = New-Object System.Windows.Forms.Panel
$panelLabelDonation.Location = New-Object System.Drawing.Point(($X1lbl),$Ylbl)
$panelLabelDonation.Size = New-Object System.Drawing.Size($linewidth,65)
$panelLabelDonation.BorderStyle = "FixedSingle"   # Rahmen sichtbar machen
$panelLabelDonation.BackColor = [System.Drawing.Color]::White
$panel.Controls.Add($panelLabelDonation)

$lblDonation = New-Object System.Windows.Forms.Label
$lblDonation.Text = "You’re not a fan of unpaid work? Then support my amazing tool — buy me a coffee! :)"
$lblDonation.AutoSize = $true
$lblDonation.Location = New-Object System.Drawing.Point(155,15)
$panelLabelDonation.Controls.Add($lblDonation)

# LinkLabel
$linkLabel = New-Object System.Windows.Forms.LinkLabel
$linkLabel.Text = "https://buymeacoffee.com/nomaeck"
$linkLabel.Location = New-Object System.Drawing.Point(273,35)
$linkLabel.AutoSize = $true
$linkLabel.Links[0].LinkData = "https://buymeacoffee.com/nomaeck"
# Event hinzufügen, damit der Browser geöffnet wird
$linkLabel.Add_LinkClicked({
    param($sender, $e)
    Start-Process $e.Link.LinkData
})
$panelLabelDonation.Controls.Add($linkLabel)

# === Show Form ===
[void]$form.ShowDialog()

