#$mfaUsed = 'Yes' # Use if MFA is Used
$mfaUsed = 'No' # Use if MFA is Not Used

$Cred = Get-Credential

#<#
# Connect to O365 Needed for Variable creations
If ($mfaUsed -eq 'No') {
    Write-Host "Connecting to MSOL"
    Connect-MsolService -Credential $cred
}
Else {
    Write-Host "Connecting to MSOL - MFA"
    Connect-MsolService
}
#>

$Script:objTemp = New-Object System.Object

#<#
#Connect-MsolService
$TenantName = (Get-MsolDomain | Where-Object {$_.isInitial}).name
$TenantSName = $TenantName.Substring(0,$TenantName.IndexOf('.'))
$sharePTURL = "https://$TenantSName-admin.sharepoint.com"
#Connect-SPOService -Url https://<Tenant>-admin.sharepoint.com
#Connect-SPOService -Url $sharePTURL 
#Connect-PnPOnline -Url $sharePTURL -Credentials (Get-Credential)
#Connect-PnPOnline -Url $sharePTURL -PnPManagementShell # Run on first connection to Instance & Follow propmpts to configure
#$Cred = Get-Credential
#>
$outputCsv = "C:\Temp\$(Get-Date -Format yyyy-MM-dd-HH-mm) - $TenantName - Admins.csv" 
If ($mfaUsed -eq 'No') {
    Write-Host "Connecting to SharePoint Online - $sharePTURL"
    Connect-PnPOnline -Url $sharePTURL -Credentials $Cred
}
Else {
    Write-Host "Connecting to SharePoint Online - MFA - $sharePTURL"
    Connect-PnPOnline -Url $sharePTURL
}
$Sites = Get-PnPTenantSite
#Loop through each Site Collection
ForEach ($Site in $Sites) { 
    $tempSite = $Site.Url
    If ($mfaUsed -eq 'No') {
Write-Host "Connecting to SharePoint Online - $tempSite"
Connect-PnPOnline -Url $Site.Url -Credentials $Cred
    }
    Else {
Write-Host "Connecting to SharePoint Online - MFA - $tempSite"
Connect-PnPOnline -Url $Site.Url
    }
    #Get Site Collection Administrators
    $admins = Get-PnPSiteCollectionAdmin | Select-Object Title, email
    $allAdmins=""
    $allAdmins
    Pause
    foreach($admin in $admins) {
$allAdmins += $admin.Title + ";"+ $admin.email +";"
    }
    $count = @(Get-PnPSiteCollectionAdmin).count
    $Script:objTemp | Add-Member -type noteproperty -name $site.Url -Value $count
    ($site.Url+","+$site.Title+","+$count+","+$allAdmins) >> $outputCsv
    Disconnect-PnPOnline 
}
$Script:objTemp | Add-Member -type noteproperty -name "Output file" -value $outputCsv