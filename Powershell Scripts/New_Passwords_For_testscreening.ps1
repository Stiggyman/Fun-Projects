# Check for Windows Forms assembly
function Check-Assembly {
    param (
        [string]$AssemblyName
    )

    try {
        Add-Type -AssemblyName $AssemblyName -ErrorAction Stop
        Write-Host "Assembly $AssemblyName loaded successfully."
    } catch {
        Write-Host "Assembly $AssemblyName could not be loaded."
        Write-Host "Please install the .NET Framework that contains this assembly."
        Write-Host "You may need to install or repair the .NET Framework. Visit https://dotnet.microsoft.com/download/dotnet-framework for more details."
        exit
    }
}

# Check if the required assemblies are available
Check-Assembly -AssemblyName "System.Windows.Forms"
Check-Assembly -AssemblyName "System.Drawing"


$form = New-Object System.Windows.Forms.Form
$form.Text = "Password Reset Tool"
$form.Size = New-Object System.Drawing.Size(400, 250)
$form.StartPosition = "CenterScreen"


$label = New-Object System.Windows.Forms.Label
$label.Text = "This tool will reset the passwords for all users in the specified OU."
$label.Size = New-Object System.Drawing.Size(350, 60)
$label.Location = New-Object System.Drawing.Point(20, 20)
$label.AutoSize = $true

$explanation = New-Object System.Windows.Forms.TextBox
$explanation.Multiline = $true
$explanation.ReadOnly = $true
$explanation.Text = "This tool will reset the passwords for all users in the OU: ibc.dk/Brugere/Diverse/OBUTest. Enter the new password below."
$explanation.Size = New-Object System.Drawing.Size(350, 60)
$explanation.Location = New-Object System.Drawing.Point(20, 60)
$explanation.ScrollBars = "Vertical"


$passwordBox = New-Object System.Windows.Forms.TextBox
$passwordBox.Location = New-Object System.Drawing.Point(20, 130)
$passwordBox.Size = New-Object System.Drawing.Size(350, 30)
$passwordBox.UseSystemPasswordChar = $true


$okButton = New-Object System.Windows.Forms.Button
$okButton.Text = "OK"
$okButton.Location = New-Object System.Drawing.Point(150, 170)
$okButton.Enabled = $false


$passwordBox.add_TextChanged({
    if ($passwordBox.Text.Length -ge 5) {
        $okButton.Enabled = $true
    } else {
        $okButton.Enabled = $false
    }
})

$okButton.Add_Click({
    $newPassword = $passwordBox.Text
    

    Import-Module ActiveDirectory
    

    $ouPath = "OU=OBUTest,OU=Diverse,OU=Brugere,DC=ibc,DC=dk"
    

    $users = Get-ADUser -Filter * -SearchBase $ouPath
    
    foreach ($user in $users) {

        #Set-ADAccountPassword -Identity $user -NewPassword (ConvertTo-SecureString -AsPlainText $newPassword -Force) -Reset
        Write-Host "Password for $($user.SamAccountName) has been reset."
    }
    

    $form.Close()
})

# Add controls to the form
$form.Controls.Add($label)
$form.Controls.Add($explanation)
$form.Controls.Add($passwordBox)
$form.Controls.Add($okButton)

# Display the form
$form.ShowDialog()
