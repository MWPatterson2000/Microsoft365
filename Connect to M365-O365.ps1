<#
    .SYNOPSIS
    This script will look at a M365/O365 Tenant and report on CIS Benchmarks
    
    .DESCRIPTION
    This will Connect to a M365/O365 Tenant
	Dependant PowerShell Modules
    	Dependent on MSOnline PowerShell Module
            Install-Module -Name MSOnline
    	Dependent on Azure AD PowerShell Preview Module
            Install-Module -Name AzureADPreview
    	Dependent on Exchange Online PowerShell Module
            Install-Module -Name ExchangeOnlineManagement
    	Dependent on SharePoint Online PowerShell Module
        	Install-Module -Name Microsoft.Online.SharePoint.PowerShell
        Dependent on SharePoint Patterns and Practices PowerShell Module - SharePointPnPPowerShell
            Install-Module -Name SharePointPnPPowerShellOnline
    	Dependent on Teams PowerShell Module
            Install-Module -Name MicrosoftTeams
        Dependent on MS Graph PowerShell Module(s)
            Install-Module -Name Microsoft.Graph
            Install-Module -Name Microsoft.Graph.Intune
            Install-Module -Name Microsoft.Graph.Teams
        Dependent on Security & Compliance Center PowerShell Module
            Install-Module -Name ExchangeOnlineManagement
    	Dependent on MCAS PowerShell Module, Instructions for Setting API Access up
            Install-Module -Name MCAS
            https://www.verboon.info/2019/05/exploring-microsoft-cloud-app-security-with-powershell-part1/
            https://docs.microsoft.com/en-us/cloud-app-security/api-authentication
        Dependent on MS Commerce PowerShell Module
            Install-Module -Name MSCommerce
        Dependent on Microsoft Power Apps PowerShell Module(s)
            Install-Module -Name Microsoft.PowerApps.Administration.PowerShell
            Install-Module -Name Microsoft.PowerApps.PowerShell -AllowClobber
        Dependent on X PowerShell Module

    Supported Tenants
        Commercial (Worldwide)
        GCC (Office 365 U.S. Government Commercial Cloud
        GCCH (Office 365 U.S. Government Commercial Cloud High
        DoD (Office 365 U.S. Government DoD) - IL5

    For This script to connect to SharePointOnline the Following must be set.
    Set-SPOTenant -LegacyAuthProtocolsEnabled $true # Default # CIS Control 1.4 Recommends to Disable this
    Set-SPOTenant -RequireAcceptingAccountMatchInvitedAccount $False # Default # CloudFit Control Recommends enabling this
    Recommended Settings
    Set-SPOTenant -LegacyAuthProtocolsEnabled $False # CIS Control 1.4 Recommends to Disable this
    Set-SPOTenant -RequireAcceptingAccountMatchInvitedAccount $True # CloudFit Control Recommends enabling this
    Get-SPOTenant | Format-Table LegacyAuthProtocolsEnabled, RequireAcceptingAccountMatchInvitedAccount

    .PARAMETER Parameter1
    [Description of parameter value/usage]
    
    .PARAMETER Parameter2
    [Description of parameter value/usage] 

    .PARAMETER Parameter3
    [Description of parameter value/usage]  
    
    .EXAMPLE
    <scriptName.ps1 -Parameter1 "Value1" -Parameter2 "Value2" -Parameter3 "Value3a,Value3b,Value3c"
#>
    
<#
    param(
    [Parameter(Position = 0, mandatory = $true)][string] $Parameter1,
    [Parameter(Position = 1, mandatory = $true)][string] $Parameter2,
    [Parameter(Position = 2, mandatory = $true)][string] $Parameter3
    )
#>

# Clear Screen
Clear-Host

#<#
# Get Authentiction Type
# Authentication Type
$select = 0
While ($select -lt 1 -or $select -gt 3) {
    Write-Host "`n`tSelect Microsoft 365 Authentication Type" -Fore Yellow
    Write-Host "`t 1`tNon MFA" -Fore Cyan
    Write-Host "`t 2`tMFA Required" -Fore Cyan
    Write-Host "`n`tExit" -Fore Yellow
    Write-Host "`t 3`tQuit" -Fore Cyan
    $select = Read-Host "`n`tEnter selection"

    if ($select -lt 1 -or $select -gt 3){
        Write-Host "`tPlease select one of the options available.`n" -Fore Red;start-Sleep -Seconds 1
    }
    If ($select -eq '1') {
        $mfaUsed = 'No' # Use if MFA is Not Used
    }
    If ($select -eq '2') {
        $mfaUsed = 'Yes' # Use if MFA is Used
    }
    If ($select -eq '3') {
        Exit
    }
}
#>

#<#
# Get Tenant Type
# Connection Type
$select = 0
While ($select -lt 1 -or $select -gt 5) {
    Write-Host "`n`tSelect Microsoft 365 Tenant Type" -Fore Yellow
    Write-Host "`t 1`tCommercial (Worldwide)" -Fore Cyan
    Write-Host "`t 2`tGCC (Office 365 U.S. Government Commercial Cloud)" -Fore Cyan
    Write-Host "`t 3`tGCCH (Office 365 U.S. Government Commercial Cloud High)" -Fore Cyan
    Write-Host "`t 4`tDoD (Office 365 U.S. Government DoD)" -Fore Cyan
    Write-Host "`n`tExit" -Fore Yellow
    Write-Host "`t 9`tQuit" -Fore Cyan
    $select = Read-Host "`n`tEnter selection"

    if ($select -lt 1 -or $select -gt 5){
        Write-Host "`tPlease select one of the options available.`n" -Fore Red;start-Sleep -Seconds 1
    }
    If ($select -eq '1') {
        $TenantType = "Commercial" # Commercial
    }
    If ($select -eq '2') {
        $TenantType = "GCC" # Office 365 U.S. Government Commercial Cloud
    }
    If ($select -eq '3') {
        $TenantType = "GCCH" # Office 365 U.S. Government Commercial Cloud High
    }
    If ($select -eq '4') {
        $TenantType = "DoD" # Office 365 U.S. Government DoD
    }
    If ($select -eq '5') {
        Exit
    }
}
#>
Write-Host "`n`n`n"
<#
# Define Variables
#$mfaUsed = 'Yes' # Use if MFA is Used
$mfaUsed = 'No' # Use if MFA is Not Used
# Select Tenant Type
    $TenantType = "Commercial" # Commercial
    #$TenantType = "GCC" # Office 365 U.S. Government Commercial Cloud
    #$TenantType = "GCCH" # Office 365 U.S. Government Commercial Cloud High
    #$TenantType = "DoD" # Office 365 U.S. Government DoD 
#>

#<#
# Get Credential
If ($mfaUsed -eq 'No') {
    #Write-Host "Enter Microsoft 365 Credentials" -ForegroundColor Red
    Write-Host "Enter Microsoft 365 Credentials"
    #$cred = Get-Credential
    #Write-Host "Enter Microsoft 365 Username"
    $upn = Read-Host "Enter Microsoft 365 Username"
    $cred = Get-Credential -UserName $upn -Message "Enter Password for $upn"
    #$username = "admin@contoso.sharepoint.com"
    #$password = "password"
    #$username = Read-Host "Microsoft 365 UserName"
    #$password = Read-Host "$username password"
    #$cred = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $userName, $(convertto-securestring $Password -asplaintext -force)
}
If ($mfaUsed -eq 'Yes') {
    #Write-Host "Enter Microsoft 365 Credentials"
    #$cred = Get-Credential
    #Write-Host "Enter Microsoft 365 Username"
    #$upn = Read-Host "Enter Microsoft 365 Username"
    #$username = "admin@contoso.sharepoint.com"
    #$password = "password"
    #$username = Read-Host "Microsoft 365 UserName"
    #$password = Read-Host "$username password"
    #$cred = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $userName, $(convertto-securestring $Password -asplaintext -force)
}
#>

# Connect to O365 Needed for Variable creations
If ($mfaUsed -eq 'No') {
    Write-Host "Connecting to MSOL"
    #Connect-MsolService -Credential $cred
    If ($TenantType -eq "Commercial") {Connect-MsolService -Credential $cred}
    If ($TenantType -eq "GCC") {Connect-MsolService -Credential $cred}
    #If ($TenantType -eq "GCCH") {Connect-MsolService -Credential $cred -AzureEnvironment USGovernment}
    #If ($TenantType -eq "DoD") {Connect-MsolService -Credential $cred -AzureEnvironment USGovernment}
    If ($TenantType -eq "GCCH") {Connect-MsolService -Credential $cred -AzureEnvironment AzureUSGovernmentCloud}
    If ($TenantType -eq "DoD") {Connect-MsolService -Credential $cred -AzureEnvironment AzureUSGovernmentCloud}
}
Else {
    Write-Host "Connecting to MSOL - MFA"
    #Connect-MsolService
    If ($TenantType -eq "Commercial") {Connect-MsolService}
    If ($TenantType -eq "GCC") {Connect-MsolService}
    #If ($TenantType -eq "GCCH") {Connect-MsolService -AzureEnvironment USGovernment}
    #If ($TenantType -eq "DoD") {Connect-MsolService -AzureEnvironment USGovernment}
    If ($TenantType -eq "GCCH") {Connect-MsolService -AzureEnvironment AzureUSGovernmentCloud}
    If ($TenantType -eq "DoD") {Connect-MsolService -AzureEnvironment AzureUSGovernmentCloud}
}

# Define Variables 2
    #$TenantName = '' # Your Tanant Name - (Get-MsolDomain | Where-Object {$_.isInitial}).name
    $TenantName = (Get-MsolDomain | Where-Object {$_.isInitial}).name
    $TenantSName = $TenantName.Substring(0,$TenantName.IndexOf('.'))
    $sharePTURL = "https://$TenantSName-admin.sharepoint.com"
    #$TenantID = 'YourTenant ObjectID' # Microsoft 365 Tenant ID
    $TenantID = (Get-MsolCompanyInformation).ObjectId
    #$msolDomainName = '<Tanant>.onmicrosoft.com' # Microsoft 365 Tenant
    $msolDomainName = (Get-MsolCompanyInformation).InitialDomain #'<Tanant>.onmicrosoft.com' # Microsoft 365 Tenant
    $MCASToken = 'QhwZGlcYGRgYHRkBWlwcAV9AXVtOQwFMQ0BaS05fX1xKTFpdRltWAUxAQlMZGxhMG0lLTUtMHx9KTB9OSxYXH05JTR4WGEkeThdKHhoYFxkXHRZJHUtKFkxKHxwfHxYYTUsaThhNGhlLHkse' # Token from MCAS Setup
    #$MCASToken = ''  # Token from MCAS Setup
    $MCASUrl = 'm365x767726.us3.portal.cloudappsecurity.com' # URL from MCAS Setup minus https
    #$MCASUrl = '' # URL from MCAS Setup minus https

#<#
# Connect to Other Services
# Connect to AzureAD
If ($mfaUsed -eq 'No') {
    Write-Host "Connecting to Azure AD"
    #Connect-AzureAD -Credential $cred # Use if MFA is Not Used
    If ($TenantType -eq "Commercial") {Connect-AzureAD -Credential $cred}
    If ($TenantType -eq "GCC") {Connect-AzureAD -Credential $credd}
    If ($TenantType -eq "GCCH") {Connect-AzureAD -Credential $cred -AzureEnvironmentName AzureUSGovernment}
    If ($TenantType -eq "DoD") {Connect-AzureAD -Credential $cred -AzureEnvironmentName AzureUSGovernment}
}
Else {
    Write-Host "Connecting to Azure AD - MFA"
    #Connect-AzureAD # Use if MFA is Used
    If ($TenantType -eq "Commercial") {Connect-AzureAD}
    If ($TenantType -eq "GCC") {Connect-AzureAD}
    If ($TenantType -eq "GCCH") {Connect-AzureAD -AzureEnvironmentName AzureUSGovernment}
    If ($TenantType -eq "DoD") {Connect-AzureAD -AzureEnvironmentName AzureUSGovernment}
}

# Connect to Microsoft Exchange Online
If ($mfaUsed -eq 'No') {
    Write-Host "Connecting to Exchange Online"
    #Connect-ExchangeOnline -Credential $cred # Use if MFA is Not Used
    If ($TenantType -eq "Commercial") {Connect-ExchangeOnline -Credential $cred}
    If ($TenantType -eq "GCC") {Connect-ExchangeOnline -Credential $cred}
    If ($TenantType -eq "GCCH") {Connect-ExchangeOnline -Credential $cred -ExchangeEnvironmentName O365USGovGCCHigh}
    If ($TenantType -eq "DoD") {Connect-ExchangeOnline -Credential $cred -ExchangeEnvironmentName O365USGovDoD}
}
Else {
    Write-Host "Connecting to Exchange Online - MFA"
    #Connect-ExchangeOnline # Use if MFA is used
    If ($TenantType -eq "Commercial") {Connect-ExchangeOnline}
    If ($TenantType -eq "GCC") {Connect-ExchangeOnline}
    If ($TenantType -eq "GCCH") {Connect-ExchangeOnline -ExchangeEnvironmentName O365USGovGCCHigh}
    If ($TenantType -eq "DoD") {Connect-ExchangeOnline -ExchangeEnvironmentName O365USGovDoD}
    #If ($TenantType -eq "Commercial") {Connect-ExchangeOnline -UserPrincipalName $upn}
    #If ($TenantType -eq "GCC") {Connect-ExchangeOnline -UserPrincipalName $upn}
    #If ($TenantType -eq "GCCH") {Connect-ExchangeOnline -UserPrincipalName $upn -ExchangeEnvironmentName O365USGovGCCHigh}
    #If ($TenantType -eq "DoD") {Connect-ExchangeOnline -UserPrincipalName $upn -ExchangeEnvironmentName O365USGovDoD}
}

# Connect to Security & Compliance Center
If ($mfaUsed -eq 'No') {
    Write-Host "Connecting to Security & Compliance Center"
    #Connect-IPPSSession -Credential $cred # Use if MFA is Not Used
    If ($TenantType -eq "Commercial") {Connect-IPPSSession -Credential $cred}
    If ($TenantType -eq "GCC") {Connect-IPPSSession -Credential $cred}
    <# # Do Not use
    If ($TenantType -eq "GCCH") {Connect-IPPSSession -Credential $cred -ConnectionUri https://ps.compliance.protection.office365.us/powershell-liveid/}
    If ($TenantType -eq "DoD") {Connect-IPPSSession -Credential $cred -ConnectionUri https://l5.ps.compliance.protection.office365.us/powershell-liveid/}
    If ($TenantType -eq "GCCH") {Connect-IPPSSession -Credential $cred -AzureADAuthorizationEndpointUri https://login.microsoftonline.us/common -ConnectionUri https://ps.compliance.protection.office365.us/powershell-liveid/}
    If ($TenantType -eq "DoD") {Connect-IPPSSession -Credential $cred -AzureADAuthorizationEndpointUri https://login.microsoftonline.us/common -ConnectionUri https://l5.ps.compliance.protection.office365.us/powershell-liveid/}
    If ($TenantType -eq "GCCH") {Connect-IPPSSession -Credential $cred -UserPrincipalName $upn -ConnectionUri https://ps.compliance.protection.office365.us/powershell-liveid/}
    If ($TenantType -eq "DoD") {Connect-IPPSSession -Credential $cred -UserPrincipalName $upn -ConnectionUri https://l5.ps.compliance.protection.office365.us/powershell-liveid/}
    #>
    <# # Do Not use
    If ($TenantType -eq "GCCH") {Connect-IPPSSession -UserPrincipalName $upn -ConnectionUri https://ps.compliance.protection.office365.us/powershell-liveid/}
    If ($TenantType -eq "DoD") {Connect-IPPSSession -UserPrincipalName $upn -ConnectionUri https://l5.ps.compliance.protection.office365.us/powershell-liveid/}
    #>
    #<#
    If ($TenantType -eq "GCCH") {Connect-IPPSSession -Credential $cred -ConnectionUri https://ps.compliance.protection.office365.us/powershell-liveid/ -AzureADAuthorizationEndpointUri https://login.microsoftonline.us/common}
    If ($TenantType -eq "DoD") {Connect-IPPSSession -Credential $cred -ConnectionUri https://l5.ps.compliance.protection.office365.us/powershell-liveid/ -AzureADAuthorizationEndpointUri https://login.microsoftonline.us/common}
    #>
    <#
    If ($TenantType -eq "GCCH") {Connect-IPPSSession -UserPrincipalName $upn -ConnectionUri https://ps.compliance.protection.office365.us/powershell-liveid/ -AzureADAuthorizationEndpointUri https://login.microsoftonline.us/common}
    If ($TenantType -eq "DoD") {Connect-IPPSSession -UserPrincipalName $upn -ConnectionUri https://l5.ps.compliance.protection.office365.us/powershell-liveid/ -AzureADAuthorizationEndpointUri https://login.microsoftonline.us/common}
    #>
}
Else {
    Write-Host "Connecting to Security & Compliance Center - MFA"
    #Connect-IPPSSession # Use if MFA is Used
    If ($TenantType -eq "Commercial") {Connect-IPPSSession}
    If ($TenantType -eq "GCC") {Connect-IPPSSession}
    If ($TenantType -eq "GCCH") {Connect-IPPSSession -ConnectionUri https://ps.compliance.protection.office365.us/powershell-liveid/}
    If ($TenantType -eq "DoD") {Connect-IPPSSession -ConnectionUri https://l5.ps.compliance.protection.office365.us/powershell-liveid/}
    #If ($TenantType -eq "GCCH") {Connect-IPPSSession UserPrincipalName -ConnectionUri https://ps.compliance.protection.office365.us/powershell-liveid/}
    #If ($TenantType -eq "DoD") {Connect-IPPSSession UserPrincipalName -ConnectionUri https://l5.ps.compliance.protection.office365.us/powershell-liveid/}
}

# Connect to SharePoint Online
# Build Connection String
#$TenantName = (Get-MsolDomain | Where-Object {$_.isInitial}).name
#$TenantSName = $TenantName.Substring(0,$TenantName.IndexOf('.'))
#$sharePTURL = "https://$TenantSName-admin.sharepoint.com"
# Connect to SharePoint Online
If ($TenantType -eq "Commercial") {$sharePTURL = "https://$TenantSName-admin.sharepoint.com"}
If ($TenantType -eq "GCC") {$sharePTURL = "https://$TenantSName-admin.sharepoint.com"}
If ($TenantType -eq "GCCH") {$sharePTURL = "https://$TenantSName-admin.sharepoint.us"}
#If ($TenantType -eq "DoD") {$sharePTURL = "https://$TenantSName-admin.sharepoint.us"}
#If ($TenantType -eq "DoD") {$sharePTURL = "https://$TenantSName-admin.dps.mil"}
If ($TenantType -eq "DoD") {$sharePTURL = "https://$TenantSName-admin.sharepoint-mil.us"}
If ($mfaUsed -eq 'No') {
    Write-Host "Connecting to SharePoint Online"
    #Connect-SPOService -Url https://<Tenant>-admin.sharepoint.com -Credential $cred
    #Connect-SPOService -Url https://yourdomainname-admin.sharepoint.com -Credential $cred
    Connect-SPOService -Url $sharePTURL # Use if MFA is Not Used
    #Connect-SPOService -Url $sharePTURL -Credential $upn # Use if MFA is Not Used
    #Connect-SPOService -Url $sharePTURL -Credential $cred # Use if MFA is Not Used
}
Else {
    Write-Host "Connecting to SharePoint Online - MFA"
    #Connect-SPOService -Url https://<Tenant>-admin.sharepoint.com
    #Connect-SPOService -Url https://yourdomainname-admin.sharepoint.com
    Connect-SPOService -Url $sharePTURL # Use if MFA is Used
}

# Connect to Microsoft Teams
If ($mfaUsed -eq 'No') {
    Write-Host "Connecting to Microsoft Teams"
    #Connect-MicrosoftTeams -Credential $cred # Use if MFA is Not Used
    If ($TenantType -eq "Commercial") {Connect-MicrosoftTeams -Credential $cred}
    If ($TenantType -eq "GCC") {Connect-MicrosoftTeams -Credential $cred}
    If ($TenantType -eq "GCCH") {Connect-MicrosoftTeams -Credential $cred -TeamsEnvironmentName TeamsGCCH}
    If ($TenantType -eq "DoD") {Connect-MicrosoftTeams -Credential $cred -TeamsEnvironmentName TeamsDOD}
}
Else {
    Write-Host "Connecting to Microsoft Teams - MFA"
    #Connect-MicrosoftTeams # Use if MFA is Used
    If ($TenantType -eq "Commercial") {Connect-MicrosoftTeams}
    If ($TenantType -eq "GCC") {Connect-MicrosoftTeams}
    If ($TenantType -eq "GCCH") {Connect-MicrosoftTeams -TeamsEnvironmentName TeamsGCCH}
    If ($TenantType -eq "DoD") {Connect-MicrosoftTeams -TeamsEnvironmentName TeamsDOD}
}

# Connect to Microsoft Graph
Update-MSGraphEnvironment -AuthUrl https://login.microsoftonline.com/common -GraphBaseUrl https://graph.microsoft.com -GraphResourceId https://graph.microsoft.com -Quiet
If ($TenantType -eq "Commercial") {Update-MSGraphEnvironment -AuthUrl https://login.microsoftonline.com/common -GraphBaseUrl https://graph.microsoft.com -GraphResourceId https://graph.microsoft.com}
If ($TenantType -eq "GCC") {Update-MSGraphEnvironment -AuthUrl https://login.microsoftonline.com/common -GraphBaseUrl https://graph.microsoft.com -GraphResourceId https://graph.microsoft.com}
#If ($TenantType -eq "GCCH") {Update-MSGraphEnvironment -AuthUrl https://portal.azure.us -GraphBaseUrl https://graph.microsoft.us -GraphResourceId https://graph.microsoft.us}
#If ($TenantType -eq "GCCH") {Update-MSGraphEnvironment -AuthUrl https://login.microsoftonline.com/common -GraphBaseUrl https://graph.microsoft.us -GraphResourceId https://graph.microsoft.us}
If ($TenantType -eq "GCCH") {Update-MSGraphEnvironment -AuthUrl https://login.microsoftonline.us/common -GraphBaseUrl https://graph.microsoft.us -GraphResourceId https://graph.microsoft.us}
#If ($TenantType -eq "DoD") {Update-MSGraphEnvironment -AuthUrl https://portal.azure.us -GraphBaseUrl https://dod-graph.microsoft.us -GraphResourceId https://dod-graph.microsoft.us}
#If ($TenantType -eq "DoD") {Update-MSGraphEnvironment -AuthUrl https://login.microsoftonline.com/common -GraphBaseUrl https://dod-graph.microsoft.us -GraphResourceId https://dod-graph.microsoft.us}
If ($TenantType -eq "DoD") {Update-MSGraphEnvironment -AuthUrl https://login.microsoftonline.us/common -GraphBaseUrl https://dod-graph.microsoft.us -GraphResourceId https://dod-graph.microsoft.us}
If ($mfaUsed -eq 'No') {
    Write-Host "Connecting to Microsoft Graph"
    Connect-MSGraph -Credential $cred # Use if MFA is Not Used
}
Else {
    Write-Host "Connecting to Microsoft Graph - MFA"
    Connect-MSGraph # Use if MFA is Used
}
#>

#<#
# Set the MCAS Credential Variable
#$MCASToken = 'QhwZGlcYGRgYHRkBWlwcAV9AXVtOQwFMQ0BaS05fX1xKTFpdRltWAUxAQlMZGxhMG0lLTUtMHx9KTB9OSxYXH05JTR4WGEkeThdKHhoYFxkXHRZJHUtKFkxKHxwfHxYYTUsaThhNGhlLHkse' # Token from MCAS Setup
#$MCASToken = ''  # Token from MCAS Setup
#$MCASUrl = 'm365x767726.us3.portal.cloudappsecurity.com' # URL from MCAS Setup minus https
#$MCASUrl = '' # URL from MCAS Setup minus https
$MCASUser=$MCASUrl
$MCASPWord=ConvertTo-SecureString -String "$MCASToken" -AsPlainText -Force
$CASCredential=New-Object -TypeName System.Management.Automation.PSCredential -argumentList $MCASUser, $MCASPWord
$Credential=$CASCredential
#>

<#
# Can not Connect with stored Credentials
# Need GA Access to view Settings
# Connect to Microsoft Commerce
If ($mfaUsed -eq 'No') {
    Write-Host "Connecting to Microsoft Commerce"
    Connect-MSCommerce # -Credential $cred # Use if MFA is Not Used
    #If ($TenantType -eq "Commercial") {Connect-MSCommerce -Credential $cred}
    #If ($TenantType -eq "GCC") {Connect-MSCommerce -Credential $cred}
    #If ($TenantType -eq "GCCH") {Connect-MSCommerce -Credential $cred}
    #If ($TenantType -eq "DoD") {Connect-MSCommerce -Credential $cred}
}
Else {
    Write-Host "Connecting to Microsoft Commerce - MFA"
    Connect-MSCommerce # Use if MFA is Used
    #If ($TenantType -eq "Commercial") {Connect-MSCommerce}
    #If ($TenantType -eq "GCC") {Connect-MSCommerce}
    #If ($TenantType -eq "GCCH") {Connect-MSCommerce}
    #If ($TenantType -eq "DoD") {Connect-MSCommerce}
}
#>

#<#
# Connect to Microsoft Power Apps
If ($mfaUsed -eq 'No') {
    Write-Host "Connecting to Microsoft Power Apps"
    If ($TenantType -eq "Commercial") {Add-PowerAppsAccount -Username $cred.GetNetworkCredential().UserName -Password $cred.GetNetworkCredential().SecurePassword}
    If ($TenantType -eq "GCC") {Add-PowerAppsAccount -Endpoint usgov -Username $cred.GetNetworkCredential().UserName -Password $cred.GetNetworkCredential().SecurePassword}
    If ($TenantType -eq "GCCH") {Add-PowerAppsAccount -Endpoint usgovhigh -Username $cred.GetNetworkCredential().UserName -Password $cred.GetNetworkCredential().SecurePassword}
    If ($TenantType -eq "DoD") {Add-PowerAppsAccount -Endpoint dod -Username $cred.GetNetworkCredential().UserName -Password $cred.GetNetworkCredential().SecurePassword}
}
Else {
    Write-Host "Connecting to Microsoft Power Apps - MFA"
    If ($TenantType -eq "Commercial") {Add-PowerAppsAccount}
    If ($TenantType -eq "GCC") {Add-PowerAppsAccount -Endpoint usgov}
    If ($TenantType -eq "GCCH") {Add-PowerAppsAccount -Endpoint usgovhigh}
    If ($TenantType -eq "DoD") {Add-PowerAppsAccount -Endpoint dod}
}
#>
<#
# Connect to 
If ($mfaUsed -eq 'No') {
    # Use if MFA is Not Used
}
Else {
    # Use if MFA is Used
}
#>

<#
# Connect to O365
#Connect-MsolService
# Connect to Azure AD
#Connect-AzureAD
# Connect to Microsoft Exchange Online
#Connect-ExchangeOnline -UserPrincipalName <User>@<Tenant>.onmicrosoft.com
# Connect to Security & Compliance Center
#Connect-IPPSSession -UserPrincipalName <User>@<Tenant>.onmicrosoft.com
# Connect to SharePoint Online
#Connect-SPOService -Url https://<Tenant>-admin.sharepoint.com
#Connect-SPOService -Url $sharePTURL
# Connect to Microsoft Teams
#Connect-MicrosoftTeams
# Connect to Microsoft Graph
#Connect-MSGraph
# Connect to Intune
#Connect-MSGraph
#>