<#
Name: OneDrive Usage Report.ps1

This script is for Reporting of OneDrive Usage.

Michael Patterson
scripts@mwpatterson.com

Revision History
    2018-06-16 - Initial Release
    2018-06-28 - Cleaunp
    2022-01-11 - Cleanup
    2026-08-01 - Streamlined export handling to avoid unnecessary object retention

#>

<#
# Check For Admin Mode
#Requires -RunAsAdministrator
#>

# Set Variables

# Get Date & Log Locations
$date = get-date -Format "yyyy-MM-dd-HH-mm"
$logRoot = "C:\"
$logFolder = "Temp"
$logFolderPath = Join-Path -Path $logRoot -ChildPath $logFolder
$logFile = "OD4BReport.csv"
$logFile2 = "OD4BReport-Full.csv"
$logPath = Join-Path -Path $logFolderPath -ChildPath ($date + "-" + $logFile)
$logPath2 = Join-Path -Path $logFolderPath -ChildPath ($date + "-" + $logFile2)
#>

if (-not (Test-Path -LiteralPath $logFolderPath)) {
    New-Item -Path $logFolderPath -ItemType Directory -Force | Out-Null
}

#<#
# Limited Report
# Get OneDrive for Business Sites
$exportParams = @{
    NoTypeInformation = $true
    Path = $logPath
}
Get-SpoSite -IncludePersonalSite:$True -Limit All -Filter "Url -like '-my.sharepoint.com/personal/'" |
    Select-Object @{N='UserName';E={$_.Title}},
    @{N='PersonalUrl';E={$_.Url}},
    Owner, Status, LastContentModifiedDate, StorageUsageCurrent, StorageQuota, SharingCapability |
    Export-Csv @exportParams
#>

#<#
# Full Report
# Get OneDrive for Business Sites
$exportParams = @{
    NoTypeInformation = $true
    Path = $logPath2
}
Get-SpoSite -IncludePersonalSite:$True -Limit All -Filter "Url -like '-my.sharepoint.com/personal/'" |
    Select-Object * |
    Export-Csv @exportParams
#>

