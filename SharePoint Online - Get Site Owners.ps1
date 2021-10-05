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

#<#
# Connect to AzureAD
If ($mfaUsed -eq 'No') {
    Write-Host "Connecting to Azure AD"
    #Connect-AzureAD -Credential $cred # Use if MFA is Not Used
    If ($TenantType -eq "Commercial") {Connect-AzureAD -Credential $cred}
}
Else {
    Write-Host "Connecting to Azure AD - MFA"
    #Connect-AzureAD # Use if MFA is Used
    If ($TenantType -eq "Commercial") {Connect-AzureAD}
}
#>

#<#
# Connect to SharePoint Online
# Build Connection String
$TenantName = (Get-MsolDomain | Where-Object {$_.isInitial}).name
$TenantSName = $TenantName.Substring(0,$TenantName.IndexOf('.'))
$sharePTURL = "https://$TenantSName-admin.sharepoint.com"
If ($mfaUsed -eq 'No') {
    Write-Host "Connecting to SharePoint Online"
    Connect-SPOService -Url $sharePTURL -Credential $cred # Use if MFA is Not Used
}
Else {
    Write-Host "Connecting to SharePoint Online - MFA"
    Connect-SPOService -Url $sharePTURL # Use if MFA is Used
}
#>

$outputCsv = "C:\Temp\$(Get-Date -Format yyyy-MM-dd-HH-mm) - $TenantName - Owners.csv" 

#Get all Site Collections
$Sites = Get-SPOSite -Limit ALL
 
$SiteOwners = @()
#Get Site Owners for each site collection
$Sites | ForEach-Object {
    If($_.Template -like 'GROUP*')
    {
        $Site = Get-SPOSite -Identity $_.URL
        #Get Group Owners
        $GroupOwners = (Get-AzureADGroupOwner -ObjectId $Site.GroupID | Select-Object -ExpandProperty UserPrincipalName) -join "; "      
    }
    Else
    {
        $GroupOwners = $_.Owner
    }
    #Collect Data
    $SiteOwners += New-Object PSObject -Property @{
    'Site Title' = $_.Title
    'URL' = $_.Url
    'Owner(s)' = $GroupOwners
    }
}

#Get Site Owners
$SiteOwners | Format-Table -AutoSize
 
#Export Site Owners report to CSV
$SiteOwners | Export-Csv -Path $outputCsv -Encoding utf8 -NoTypeInformation
