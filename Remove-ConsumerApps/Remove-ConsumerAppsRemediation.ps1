<#
Version: 1.0
Author: 
- Marius Wyss (marius.wyss@microsoft.com)
Script: Remove-ConsumerAppsRemediation.ps1
Description:
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#> 

$ConsumerApps = @{
    "Microsoft.XboxApp" = "Xbox App"
    "Microsoft.XboxGameOverlay" = "Xbox Game Overlay"
    "Microsoft.Xbox.TCUI" = "Xbox TCUI"
    "Microsoft.MicrosoftSolitaireCollection" = "Solitaire Collection"
    "Microsoft.549981C3F5F10" = "Cortana"
    "Microsoft.BingNews" = "BingNews"
    "Microsoft.BingWeather" = "BingWeather"
    "Microsoft.Messaging" = "Messaging"
    "Microsoft.MixedReality.Portal" = "MixedReality Portal"
    "Microsoft.OutlookForWindows" = "Outlook for Windows"
    "Microsoft.WindowsStore" = "Windows Store"
    "Microsoft.XboxGameCallableUI" = "XboxGameCallableUI"
    "Clipchamp.Clipchamp" = "Clipchamp"
    "Microsoft.Getstarted" = "Getstarted"
    "Microsoft.GetHelp" = "Get Help"
    "Microsoft.People" = "People"
    "Microsoft.PowerAutomateDesktop" = "PowerAutomate Desktop"
    "Microsoft.windowscommunicationsapps" = "Windows Communications"
    "Microsoft.WindowsFeedbackHub" = "Feedback Hub"
    "Microsoft.WindowsMaps" = "Maps"
    "Microsoft.XboxGamingOverlay" = "Xbox Gaming-Overlay"
    "Microsoft.XboxIdentityProvider" = "Xbox Identity"
    "Microsoft.XboxSpeechToTextOverlay" = "Xboy SpeechToText"
    "Microsoft.YourPhone" = "Your Phone"
    "Microsoft.ZuneMusic" = "Zune Music"
    "Microsoft.ZuneVideo" = "Zune Video"
    "Microsoft.Windows.DevHome" = "Dev Home"
}


# Uninstall all Consumer Apps
# Check if any of the Consumer Apps are installed
$UninstallPackages = $ConsumerApps.Keys

$InstalledPackages = Get-AppxPackage -AllUsers | Where { ($UninstallPackages -contains $_.Name) }


$out = @()
foreach ($App in $InstalledPackages) {
    try {
        Get-AppxPackage -Name $($App.Name) -AllUsers | Remove-AppxPackage -AllUsers | Out-Null
        $AllAppXProvisionedPackage | Where { $_.DisplayName -eq $($App.Name) } |  Remove-AppxProvisionedPackage -Online | Out-Null
        $out += $App.Name
    }
    catch {
        $errMsg = $_.Exception.Message
        return $errMsg
        Exit 1
    }
}

if ($out.Count -eq 0) {
    Write-Output "No Consumer Apps found"
    Exit 0
}

if ($out.Count -gt 0) {
    Write-Output "Consumer Apps removed: ($($out -join ', '))"
    Exit 0
}

