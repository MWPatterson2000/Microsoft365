<#
Name: OneDrive Usage Report.ps1

This script is for Reporting of OneDrive Usage.

Michael Patterson
scripts@mwpatterson.com

Revision History
    2018-06-16 - Initial Release
    2018-06-28 - Cleaunp
    2022-01-11 - Cleanup

#>

<#
# Check For Admin Mode
#Requires -RunAsAdministrator
#>

# Set Variables

# Get Date & Log Locations
$date = get-date -Format "yyyy-MM-dd-HH-mm"
$logRoot = "C:\"
$logFolder = "Temp\"
#$logFolderPath = $logRoot +$logFolder
$logFile = "OD4BReport.csv"
$logFile2 = "OD4BReport-Full.csv"
#$logFileName = $date +"-" +$logFile 
#$logFileName2 = $date +"-" +$logFile2 
$logPath = $logRoot +$logFolder +$date +"-" +$logFile
$logPath2 = $logRoot +$logFolder +$date +"-" +$logFile2
#>

#<#
# Limited Report
# Get OneDrive for Business Sites
$OD4B = Get-SpoSite -IncludePersonalSite:$True -Limit All -Filter "Url -like '-my.sharepoint.com/personal/'" |
    Select-Object @{N='UserName';E={$_.Title}},
    @{N='PersonalUrl';E={$_.Url}},
    Owner, Status, LastContentModifiedDate, StorageUsageCurrent, StorageQuota, SharingCapability |
    #Export-csv -notype D:\Downloads\Scripts\OneDrive\$date-OD4BReport.csv
    #Export-csv -notype C:\Temp\$date-OD4BReport.csv
    Export-csv -notype $logPath
#>

#<#
# Full Report
# Get OneDrive for Business Sites
$OD4B = Get-SpoSite -IncludePersonalSite:$True -Limit All -Filter "Url -like '-my.sharepoint.com/personal/'" |
    Select-Object * | 
    #Export-csv -notype C:\Temp\$date-OD4BReport-Full.csv
    Export-csv -notype $logPath2
#>

#Write-Host $OD4B

