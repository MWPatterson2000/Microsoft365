<#
Name: SharePoint Usage Report.ps1

This script is for Reporting of SharePoint Online Usage.

Michael Patterson
scripts@mwpatterson.com

Revision History
    2019-04-10 - Initial Release
    2019-04-10 - Cleaunp
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
$logFile = "SharePointOnlineReport.csv"
$logFile2 = "SharePointOnlineReport-Full.csv"
#$logFileName = $date +"-" +$logFile 
#$logFileName2 = $date +"-" +$logFile2 
$logPath = $logRoot +$logFolder +$date +"-" +$logFile
$logPath2 = $logRoot +$logFolder +$date +"-" +$logFile2
#>

#<#
# Limited Report
# Get OneDrive for Business Sites
$SharePointSites = Get-SpoSite -Limit All |
    Select-Object @{N='UserName';E={$_.Title}},
    @{N='PersonalUrl';E={$_.Url}},
    #@{Name="Created";Expression={$_.RootWeb.Created}},
    Owner, Status, LastContentModifiedDate, StorageUsageCurrent, StorageQuota, SharingCapability |
    Export-csv -notype $logPath
#>

#<#
# Full Report
# Get OneDrive for Business Sites
#$SharePointSites = Get-SpoSite -Limit All -Detailed |
$SharePointSites = Get-SpoSite -Limit All |
    Select-Object * | 
    Export-csv -notype $logPath2
#>

#Write-Host $SharePointSites
