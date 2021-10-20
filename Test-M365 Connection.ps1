<#
    .SYNOPSIS
    This script will test Connectivity at a M365/O365 Tenant and report on the status
    
    .DESCRIPTION
    This will test Connectivity to a M365/O365 Tenant
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
        Dependent on MS Graph PowerShell Module
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
        Dependent on X PowerShell Module
    
    
    .EXAMPLE
    Test-M365 Connection.ps1
    #>
    
# Test MSOL Connectivity
#Connect-MsolService
$temp = Get-MsolDomain -ErrorAction SilentlyContinue

if($?) {
	Write-Host "You're connected to MSOL"
}
else {
	Write-Host "You're not connected to MSOL"
}


# Test Azure AD Connectivity
#Connect-AzureAD 
$temp = Get-AzureADTenantDetail -ErrorAction SilentlyContinue

if($?) {
	Write-Host "You're connected to Azure AD"
}
else {
	Write-Host "You're not connected to Azure AD"
}


# Test Microsoft Exchange Online Connectivity
#Connect-ExchangeOnline
$temp = Get-OrganizationConfig -ErrorAction SilentlyContinue

if($?) {
	Write-Host "You're connected to Microsoft Exchange Online"
}
else {
	Write-Host "You're not connected to Microsoft Exchange Online"
}


# Test Security & Compliance Center Connectivity
#Connect-IPPSSession
$temp = Get-ProtectionAlert -ErrorAction SilentlyContinue

if($?) {
	Write-Host "You're connected to Security & Compliance Center"
}
else {
	Write-Host "You're not connected to Security & Compliance Center"
}


# Test SharePoint Online Connectivity
#Connect-SPOService
$temp = Get-SPOTenant -ErrorAction SilentlyContinue

if($?) {
	Write-Host "You're connected to SharePoint Online"
}
else {
	Write-Host "You're not connected to SharePoint Online"
}


# Test Microsoft Teams Connectivity
#Connect-MicrosoftTeams
$temp = Get-CsOAuthConfiguration -ErrorAction SilentlyContinue

if($?) {
	Write-Host "You're connected to Microsoft Teams"
}
else {
	Write-Host "You're not connected to Microsoft Teams"
}


# Test Microsoft Graph Connectivity
# Connect-MSGraph
$temp = Get-IntuneDeviceCompliancePolicy -ErrorAction SilentlyContinue

if($?) {
	Write-Host "You're connected to Microsoft Graph"
}
else {
	Write-Host "You're not connected to Microsoft Graph"
}


# Test MCAS Connectivity
<#
$temp = Get-MsolDomain -ErrorAction SilentlyContinue

if($?) {
	Write-Host "You're  connected to MSOL"
}
else {
	Write-Host "You're not connected to MSOL"
}
#>


# Test Microsoft Commerce Connectivity
#Connect-MSCommerce
<#
$temp = Get-MSCommerceProductPolicies -ErrorAction SilentlyContinue

if($?) {
	Write-Host "You're  connected to MSOL"
}
else {
	Write-Host "You're not connected to MSOL"
}
#>


