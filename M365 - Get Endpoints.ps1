<#
Name: M365 - Get Endpoints.ps1

This script is used to read the JSON File for the Microsoft 365 Endpoints published by Microsoft

Below is a list of the files created from this script:
    <Year>-<Month>-<Date>-<Hour>-<Minuite>-Office 365 Worldwide (+GCC).JSON   - This list contains all the IP's listed in the Office 365 Worldwide (+GCC) Endpoint list
    <Year>-<Month>-<Date>-<Hour>-<Minuite>-Office 365 U.S. Government GCC High.JSON   - This list contains all the IP's listed in the Office 365 U.S. Government GCC High Endpoint list
    <Year>-<Month>-<Date>-<Hour>-<Minuite>-Office 365 U.S. Government DoD.JSON   - This list contains all the IP's listed in the Office 365 U.S. Government DoD Endpoint list

Reference URL's
    https://docs.microsoft.com/en-us/microsoft-365/enterprise/urls-and-ip-address-ranges?view=o365-worldwide
    https://docs.microsoft.com/en-us/microsoft-365/enterprise/microsoft-365-u-s-government-gcc-high-endpoints?view=o365-worldwide
    https://docs.microsoft.com/en-us/microsoft-365/enterprise/microsoft-365-u-s-government-dod-endpoints?view=o365-worldwide

Michael Patterson
scripts@mwpatterson.com

Revision History
    2022-09-13 - Initial Release
    2026-08-01 - Consolidated endpoint downloads into a single loop to reduce duplicated code and memory churn

#>

# Get Date & Backup Locations
$date = get-date -Format 'yyyy-MM-dd-HH-mm'
$backupRoot = 'C:\' #Can use another drive if available
$backupFolder = 'Temp\M365Endpoints\'
$backupFolderPath = $backupRoot + $backupFolder
#$backupFileName = $date + "-" + $env:USERDNSDOMAIN #Full Domain Name 
#$backupPath = $backupFolderPath + $backupFileName

$endpointDefinitions = @(
    [pscustomobject]@{ Name = 'Office 365 Worldwide (+GCC)'; Uri = 'https://endpoints.office.com/endpoints/worldwide?clientrequestid=b10c5ed1-bad1-445f-b386-b919946339a7'; FileName = 'Office 365 Worldwide (+GCC).json' },
    [pscustomobject]@{ Name = 'Office 365 U.S. Government GCC High'; Uri = 'https://endpoints.office.com/endpoints/USGOVGCCHigh?clientrequestid=b10c5ed1-bad1-445f-b386-b919946339a7'; FileName = 'Office 365 U.S. Government GCC High.json' },
    [pscustomobject]@{ Name = 'Office 365 U.S. Government DoD'; Uri = 'https://endpoints.office.com/endpoints/USGOVDoD?clientrequestid=b10c5ed1-bad1-445f-b386-b919946339a7'; FileName = 'Office 365 U.S. Government DoD.json' }
)

if (-not (Test-Path -LiteralPath $backupFolderPath)) {
    New-Item -Path $backupFolderPath -ItemType Directory -Force | Out-Null
}

foreach ($endpoint in $endpointDefinitions) {
    $backupFileName = $date + '-' + $endpoint.FileName
    $backupPath = Join-Path -Path $backupFolderPath -ChildPath $backupFileName
    $endpointData = Invoke-RestMethod -Uri $endpoint.Uri -Method Get
    $endpointData | ConvertTo-Json -Depth 20 | Out-File -FilePath $backupPath -Encoding utf8
}


