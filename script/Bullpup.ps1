# === Scrollbares Panel ===
$panel1 = New-Object System.Windows.Forms.Panel
$panel1.Dock = "Fill"          # Füllt das Fenster aus
$panel1.AutoScroll = $true     # Scrollbalken aktivieren
#$panel.BackColor = [System.Drawing.Color]::LightYellow

# Panel MouseMove Event
$panel1.Add_MouseMove({
    param($sender, $e)
    
    $found1 = $false
    
    # Alle Controls im Panel durchsuchen
    foreach ($ctrl1 in $panel1.Controls) {
        if ($ctrl1 -is [System.Windows.Forms.ComboBox] -and -not $ctrl1.Enabled) {
            # Prüfen, ob Maus über ComboBox ist
            if ($ctrl1.Bounds.Contains($e.Location)) {
                $toolTip.SetToolTip($panel1, "Not available for your selected gun parts.")
                $found = $true
                break
            }
        }
    }


    # Wenn keine gesperrte ComboBox unter der Maus, Tooltip entfernen
    if (-not $found) {
        $toolTip.SetToolTip($panel1, "")
    }
})

# === Positions Variabeln ===
$X1lbl = 30  #Bauteil-Label X Start Position
$X2lbl = 420 #Bauteil-Color-Label X Start Position
$X1cmb = 200 #Bauteil-Combobox X Start Position = Dropdown
$X2cmb = 565 #Bauteil-Color-Combobox X Start Position = Dropdown
$Xcmbsize = 190 #Combobox X Größe
$Ycmbsize = 30  #Combobox Y Größe
$lineheight = 2 #Trennlinien Höhe
$linewidth = 725 #Trennlinien Breite
$Yline = 50 #Erste Trennlinien Y Startposition
$Ylbl = 18 #Erste Label Y Startposition
$Ycmb = 15 #Erste Combobox Y Startposition
$Yplus = 50 #50 Pixel

#Trennlinie 0
$line0 = New-Object System.Windows.Forms.Label
$line0.BorderStyle = "Fixed3D"
$line0.AutoSize = $false
$line0.Height = $lineheight
$line0.Width = 782
$line0.Location = New-Object System.Drawing.Point(2,0)
$panel1.Controls.Add($line0)

# === 1. Weapon1 to replace1 ===
$lblWeapon1 = New-Object System.Windows.Forms.Label
$lblWeapon1.Text = "Weapon to replace:"
$lblWeapon1.Location = New-Object System.Drawing.Point($x1lbl,$Ylbl)
$lblWeapon1.AutoSize = $true
$panel1.Controls.Add($lblWeapon1)

$cmbWeapon1 = New-Object System.Windows.Forms.ComboBox
$cmbWeapon1.Location = New-Object System.Drawing.Point($x1cmb,$Ycmb)
$cmbWeapon1.Size = New-Object System.Drawing.Size($xcmbsize, $ycmbsize)
$cmbWeapon1.DropDownStyle = "DropDownList"
$cmbWeapon1.DropDownHeight = "600"
$cmbWeapon1.Items.AddRange(@(
    "Sieger 300",
    "Sieger 300 Ghost",
    "Sieger 300 Viper",
    "Sieger 300 Tactical",
    "Sieger 300 Advanced",
    "Sieger 300 White Ruby Rude",
    "Sieger 300 Concrete",
    "Sieger 300 Ornamental",
    "Sieger 300 Arctic",
    "Hackl Leviathan",
    "Hackl Leviathan Ducky"

))
$panel1.Controls.Add($cmbWeapon1)

# === 1.1 New Custom-Baller Name ===
$lblCustomName1 = New-Object System.Windows.Forms.Label
$lblCustomName1.Text = "New bullpup sniper name:"
$lblCustomName1.Location = New-Object System.Drawing.Point($x2lbl,$Ylbl)
$lblCustomName1.AutoSize = $true
$panel1.Controls.Add($lblCustomName1)


$txtCustomName1 = New-Object System.Windows.Forms.TextBox
$txtCustomName1.Location = New-Object System.Drawing.Point($x2cmb,$Ycmb)
$txtCustomName1.Size = New-Object System.Drawing.Size($xcmbsize, $ycmbsize)
$txtCustomName1.MaxLength = 20

# Eingabe prüfen
$txtCustomName1.Add_KeyPress({
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

$panel1.Controls.Add($txtCustomName1)

#Trennlinie 1
$line1 = New-Object System.Windows.Forms.Label
$line1.BorderStyle = "Fixed3D"
$line1.AutoSize = $false
$line1.Height = $lineheight
$line1.Width = $linewidth
$line1.Location = New-Object System.Drawing.Point($x1lbl,$Yline)
$panel1.Controls.Add($line1)
$Yline += $Yplus
$Ylbl += $Yplus
$Ycmb += $Yplus

# === 3. Frame1 ===
$lblFrame1 = New-Object System.Windows.Forms.Label
$lblFrame1.Text = "Choose a receiver:"
$lblFrame1.Location = New-Object System.Drawing.Point($x1lbl,$Ylbl)
$lblFrame1.AutoSize = $true
$panel1.Controls.Add($lblFrame1)

$cmbFrame1 = New-Object System.Windows.Forms.ComboBox
$cmbFrame1.Location = New-Object System.Drawing.Point($x1cmb,$Ycmb)
$cmbFrame1.Size = New-Object System.Drawing.Size($xcmbsize, $ycmbsize)
$cmbFrame1.DropDownStyle = "DropDownList"
$cmbFrame1.DropDownHeight = "600"
$cmbFrame1.Items.AddRange(@(
    "Sieger 300",
    "Sieger 300 Arctic Wrapped",
    "Leviathan Muzzlebrake",
    "Leviathan Big Muzzlebrake"
    "Leviathan Suppressor",
    "Leviathan Suppressor Ducky"
))
$panel1.Controls.Add($cmbFrame1)

# === 3.1 Frame1 Color ===
$lblFrameColor1 = New-Object System.Windows.Forms.Label
$lblFrameColor1.Text = "Receiver color:"
$lblFrameColor1.Location = New-Object System.Drawing.Point($x2lbl,$Ylbl)
$lblFrameColor1.AutoSize = $true
$lblFrameColor1.Enabled = $false
$panel1.Controls.Add($lblFrameColor1)

$cmbFrameColor1 = New-Object System.Windows.Forms.ComboBox
$cmbFrameColor1.Location = New-Object System.Drawing.Point($x2cmb,$Ycmb)
$cmbFrameColor1.Size = New-Object System.Drawing.Size($xcmbsize, $ycmbsize)
$cmbFrameColor1.DropDownStyle = "DropDownList"
$cmbFrameColor1.DropDownHeight = "600"
$cmbFrameColor1.Enabled = $false
$panel1.Controls.Add($cmbFrameColor1)

# --- 3.2 Fragezeichen-Button ---
$btnFrameHelp1 = New-Object System.Windows.Forms.Button
$btnFrameHelp1.Text = "?"
$btnFrameHelp1.Width = 18
$btnFrameHelp1.Height = 17
$btnFrameHelp1.Location = New-Object System.Drawing.Point(($x2cmb + $xcmbsize + 1), ($Ycmb+2))
$btnFrameHelp1.Tag = "$scriptdir\images\bullpup\receiver"
$panel1.Controls.Add($btnFrameHelp1)


#Trennlinie 3
$line3 = New-Object System.Windows.Forms.Label
$line3.BorderStyle = "Fixed3D"
$line3.AutoSize = $false
$line3.Height = $lineheight
$line3.Width = $linewidth
$line3.Location = New-Object System.Drawing.Point($x1lbl,$Yline)
$panel1.Controls.Add($line3)
$Yline += $Yplus
$Ylbl += $Yplus
$Ycmb += $Yplus

# === 11. muzzle extension ===
$lblMuzzleExtension1 = New-Object System.Windows.Forms.Label
$lblMuzzleExtension1.Text = "Choose a muzzle extension:"
$lblMuzzleExtension1.Location = New-Object System.Drawing.Point($x1lbl,$Ylbl)
$lblMuzzleExtension1.AutoSize = $true
$lblMuzzleExtension1.Enabled = $false
$panel1.Controls.Add($lblMuzzleExtension1)

$cmbMuzzleExtension1 = New-Object System.Windows.Forms.ComboBox
$cmbMuzzleExtension1.Location = New-Object System.Drawing.Point($x1cmb,$Ycmb)
$cmbMuzzleExtension1.Size = New-Object System.Drawing.Size($xcmbsize, $ycmbsize)
$cmbMuzzleExtension1.DropDownStyle = "DropDownList"
$cmbMuzzleExtension1.DropDownHeight = "600"
$cmbMuzzleExtension1.Enabled = $false
$cmbMuzzleExtension1.Items.AddRange(@(
    "No extension",
    "Muzzle brake",
    "Suppressor long",
    "Suppressor short",
    "Suppressor long octagon",
    "Suppressor long dimpled grey",
    "Suppressor long wrapped arctic"    
))
$panel1.Controls.Add($cmbMuzzleExtension1)

# === 11.x muzzle extension color (dynamisch sichtbar) ===
$lblMuzzleExtensionColor1 = New-Object System.Windows.Forms.Label
$lblMuzzleExtensionColor1.Text = "Muzzle extension color:"
$lblMuzzleExtensionColor1.Location = New-Object System.Drawing.Point($x2lbl,$Ylbl)
$lblMuzzleExtensionColor1.AutoSize = $true
$lblMuzzleExtensionColor1.Enabled = $false
$panel1.Controls.Add($lblMuzzleExtensionColor1)

$cmbMuzzleExtensionColor1 = New-Object System.Windows.Forms.ComboBox
$cmbMuzzleExtensionColor1.Location = New-Object System.Drawing.Point($x2cmb,$Ycmb)
$cmbMuzzleExtensionColor1.Size = New-Object System.Drawing.Size($xcmbsize, $ycmbsize)
$cmbMuzzleExtensionColor1.DropDownStyle = "DropDownList"
$cmbMuzzleExtensionColor1.DropDownHeight = "600"
$cmbMuzzleExtensionColor1.Enabled = $false
$panel1.Controls.Add($cmbMuzzleExtensionColor1)

$btnMuzzleHelp1 = New-Object System.Windows.Forms.Button
$btnMuzzleHelp1.Text = "?"
$btnMuzzleHelp1.Width = 18
$btnMuzzleHelp1.Height = 17
$btnMuzzleHelp1.Location = New-Object System.Drawing.Point(($x2cmb + $xcmbsize + 1), ($Ycmb+2))
$btnMuzzleHelp1.Tag = "$scriptdir\images\bullpup\muzzleextensions"
$panel1.Controls.Add($btnMuzzleHelp1)

#Trennlinie 11
$line11 = New-Object System.Windows.Forms.Label
$line11.BorderStyle = "Fixed3D"
$line11.AutoSize = $false
$line11.Height = $lineheight
$line11.Width = $linewidth
$line11.Location = New-Object System.Drawing.Point($x1lbl,$Yline)
$panel1.Controls.Add($line11)
$Yline += $Yplus
$Ylbl += $Yplus
$Ycmb += $Yplus

# === 12. Gun Sound ===
$lblSound1 = New-Object System.Windows.Forms.Label
$lblSound1.Text = "Choose a gun sound:"
$lblSound1.Location = New-Object System.Drawing.Point($x1lbl,$Ylbl)
$lblSound1.AutoSize = $true
#$lblSound1.Enabled = $false
$panel1.Controls.Add($lblSound1)

$cmbSound1 = New-Object System.Windows.Forms.ComboBox
$cmbSound1.Location = New-Object System.Drawing.Point($x1cmb,$Ycmb)
$cmbSound1.Size = New-Object System.Drawing.Size($xcmbsize, $ycmbsize)
$cmbSound1.DropDownStyle = "DropDownList"
$cmbSound1.DropDownHeight = "600"
#$cmbSound1.Enabled = $false
$cmbSound1.Items.AddRange(@(
    "loud",
    "suppressed"
))
$panel1.Controls.Add($cmbSound1)

# === 12.x Sound Style ===
$lblSoundStyle1 = New-Object System.Windows.Forms.Label
$lblSoundStyle1.Text = "Sound style:"
$lblSoundStyle1.Location = New-Object System.Drawing.Point($x2lbl,$Ylbl)
$lblSoundStyle1.AutoSize = $true
#$lblSoundStyle1.Enabled = $false
$panel1.Controls.Add($lblSoundStyle1)

$cmbSoundStyle1 = New-Object System.Windows.Forms.ComboBox
$cmbSoundStyle1.Location = New-Object System.Drawing.Point($x2cmb,$Ycmb)
$cmbSoundStyle1.Size = New-Object System.Drawing.Size($xcmbsize, $ycmbsize)
$cmbSoundStyle1.DropDownStyle = "DropDownList"
$cmbSoundStyle1.DropDownHeight = "600"
#$cmbSoundStyle1.Enabled = $false
$cmbSoundStyle1.Items.AddRange(@(
    "light",
    "standard",
    "heavy"
))
$panel1.Controls.Add($cmbSoundStyle1)

#Trennlinie 12
$line12 = New-Object System.Windows.Forms.Label
$line12.BorderStyle = "Fixed3D"
$line12.AutoSize = $false
$line12.Height = $lineheight
$line12.Width = $linewidth
$line12.Location = New-Object System.Drawing.Point($x1lbl,$Yline)
$panel1.Controls.Add($line12)
$Yline += $Yplus
$Ylbl += $Yplus
$Ycmb += $Yplus

# === 13. Scope ===
$lblScope1 = New-Object System.Windows.Forms.Label
$lblScope1.Text = "Choose a scope:"
$lblScope1.Location = New-Object System.Drawing.Point($x1lbl,$Ylbl)
$lblScope1.AutoSize = $true
$lblScope1.Enabled = $false
$panel1.Controls.Add($lblScope1)

$cmbScope1 = New-Object System.Windows.Forms.ComboBox
$cmbScope1.Location = New-Object System.Drawing.Point($x1cmb,$Ycmb)
$cmbScope1.Size = New-Object System.Drawing.Size($xcmbsize, $ycmbsize)
$cmbScope1.DropDownStyle = "DropDownList"
$cmbScope1.DropDownHeight = "600"
$cmbScope1.Enabled = $false
$panel1.Controls.Add($cmbScope1)

# === 13.1 Scope Color ===
$lblScopeColor1 = New-Object System.Windows.Forms.Label
$lblScopeColor1.Text = "Scope color:"
$lblScopeColor1.Location = New-Object System.Drawing.Point($x2lbl,$Ylbl)
$lblScopeColor1.AutoSize = $true
$lblScopeColor1.Enabled = $false
$panel1.Controls.Add($lblScopeColor1)

$cmbScopeColor1 = New-Object System.Windows.Forms.ComboBox
$cmbScopeColor1.Location = New-Object System.Drawing.Point($x2cmb,$Ycmb)
$cmbScopeColor1.Size = New-Object System.Drawing.Size($xcmbsize, $ycmbsize)
$cmbScopeColor1.DropDownStyle = "DropDownList"
$cmbScopeColor1.DropDownHeight = "600"
$cmbScopeColor1.Enabled = $false
$panel1.Controls.Add($cmbScopeColor1)

# --- 13.2 Scope-Preview ---
$btnScopeHelp1 = New-Object System.Windows.Forms.Button
$btnScopeHelp1.Text = "?"
$btnScopeHelp1.Width = 18
$btnScopeHelp1.Height = 17
$btnScopeHelp1.Location = New-Object System.Drawing.Point(($x2cmb + $xcmbsize + 1), ($Ycmb+2))
$btnScopeHelp1.Tag = "$scriptdir\images\scopes"
$panel1.Controls.Add($btnScopeHelp1)

#Trennlinie 13
$line13 = New-Object System.Windows.Forms.Label
$line13.BorderStyle = "Fixed3D"
$line13.AutoSize = $false
$line13.Height = $lineheight
$line13.Width = $linewidth
$line13.Location = New-Object System.Drawing.Point($x1lbl,$Yline)
$panel1.Controls.Add($line13)
$Yline += $Yplus
$Ylbl += $Yplus
$Ycmb += $Yplus

#Perks
$lblPerks1 = New-Object System.Windows.Forms.Label
$lblPerks1.Text = "Choose some extra perks:"
$lblPerks1.Location = New-Object System.Drawing.Point($x1lbl,$Ylbl)
$lblPerks1.AutoSize = $true
$lblPerks1.Enabled = $true
$panel1.Controls.Add($lblPerks1)

$box1Perks1 = New-Object System.Windows.Forms.CheckBox
$box1Perks1.Text = "Body piercing"
$box1Perks1.Location = New-Object System.Drawing.Point($x1cmb,$Ycmb)
$box1Perks1.AutoSize = $true
$box1Perks1.Checked = $false
$panel1.Controls.Add($box1Perks1)

$box2Perks1 = New-Object System.Windows.Forms.CheckBox
$box2Perks1.Text = "Disable Marksman Time Slowdown"
$box2Perks1.Location = New-Object System.Drawing.Point(($x1cmb+100),$Ycmb)
$box2Perks1.AutoSize = $true
$box2Perks1.Checked = $false
$panel1.Controls.Add($box2Perks1)

#Trennlinie 14
$line14 = New-Object System.Windows.Forms.Label
$line14.BorderStyle = "Fixed3D"
$line14.AutoSize = $false
$line14.Height = $lineheight
$line14.Width = $linewidth
$line14.Location = New-Object System.Drawing.Point($x1lbl,$Yline)
$panel1.Controls.Add($line14)
$Yline += $Yplus
$Ylbl += $Yplus
$Ycmb += $Yplus

# === Logik: Frame1-Auswahl ===
$cmbFrame1.Add_SelectedIndexChanged({
    $cmbScope1.Enabled = $true
    $cmbFrameColor1.Items.Clear()
    $cmbScope1.Items.Clear()
    $cmbScopeColor1.Items.Clear()
# Falls Leviathan gewählt wird folgendes ausblenden:
    if ($cmbFrame1.SelectedItem -like "*Leviathan*") {
        $lblFrameColor1.Enabled = $false
        $cmbFrameColor1.Enabled = $false
        $lblMuzzleExtensionColor1.Enabled = $false
        $cmbMuzzleExtensionColor1.Enabled = $false
        $lblMuzzleExtension1.Enabled = $false
        $cmbMuzzleExtension1.Enabled = $false
        

        # Text/Selection zurücksetzen
        $cmbFrameColor1.SelectedIndex = -1
        $cmbMuzzleExtension1.SelectedIndex = -1
        $cmbMuzzleExtensionColor1.SelectedIndex = -1


        } else {
        # Reaktivieren
        $lblMuzzleExtension1.Enabled = $true
        $cmbMuzzleExtension1.Enabled = $true
        $lblFrameColor1.Enabled = $true
        $cmbFrameColor1.Enabled = $true

        }
        
        switch -Wildcard ($cmbFrame1.SelectedItem) {
        "*Sieger 300*" {
        $cmbScope1.Items.AddRange(@(
                "Sieger 300",
                "Jaeger",
                "Druzhina",
                "Leviathan (gun-part-pack)",
                "Tuatara",
                "Sieger 300 arctic wrapped",
                "Bartoli Flip-Up Caps (gun-part-pack)",
                "Bartoli black silver (gun-part-pack)",
                "Bartoli black gold (gun-part-pack)"
            ))
        }
        
        "*Leviathan*" {
        $cmbScope1.Items.AddRange(@(
                "Sieger 300",
                "Jaeger",
                "Druzhina",
                "Leviathan",
                "Tuatara",
                "Sieger 300 arctic wrapped",
                "Bartoli Flip-Up Caps (gun-part-pack)",
                "Bartoli black silver (gun-part-pack)",
                "Bartoli black gold (gun-part-pack)"
            ))

        }
        default {
            $lblScopeColor1.Enabled = $false
            $cmbScopeColor1.Enabled = $false
            $lblScope1.Enabled = $false
            $cmbScope1.Enabled = $false
        }
        }

        if ($cmbFrame1.SelectedItem -like "*Suppressor*") {
            $lblSound1.Enabled = $false
            $cmbSound1.Enabled = $false


            # Text/Selection zurücksetzen
            $cmbSound1.SelectedIndex = -1
        } else {
            $lblSound1.Enabled = $true
            $cmbSound1.Enabled = $true
        }
         
        
        switch ($cmbFrame1.SelectedItem) {
        "Sieger 300" {
            $cmbFrameColor1.Items.AddRange(@(
                "orange wood",
                "black with squares",
                "black",
                "beige wood",
                "khaki",
                "pink camo",
                "blue camo 1",
                "blue camo 2",
                "blue camo 3",
                "blue camo 4",
                "tan green",
                "arctic camo",
                "red wood",
                "gold",
                "brown wood (needs gun-part-pack)"
            ))
        }
        default {
            $lblFrameColor1.Enabled = $false
            $cmbFrameColor1.Enabled = $false
        }
      }  
})

# === Logik: MuzzleExtension-Auswahl ===
    $cmbMuzzleExtension1.Add_SelectedIndexChanged({
    $lblMuzzleExtensionColor1.Enabled = $true
    $cmbMuzzleExtensionColor1.Enabled = $true
    $cmbMuzzleExtensionColor1.Items.Clear()

    switch ($cmbMuzzleExtension1.SelectedItem) {
        "Suppressor long" {
            $cmbMuzzleExtensionColor1.Items.AddRange(@(
                "black",
                "olive",
                "khaki dimpled",
                "black dimpled",
                #"grey green", -->DLC
                "gold dimpled"
            ))
        }
        "Suppressor long octagon" {
            $cmbMuzzleExtensionColor1.Items.AddRange(@(
                "greyblue",
                "black matt",
                "desert camo",
                "jungle camo",
                "black shiny",
                "gold"
            ))
        }
        
        default {
            $lblMuzzleExtensionColor1.Enabled = $false
            $cmbMuzzleExtensionColor1.Enabled = $false
        }
    }
    # Falls Suppressor gewählt, folgendes ausblenden:
    if ($cmbMuzzleExtension1.SelectedItem -like "*Suppressor long*") {
        $lblSound1.Enabled = $false
        $cmbSound1.Enabled = $false


        # Text/Selection zurücksetzen
        $cmbSound1.SelectedIndex = -1
    }
    else {
        $lblSound1.Enabled = $true
        $cmbSound1.Enabled = $true
    }

})


# === Logik: Scope-Auswahl ===
$cmbScope1.Add_SelectedIndexChanged({
        $lblScopeColor1.Enabled = $true
        $cmbScopeColor1.Enabled = $true
        $cmbScopeColor1.Items.Clear()

    switch ($cmbScope1.SelectedItem) {
        "Sieger 300" {
            $cmbScopeColor1.Items.AddRange(@(
                "black (red reticle)",
                "black (blue reticle)",
                "white",
                "dark green"
            ))
    }

    "Jaeger" {
            $cmbScopeColor1.Items.AddRange(@(
                "grey shiny"
                "dark grey shiny",
                "dark brown",
                "olive",
                "dark grey",
                "black"
            ))
    }

    "Tuatara" {
            $cmbScopeColor1.Items.AddRange(@(
                "grey red",
                "black red",
                "black green"
            ))
    }

    "Druzhina" {
            $cmbScopeColor1.Items.AddRange(@(
                "black",
                "arctic"
            ))
    }
        default {
            $lblScopeColor1.Enabled = $false
            $cmbScopeColor1.Enabled = $false
        }
    }
})






function Set-SelectedVariables_Bullpup {
    # --- Weapon1 Mapping ---
    $WeaponMap1 = @{
        "Sieger 300" =@{
        Code1 = "54bba84c-6751-430e-b47d-e4b5ddf7a835"
        localizationWeaponhsh1 = "0072D1A320470342"
        localizationTitleHSH1 = "2556606083"
        LocalizationDesc1 = "3455345873"
        replace1 = "Sieger 300"
    } 
        "Sieger 300 Ghost" =@{
        Code1 = "f301f605-007c-4fe1-aa99-a8cd2cae033f"
        localizationWeaponhsh1 = "0072D1A320470342"
        localizationTitleHSH1 = "2793243116"
        LocalizationDesc1 = "4092285886"
        replace1 = "Sieger 300 Ghost"
    }
        "Sieger 300 Viper" =@{
        Code1 = "41ac4076-e197-4576-894b-499534fd37e8"
        localizationWeaponhsh1 = "006986A5A3F98191"
        localizationTitleHSH1 = "1435682882"
        LocalizationDesc1 = "268816"
        replace1 = "Sieger 300 Viper"
    }
        "Sieger 300 Tactical" =@{
        Code1 = "7d64d9df-5d30-4e98-9af0-7562ee145d5c"
        localizationWeaponhsh1 = "0072D1A320470342"
        localizationTitleHSH1 = "4277048295"
        LocalizationDesc1 = "2876785077"
        replace1 = "Sieger 300 Tactical"
    }
        "Sieger 300 Advanced" =@{
        Code1 = "907e0277-7806-42a4-b4b2-338cf8dd9391"
        localizationWeaponhsh1 = "0024A5A15AC9CC2F"
        localizationTitleHSH1 = "3635015000"
        LocalizationDesc1 = "2369732362"
        replace1 = "Sieger 300 Advanced"
    }
        "Sieger 300 White Ruby Rude" =@{
        Code1 = "93a95f8a-a1bb-4d6c-bfd5-e6eec4eeaa1e"
        localizationWeaponhsh1 = "006986A5A3F98191"
        localizationTitleHSH1 = "291383916"
        LocalizationDesc1 = "1154021438"
        replace1 = "Sieger 300 White Ruby Rude"
    }
        "Sieger 300 Concrete" =@{
        Code1 = "6e5e27bf-6c27-4785-8cc4-ffebd0ec3494"
        localizationWeaponhsh1 = "006986A5A3F98191"
        localizationTitleHSH1 = "2999686978"
        LocalizationDesc1 = "3881649424"
        replace1 = "Sieger 300 Concrete"
    }
        "Sieger 300 Ornamental" =@{
        Code1 = "2d0393e2-49a8-43c1-b8f3-110e4b0b0c83"
        localizationWeaponhsh1 = "006986A5A3F98191"
        localizationTitleHSH1 = "508273131"
        LocalizationDesc1 = "1272804281"
        replace1 = "Sieger 300 Ornamental"
    }
        "Sieger 300 Arctic" = @{
        Code1 = "8d22cea9-68db-458d-a8ee-9937128f1729"
        localizationWeaponhsh1 = "006986A5A3F98191"
        localizationTitleHSH1 = "1057839163"
        LocalizationDesc1 = "1788578409"
        replace1 = "Sieger 300 Arctic"
    }
        "Hackl Leviathan" = @{
        Code1 = "0f9608e9-6e42-49b9-b4cd-9aaebba8458f"
        localizationWeaponhsh1 = "006986A5A3F98191"
        localizationTitleHSH1 = "1998520630"
        LocalizationDesc1 = "579457892"
        replace1 = "Hackl Leviathan"
    }
        "Hackl Leviathan Ducky" = @{
        Code1 = "d5f8e067-5b44-4ddf-91e2-3c29e9222eae"
        localizationWeaponhsh1 = "006986A5A3F98191"
        localizationTitleHSH1 = "159915413"
        LocalizationDesc1 = "1545523143"
        replace1 = "Hackl Leviathan Ducky"
    }
    }
     

    $FrameMap1 = @{
        "Sieger 300"     = "0"
        "Leviathan Muzzlebrake"   = "1"
        "Leviathan Big Muzzlebrake" = "2"
        "Leviathan Suppressor"        = "3"
        "Sieger 300 Arctic Wrapped" = "4"
        "Leviathan Suppressor Ducky" = "5"
    }

    $FrameColorMap1 = @{
        "orange wood"         = "0"
        "black with squares"  = "1"
        "black"               = "2"
        "beige wood"          = "3"
        "khaki"               = "4"
        "pink camo"           = "5"
        "blue camo 1"         = "6"
        "blue camo 2"         = "7"
        "blue camo 3"         = "8"
        "blue camo 4"         = "9"
        "tan green"           = "10"
        "arctic camo"          = "11"
        "red wood"            = "12"
        "gold"                = "13"
        "grafitti"            = "14"
        "brown wood (needs gun-part-pack)"          = "15"
    }

       # === Mapping: Muzzle Extension ===
    $MuzzleExtensionMap1 = @{
        "No extension"                  = "0"
        "Muzzle brake"                  = "1"
        "Suppressor long"               = "2"
        "Suppressor short"              = "3"
        "Suppressor long octagon"       = "4"
        "Suppressor long dimpled grey"  = "5"
        "Suppressor long wrapped arctic" = "6"
    }

    # === Mapping: Muzzle Extension Colors ===
    $MuzzleExtensionColorMap1 = @{
        # Suppressor long
        "black"         = "0"
        "olive"         = "1"
        "khaki dimpled" = "2"
        "black dimpled" = "3"
        "grey green"    = "4"
        "gold dimpled"  = "5"

        # Suppressor long octagon
        "greyblue"    = "0"
        "black matt"  = "1"
        "desert camo" = "2"
        "jungle camo" = "3"
        "black shiny" = "4"
        "gold"        = "5"        
    }
    
    # === Mapping: Gun Sound Perk ===
    $SoundMap1 = @{
        "loud" =@{
        AudioHeadType1 = "eWBC_AudioHeadTailType_Normal"
        AudioTailType1 = "eWBC_AudioHeadTailType_Normal"
        AudioPerk1     = ""
        SilenceRating1 = "eSR_NotSilenced"
        }

        "suppressed" =@{                  
        AudioHeadType1 = "eWBC_AudioHeadTailType_Silenced"
        AudioTailType1 = "eWBC_AudioHeadTailType_Silenced"
        AudioPerk1 = '"suppressor",'
        SilenceRating1 = "eSR_Silenced"
        }
    }

    # === Mapping: SoundStyle ===
    $SoundStyleMap1 = @{
        "light" =@{
        AudioWeaponFamily1 = "eWBC_AudioFamily_Light"
        } 
        "standard" =@{
        AudioWeaponFamily1 = "eWBC_AudioFamily_Standard"
        }
        "heavy" =@{
        AudioWeaponFamily1 = "eWBC_AudioFamily_Heavy"
        }
    }
    
    #Mapping Scope
    $ScopeMap1 = @{
        "No scope"                             = "0"
        "Sieger 300"                           = "1"
        "Jaeger"                               = "2"
        "Tuatara high"                         = "3" #not compatible with bullpup
        "Druzhina"                             = "4"
        "Bartoli black silver"                 = "5" #not compatible with bullpup
        "Bartoli Flip-Up Caps"                 = "6" #not compatible with bullpup
        "Leviathan"                            = "7" #not compatible with sieger 300
        "Dragon thin"                          = "8" #not compatible with bullpup
        "Tuatara"                              = "9"
        "Sieger 300 arctic wrapped"             = "10"
        "Druzhina Makeshift"                   = "11" #dlc
        "Bartoli black Gold"                   = "12" #not compatible with bullpup
        "Leviathan (gun-part-pack)"             = "13"
        "Bartoli Flip-Up Caps (gun-part-pack)"  = "14"
        "Bartoli black silver (gun-part-pack)"  = "15"
        "Bartoli black gold (gun-part-pack)"    = "16"
    }

    $ScopeColorMap1 = @{
       #Sieger300
        "black (red reticle)"   = "0"
        "black 2 (red reticle)" = "1"
        "black (blue reticle)"  = "2"
        "white"      = "3"
        "dark green" = "4"
        "grafiti"    = "5" #DLC
       #Jaeger
        "grey shiny"      = "0"
        "dark grey shiny" = "1"
        "dark brown"      = "2"
        "olive"           = "3"
        "dark grey"       = "4"
        "black"           = "5"
       #Druzhina
        "grey black"  = "0"
        "arctic"      = "1"
       #Tuatara
        "grey red"    = "0"
        "black red"   = "1"
        "black green" = "2"
    }

    # --- Variablen setzen ---
    #Weapon1 replace1
    #Neuer Code:
    $global:selectedWeapon1 = $cmbWeapon1.SelectedItem
    $entry = $WeaponMap1[$selectedWeapon1]

    # Weapon1-Code setzen
    $global:Weapon1 = $entry.Code1
    $global:Weaponfreelancer1 = $entry.CodeFreelancer1


    # Localizations setzen
    $global:localizationWeaponhsh1 = $entry.localizationWeaponhsh1
    $global:localizationTitleHSH1 = $entry.localizationTitleHSH1
    $global:LocalizationDesc1 = $entry.LocalizationDesc1

    #replaced Weapon1 setzen
    $global:replace1 = $entry.replace1


    #New Sniper Name
    $global:customname1 = $txtCustomName1.Text
        
    #Frame1
    $global:Frame1 = $FrameMap1[$cmbFrame1.SelectedItem]
    #Framecolor
    if ($cmbFrameColor1.Enabled) {
        $global:FrameColor1 = $FrameColorMap1[$cmbFrameColor1.SelectedItem]
    } else {
        #Framecolor: Wenn nicht wählbar, automatisch "0" setzen
        $global:FrameColor1 = "0"
    }    
        

    #Muzzle Extension 
    if ($cmbMuzzleExtension1.SelectedItem) {
        $global:MuzzleExtension1 = $MuzzleExtensionMap1[$cmbMuzzleExtension1.SelectedItem]
     }else {
    # wenn nicht wählbar, automatisch "0" setzen
    $global:MuzzleExtension1 = "0"
    }

    #Muzzle Extension Color
    if ($cmbMuzzleExtensionColor1.Enabled -and $cmbMuzzleExtensionColor1.SelectedItem) {
        $global:MuzzleExtensionColor1 = $MuzzleExtensionColorMap1[$cmbMuzzleExtensionColor1.SelectedItem]
    } else {
        $global:MuzzleExtensionColor1 = "0"  # Default-Wert falls keine Farbauswahl sichtbar
    }

    #Gun Sound Perk
    if ($cmbSound1.SelectedItem) {
        $global:Sound1 = $SoundMap1[$cmbSound1.SelectedItem]
    } else {
        $global:Sound1 = '"suppressor",'
    }
    if ($global:Sound1 -eq '"suppressor",') {
        $global:SoundModifier1 = '"4b91999b-adc2-4cad-b11b-7f992f4ba187",'
    } else {
        $global:SoundModifier1 = ""
    }

    #Gun Soundstyle
    if ($cmbSoundStyle1.Enabled -and $cmbSoundStyle1.SelectedItem) {
    $selectedSoundStyle1 = $cmbSoundStyle1.SelectedItem
    }
    if ($cmbSound1.Enabled -and $cmbSound1.SelectedItem) {
    $selectedSound1 = $cmbSound1.SelectedItem
    } else {
        $selectedSound1 = "suppressed"
    }     
    
    $global:SoundStyle1 = $SoundStyleMap1[$selectedSoundStyle1].Soundstyle1
    $global:AudioHeadType1 = $SoundMap1[$selectedSound1].AudioHeadType1
    $global:AudioTailType1 = $SoundMap1[$selectedSound1].AudioTailType1
    $global:AudioWeaponFamily1 = $SoundStyleMap1[$selectedSoundStyle1].AudioWeaponFamily1
    $global:AudioPerk1 = $SoundMap1[$selectedSound1].AudioPerk1
    $global:SilenceRating1 = $SoundMap1[$selectedSound1].SilenceRating1




        # Scope
    if ($cmbScope1.SelectedItem) {
        $global:Scope1 = $ScopeMap1[$cmbScope1.SelectedItem]


    # Scope Color
    if ($cmbScopeColor1.Enabled -and $cmbScopeColor1.SelectedItem) {
        $global:ScopeColor1 = $ScopeColorMap1[$cmbScopeColor1.SelectedItem]
    } else {
        $global:ScopeColor1 = "0"
    }

    #Extra Perks
        #Piercing
    if ($box1Perks1.Checked) {
        $global:MagazineConfigs1 = "1d43a4aa-1bdb-4318-b97f-ebb2427d63cf"
        $global:piercing1 = '"piercing",'
    } else {
            $global:MagazineConfigs1 = "d6ad5fd8-e673-4852-8062-3d790fb2b1d8"
            $global:piercing1 = ""
    }
        #Timeslowdown
    if ($box2Perks1.Checked) {
        $global:TimeSlowDown1 = "false"
    } else {
            $global:TimeSlowDown1 = "true"
    }
    
  
    
    
    #Icon
        #Sieger 300 Suppressor long
    if ($cmbFrame1.SelectedItem -like "*Sieger*" -and $cmbMuzzleExtension1.SelectedItem -like "*Suppressor long*") {
        $global:Icon1 = "15503940594429767"
    }
        #Sieger 300 Suppressor long octagon
    if ($cmbFrame1.SelectedItem -like "*Sieger*" -and $cmbMuzzleExtension1.SelectedItem -like "*Suppressor long octagon*") {
        $global:Icon1 = "57161410629942420"
    }
        #Sieger 300 Suppressor long dimpled grey
    if ($cmbFrame1.SelectedItem -like "*Sieger*" -and $cmbMuzzleExtension1.SelectedItem -like "*Suppressor long dimpled*") {
        $global:Icon1 = "62176097566166351"
    }
        #Sieger 300 Suppressor short
    if ($cmbFrame1.SelectedItem -like "*Sieger*") {
        $global:Icon1 = "67493879011746663"
    }
        #Leviathan
    if ($cmbFrame1.SelectedItem -eq "*Leviathan*") {
        $global:Icon1 = "67944667876105721"
    }
        #Sieger 300 Arctic Wrapped
    if ($cmbFrame1.SelectedItem -eq "*Sieger 300 Arctic Wrapped*" -and $cmbMuzzleExtension1.SelectedItem -like "*Suppressor long*") {
        $global:Icon1 = "51613673701711887"
    }
        
}
}

#Help Button
$HelpButtonClick1 = {
    param($sender)

    # Der Button, der geklickt wurde
    $btn = $sender

    # Ordnerpfad aus Tag lesen
    $imgFolder = $btn.Tag

    # Neues kleines Fenster
    $helpForm = New-Object System.Windows.Forms.Form
    $helpForm.Text = "Gun parts preview"
    $helpForm.Width = 450
    $helpForm.Height = 820
    $helpForm.StartPosition = "CenterParent"

    # Scrollbarer Panel-Bereich für Screenshots
    $panelPics = New-Object System.Windows.Forms.Panel
    $panelPics.Dock = "Fill"
    $panelPics.AutoScroll = $true
    $helpForm.Controls.Add($panelPics)

    if (Test-Path $imgFolder) {

        $yPos = 10

        Get-ChildItem $imgFolder -Filter *.jpg | ForEach-Object {

            # Bild
            $pic = New-Object System.Windows.Forms.PictureBox
            $pic.Image = [System.Drawing.Image]::FromFile($_.FullName)
            $pic.SizeMode = "Zoom"
            $pic.Width = 380
            $pic.Height = 120
            $pic.Location = New-Object System.Drawing.Point(10, $yPos)
            $panelPics.Controls.Add($pic)

            # Zentrierter Text
            $lbl = New-Object System.Windows.Forms.Label
            $lbl.Text = $_.Name
            $lbl.Width = 380
            $lbl.Height = 18
            $lbl.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
            $lbl.Location = New-Object System.Drawing.Point(10, ($yPos + 125))
            $panelPics.Controls.Add($lbl)

            $yPos += 155
        }
    }

    $helpForm.ShowDialog()
}
$btnFrameHelp1.Add_Click($HelpButtonClick1)
$btnMuzzleHelp1.Add_Click($HelpButtonClick1)
$btnScopeHelp1.Add_Click($HelpButtonClick1)

# === Import-Button Click Event ===
$ImportMenu1.Add_Click({
        try {
        # Basisverzeichnis
        $modsPath1 = Join-Path $scriptDir "Customballer-Mods"

        Add-Type -AssemblyName System.Windows.Forms

        # Datei-Dialog für ZIP oder gunsmithImport.txt
        $dialog1 = New-Object System.Windows.Forms.OpenFileDialog
        $dialog1.InitialDirectory = $modsPath1
        $dialog1.Filter = "ZIP and Gunsmith Import (*.zip;gunsmithImport.txt)|*.zip;gunsmithImport.txt|All Files (*.*)|*.*"
        $dialog1.Title = "Choose a bullpup sniper mod (ZIP) or gunsmithImport.txt"
        $dialog1.Multiselect = $false

        $selectedPath1 = $null
        if ($dialog1.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
            $selectedPath1 = $dialog1.FileName
        } else { return }

        # === Temp-Verzeichnis unter $scriptDir\customballer-mods\temp
        $tempRoot1 = Join-Path $scriptDir "Customballer-Mods\temp"
        if (-not (Test-Path $tempRoot1)) { New-Item -Path $tempRoot1 -ItemType Directory | Out-Null }
        $tempDir1 = Join-Path $tempRoot1 ("import_" + [guid]::NewGuid().ToString("N"))
        New-Item -Path $tempDir1 -ItemType Directory | Out-Null

        # === Prüfen Dateityp
        $gunsmithFile1 = $null
        if ($selectedPath1.ToLower().EndsWith(".zip")) {
            # ZIP entpacken
            Write-Host "📦 ZIP erkannt: $selectedPath1" -ForegroundColor Cyan
            Expand-Archive -Path $selectedPath1 -DestinationPath $tempDir1 -Force
            # gunsmithImport.txt im ZIP suchen
            $gunsmithFile1 = Get-ChildItem -Path $tempDir1 -Filter "gunsmithImport.txt" -Recurse -File -ErrorAction SilentlyContinue | Select-Object -First 1
            if (-not $gunsmithFile1) {
                [System.Windows.Forms.MessageBox]::Show("⚠️ Keine gunsmithImport.txt im ZIP gefunden.", "Import-Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
                return
            }
        }
        elseif ($selectedPath1.ToLower().EndsWith("gunsmithimport.txt")) {
            # Direkt Datei auswählen
            Write-Host "📄 gunsmithImport.txt erkannt: $selectedPath1" -ForegroundColor Cyan
            $gunsmithFile1 = Get-Item $selectedPath1
        }
        else {
            [System.Windows.Forms.MessageBox]::Show("⚠️ Bitte wähle eine ZIP-Datei oder gunsmithImport.txt aus.", "Import-Fehler", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
            return
        }

        # === Dateiinhalt lesen und UI setzen ===
        $content1 = Get-Content -Path $gunsmithFile1.FullName -Raw
        $pattern1 = '^\s*\$(?<ctrl>[A-Za-z0-9_]+)\.(?<prop>[A-Za-z0-9_]+)\s*=\s*"(?<val>[^"]*)"\s*$'

        foreach ($line1 in $content1 -split "`r?`n") {
            if ($line1 -match $pattern1) {
                $ctrl1 = $matches['ctrl']
                $prop1 = $matches['prop']
                $val1  = $matches['val']

                if (Get-Variable -Name $ctrl1 -ErrorAction SilentlyContinue) {
                    $uiElement1 = Get-Variable -Name $ctrl1 -ValueOnly
                    try { $uiElement1.$prop1 = $val1 } catch { Write-Host "⚠️ Konnte $ctrl1.$prop1 nicht setzen: $val1" -ForegroundColor Yellow }
                } else {
                    Write-Host "⚠️ Kein UI-Element '$ctrl1' gefunden." -ForegroundColor DarkYellow
                }
            }
        }

        [System.Windows.Forms.MessageBox]::Show("✅ Gunsmith-Import loaded.", "Import successful", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    }
    catch {
        [System.Windows.Forms.MessageBox]::Show("❌ Fehler: $($_.Exception.Message)", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
    finally {
    if ($null -ne $tempDir1 -and (Test-Path $tempDir1)) {
        try {
            Remove-Item $tempRoot1 -Recurse -Force -ErrorAction SilentlyContinue
        } catch {
            Write-Host "⚠️ Temp cleanup failed: $($_.Exception.Message)" -ForegroundColor DarkYellow
        }
    }
}
})



# === Generate-Mod-Button ===
$btnGenerate1 = New-Object System.Windows.Forms.Button
$btnGenerate1.Text = "Generate Mod"
$btnGenerate1.Location = New-Object System.Drawing.Point(331,$Ylbl)
$btnGenerate1.Font = New-Object System.Drawing.Font("Segoe UI", 12)  
#$btnGenerate.Font = New-Object System.Drawing.Font($btnGenerate.Font.FontFamily, 12, $btnGenerate.Font.Style)
$btnGenerate1.AutoSize = $true
$btnGenerate1.Add_Click({
    # === Eingaben prüfen ===
    $customname1 = $txtCustomName1.Text
    if ([string]::IsNullOrWhiteSpace($customname1)) {
        [System.Windows.Forms.MessageBox]::Show("✖ Error: Please enter a new bullpup sniper name.")
        return
    }

    # Prüfen, ob alle sichtbaren & aktivierten Comboboxen eine Auswahl haben
    $allValid1 = $true
    foreach ($ctrl1 in $panel1.Controls) {
        if ($ctrl1 -is [System.Windows.Forms.ComboBox] -and $ctrl1.Visible -and $ctrl1.Enabled) {
            if (-not $ctrl1.SelectedItem) {
                $allValid1 = $false
                break
            }
        }
    }

    if (-not $allValid1) {
        [System.Windows.Forms.MessageBox]::Show("✖ Error: Please select a value in all active dropdown lists.")
        return
    }

    # === Variablen setzen ===
    Set-SelectedVariables_Bullpup

    # === Ordner-Struktur bauen ===
    # === customname1 mit Underline erzeugen ===
    $customnameUnderline1 = $customname1 -replace '\s','_'
    # === customname1 ohne Leerzeichen erzeugen ===
    $customnameNoSpaces1 = $customname1 -replace '\s',''
    # === replace1 Name mit Underline erzeugen ===
    $replaceUnderline1 = $replace1 -replace '\s','_'



    # $scriptDir wurde oben ermittelt
    $modsDir1   = Join-Path $scriptDir "Customballer-Mods"

    if (-not (Test-Path $modsDir1)) { New-Item -ItemType Directory -Path $modsDir1 | Out-Null }

    $baseFolder1 = Join-Path $modsDir1 ("{0}_CBG_NOMAECK" -f $customnameUnderline1)
    $blobsFolder1 = Join-Path $baseFolder1 "blobs\images\unlockables_override"
    $modelFolder1 = Join-Path $baseFolder1 ("{0}\{1}\Model\chunk0" -f $replaceUnderline1, $customnameUnderline1)

    New-Item -ItemType Directory -Force -Path $blobsFolder1 | Out-Null
    New-Item -ItemType Directory -Force -Path $modelFolder1 | Out-Null



    #Manifest.json          
    Set-Content -Path (Join-Path $baseFolder1 "manifest.json") -Value @"
{
 	"`$schema": "https://raw.githubusercontent.com/atampy25/simple-mod-framework/main/Mod%20Manager/src/lib/manifest-schema.json",	
	"id": "${customnameNoSpaces1}.CBG_NOMAECK",
	"name": "${customnameUnderline1}_CBG_NOMAECK",
	"description": "User self created bullpup sniper that replaces $replace1, created with NOMAECK's Customballer Gunsmith",
	"authors": ["NOMAECK"],
	"frameworkVersion": "2.33.27",
	"version": "1.0.0",
	"blobsFolders": ["blobs"],
	"thumbs": ["ConsoleCmd OnlineResources_Disable 1"],
	"options":[
		{
			"group": "$replaceUnderline1",
			"name": "$customname1",
			"type": "checkbox",
			"enabledByDefault": true,
			"image": "blobs/images/unlockables_override/$customnameUnderline1.jpg",
			"contentFolders": ["$replaceUnderline1/$customnameUnderline1/Model"],
			"localisationOverrides": {
			"$localizationWeaponhsh1": {
			"english": {"$localizationTitleHSH1": "$customname1", "$LocalizationDesc1": "Tactical custom sniper, created with NOMAECK's Customballer Gunsmith"},
			"french": {"$localizationTitleHSH1": "$customname1", "$LocalizationDesc1": "Fusil de sniper tactique personnalise, cree avec le Customballer Gunsmith de NOMAECK"},
			"italian": {"$localizationTitleHSH1": "$customname1", "$LocalizationDesc1": "Fucile da cecchino tattica personalizzata, creata con Customballer Gunsmith di NOMAECK"},
			"german": {"$localizationTitleHSH1": "$customname1", "$LocalizationDesc1": "Taktische Custom-Sniper, erstellt mit NOMAECKs Customballer Gunsmith"},
			"spanish": {"$localizationTitleHSH1": "$customname1", "$LocalizationDesc1": "Rifle de francotirador tactica personalizada, creada con Customballer Gunsmith de NOMAECK"},
			"russian": {"$localizationTitleHSH1": "$customname1", "$LocalizationDesc1": "Tactical custom sniper, created with NOMAECK's Customballer Gunsmith"},
			"chineseSimplified": {"$localizationTitleHSH1": "$customname1", "$LocalizationDesc1": "Tactical custom sniper, created with NOMAECK's Customballer Gunsmith"},
			"chineseTraditional": {"$localizationTitleHSH1": "$customname1", "$LocalizationDesc1": "Tactical custom sniper, created with NOMAECK's Customballer Gunsmith"},
			"japanese": {"$localizationTitleHSH1": "$customname1", "$LocalizationDesc1": "Tactical custom sniper, created with NOMAECK's Customballer Gunsmith"}
					}
				}
		}
        ]
}
"@

    #Manifestimport.txt          
    Set-Content -Path (Join-Path $modelFolder1 "manifestimport.txt") -Value @"
		{
			"group": "$replaceUnderline1",
			"name": "$customname1",
            "tooltip": "Changes $replaceUnderline1 model to $customname1",
			"type": "select",
			"enabledByDefault": false,
			"image": "blobs/images/unlockables_override/$customnameUnderline1.jpg",
			"contentFolders": ["$replaceUnderline1/$customnameUnderline1/Model"],
			"localisationOverrides": {
			"$localizationWeaponhsh1": {
			"english": {"$localizationTitleHSH1": "$customname1", "$LocalizationDesc1": "Tactical custom sniper, created with NOMAECK's Customballer Gunsmith"},
			"french": {"$localizationTitleHSH1": "$customname1", "$LocalizationDesc1": "Fusil de sniper tactique personnalise, cree avec le Customballer Gunsmith de NOMAECK"},
			"italian": {"$localizationTitleHSH1": "$customname1", "$LocalizationDesc1": "Fucile da cecchino tattica personalizzata, creata con Customballer Gunsmith di NOMAECK"},
			"german": {"$localizationTitleHSH1": "$customname1", "$LocalizationDesc1": "Taktische Custom-Sniper, erstellt mit NOMAECKs Customballer Gunsmith"},
			"spanish": {"$localizationTitleHSH1": "$customname1", "$LocalizationDesc1": "Rifle de francotirador tactica personalizada, creada con Customballer Gunsmith de NOMAECK"},
			"russian": {"$localizationTitleHSH1": "$customname1", "$LocalizationDesc1": "Tactical custom sniper, created with NOMAECK's Customballer Gunsmith"},
			"chineseSimplified": {"$localizationTitleHSH1": "$customname1", "$LocalizationDesc1": "Tactical custom sniper, created with NOMAECK's Customballer Gunsmith"},
			"chineseTraditional": {"$localizationTitleHSH1": "$customname1", "$LocalizationDesc1": "Tactical custom sniper, created with NOMAECK's Customballer Gunsmith"},
			"japanese": {"$localizationTitleHSH1": "$customname1", "$LocalizationDesc1": "Tactical custom sniper, created with NOMAECK's Customballer Gunsmith"}
					}
				}
		}
"@

    #GunsmithImport.txt          
    Set-Content -Path (Join-Path $modelFolder1 "gunsmithImport.txt") -Value @"
        `$cmbWeapon1.SelectedItem = "$($cmbWeapon1.selectedItem)"
        `$txtCustomName1.Text     = "$($txtCustomName1.Text)"
        `$cmbFrame1.SelectedItem = "$($cmbFrame1.selectedItem)"
        `$cmbFrameColor1.SelectedItem = "$($cmbFrameColor1.selectedItem)"
        `$cmbMuzzleExtension1.SelectedItem = "$($cmbMuzzleExtension1.selectedItem)"
        `$cmbMuzzleExtensionColor1.SelectedItem = "$($cmbMuzzleExtensionColor1.selectedItem)"
        `$cmbSound1.SelectedItem = "$($cmbSound1.selectedItem)"
        `$cmbSoundStyle1.SelectedItem = "$($cmbSoundStyle1.selectedItem)"
        `$cmbScope1.SelectedItem = "$($cmbScope1.selectedItem)"
        `$cmbScopeColor1.SelectedItem = "$($cmbScopeColor1.selectedItem)"
        `$box1Perks1.checkstate = "$($box1Perks1.checkstate)"
        `$box2Perks1.checkstate = "$($box2Perks1.checkstate)"
"@
    
    #Project.json
    Set-Content -Path (Join-Path $baseFolder1 "project.json") -Value @"
{
    "customPaths": []
}
"@
    
    #repsitory:
 Set-Content -Path (Join-Path $modelFolder1 ("{0}.repository.json" -f $customnameUnderline1)) -Value @"
{
    "$Weapon1":{
        "AppliedModifiers":[
            $SoundModifier1
            "6e45cc2f-cbde-4bc4-87ed-59a1a86404af"
        ],        
	    "Image":"images/unlockables_override/$customnameUnderline1.jpg",
	    "ModelBodyPartSelections":[$frame1],
	    "ModelSkinSelections":[$framecolor1, 0, 0, 0, 0, 0, 0],
	    "ModelMuzzleExtensionSelection":$Muzzleextension1,
	    "ModelMuzzleExtensionSkinSelection":$Muzzleextensioncolor1,
	    "ModelScopeSelection":$Scope1,
	    "ModelScopeSkinSelection":$Scopecolor1,
        "Perks": [
                $piercing1
		        $AudioPerk1
                "versatilescope",
		        "marksman"
	    ],
        "AudioHeadType": "$AudioHeadType1",
        "AudioTailType": "$AudioTailType1",
        "AudioWeaponFamily": "$AudioWeaponFamily1",
        "HudIcon": "$Icon1",
        "ActorConfiguration":{
            "AllowPrecisionTimeSlowdown":$TimeSlowDown1,
            "MagazineConfigs":[
                "$MagazineConfigs1"
                ],
            "SilenceRating":"$SilenceRating1"
            },
        "PrimaryConfiguration":{
            "AllowPrecisionTimeSlowdown":$TimeSlowDown1,
            "MagazineConfigs":[
                "$MagazineConfigs1"
                ],
            "SilenceRating":"$SilenceRating1"
            },
        "SecondaryConfiguration":{
            "AllowPrecisionTimeSlowdown":$TimeSlowDown1,
            "MagazineConfigs":[
                "$MagazineConfigs1"
                ],
            "SilenceRating":"$SilenceRating1"
            }
	}
}
"@

    # Bild kopieren
    $sourceImage1 = Join-Path $scriptDir "images\bullpup.jpg"
    $destImage1   = Join-Path $blobsFolder1 "$customnameUnderline1.jpg"
    if (Test-Path $sourceImage1) { Copy-Item -Path $sourceImage1 -Destination $destImage1 -Force }
    if (-not (Test-Path $sourceImage1)) {[System.Windows.Forms.MessageBox]::Show("You deleted bullpup.jpg from Customballer_Gunsmith\images folder. Do not delete Customballer Gunsmith files! Restore the files, otherwise your Customballer mods will not work fully!")
    }

    # === ZIP erstellen ===
    $zipPath1 = Join-Path $modsDir1 ("{0}_CBG_NOMAECK.zip" -f $customnameUnderline1)
    if (Test-Path $zipPath1) { Remove-Item $zipPath1 -Force }
    Compress-Archive -Path $baseFolder1 -DestinationPath $zipPath1

    # === Ordner nach dem Packen löschen ===
if (Test-Path $baseFolder1) {
   Remove-Item $baseFolder1 -Recurse -Force
}

    [System.Windows.Forms.MessageBox]::Show("✔ Mod created successfully:
    `n$zipPath1")

# === Ordner im Explorer öffnen ===
$zipFolder1 = Split-Path $zipPath1 -Parent

# COM-Objekt holen
$shell1 = New-Object -ComObject Shell.Application
$alreadyOpen1 = $false

foreach ($window1 in $shell1.Windows()) {
    try {
        if ($window1.FullName -like "*explorer.exe" -and 
            $window1.Document.Folder.Self.Path -eq $zipFolder1) {
            $alreadyOpen1 = $true
            break
        }
    } catch {
        # Ignorieren: Nicht alle Fenster haben Document.Folder
    }
}

if (-not $alreadyOpen1) {
    Start-Process explorer.exe -ArgumentList $zipFolder1
}


})
$panel1.Controls.Add($btnGenerate1)






# === Test-Button ===
$btnTest1 = New-Object System.Windows.Forms.Button
$btnTest1.Text = "Test"
$btnTest1.Location = New-Object System.Drawing.Point($X1lbl,($Ylbl+3))
$btnTest1.Add_Click({
    Set-SelectedVariables_Bullpup
    # --- Testausgabe ---
    [System.Windows.Forms.MessageBox]::Show(
    "Weapon1: $Weapon1`nCustom Name: $customname1`nBarrel: $Barrel`nBarrel Color: $BarrelColor`nFrame: $Frame1`nFrame Color: $FrameColor`nHammer: $Hammer`nHammer Color: $HammerColor`nTrigger: $Trigger`nTrigger Color: $TriggerColor`nSlide: $Slide`nSlide Color: $SlideColor`nGrip: $Grip`nGrip Color: $GripColor`nGrip Cover: $GripCover`nGrip Cover Color: $GripCoverColor`nGrip Safety: $GripSafety`nGrip Safety Color: $GripSafetyColor`nMagazine: $Magazine`nMagazine Color: $MagazineColor`nMagazine Bullets: $MagazineBullets`nMuzzle Extension: $MuzzleExtension`nMuzzle Extension Color: $MuzzleExtensionColor`nScope: $Scope`nScope Color: $ScopeColor`nRail: $rail`nSound: $Sound`nSoundstyle: $SoundStyle`nAudioHeadType: $AudioHeadType`nAudioTailType: $AudioTailType`nAudioWeaponFamily: $AudioWeaponFamily`nSound Modifier: $SoundModifier`nFull Auto: $FullAuto`nFire Mode applied modifier: $FireMode`nIcon: $Icon1",
    "Auswahlübersicht"
)

})
#$panel1.Controls.Add($btnTest)

$Yline += $Yplus
$Ylbl += $Yplus
$Ycmb += $Yplus

# === Donation / Update Panel ===
$panelLabelDonation = New-Object System.Windows.Forms.Panel
$panelLabelDonation.Location = New-Object System.Drawing.Point(($X1lbl),$Ylbl)
$panelLabelDonation.Size = New-Object System.Drawing.Size($linewidth,65)
$panelLabelDonation.BorderStyle = "FixedSingle"
$panelLabelDonation.BackColor = [System.Drawing.Color]::White
$panel1.Controls.Add($panelLabelDonation)

if ($updateAvailable) {
    # --- Update-Hinweis ---
    $lblUpdate = New-Object System.Windows.Forms.Label
    $lblUpdate.Text = "New update available! (v$localVersion → v$remoteVersion)"
    $lblUpdate.AutoSize = $true
    $lblUpdate.Font = New-Object System.Drawing.Font("Segoe UI",10,[System.Drawing.FontStyle]::Bold)
    $lblUpdate.ForeColor = [System.Drawing.Color]::Red
    $lblUpdate.Location = New-Object System.Drawing.Point(250,10)
    $panelLabelDonation.Controls.Add($lblUpdate)

    # --- Download-Button ---
    $btnDownload = New-Object System.Windows.Forms.Button
    $btnDownload.Text = "Download"
    $btnDownload.Location = New-Object System.Drawing.Point(320,35)
    
       $btnDownload.Add_Click({
    # Button deaktivieren
    $btnDownload.Enabled = $false
    $lblUpdate.Text = "Downloading update..."

    # GUI sauber schließen
    $Form.Close()

    # Starte das Update-Script in eigenem Prozess
    $updateScriptPath = Join-Path $scriptDir "script\newupdate.ps1"
    Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$updateScriptPath`""

    # Haupt-Thread beenden ohne ExitException
    return
})




    
    $panelLabelDonation.Controls.Add($btnDownload)
}
else {
    # --- Standard Donation ---
    $lblDonation = New-Object System.Windows.Forms.Label
    $lblDonation.Text = "You’re not a fan of unpaid work? Then support my amazing tool — buy me a coffee! :)"
    $lblDonation.AutoSize = $true
    $lblDonation.Location = New-Object System.Drawing.Point(155,15)
    $panelLabelDonation.Controls.Add($lblDonation)

    $linkLabel = New-Object System.Windows.Forms.LinkLabel
    $linkLabel.Text = "https://buymeacoffee.com/nomaeck"
    $linkLabel.Location = New-Object System.Drawing.Point(273,35)
    $linkLabel.AutoSize = $true
    $linkLabel.Links[0].LinkData = "https://buymeacoffee.com/nomaeck"
    $linkLabel.Add_LinkClicked({
        param($sender,$e)
        Start-Process $e.Link.LinkData
    })
    $panelLabelDonation.Controls.Add($linkLabel)
}