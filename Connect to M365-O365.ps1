<#
    .SYNOPSIS
    This script will connect to all M365/O365 Services in a Tenant
    
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
        Dependent on Microsoft Power BI PowerShell Module(s)
            Install-Module -Name MicrosoftPowerBIMgmt
        Dependent on X PowerShell Module

    Supported Tenants
        Commercial (Worldwide)
        GCC (Office 365 U.S. Government Commercial Cloud
        GCCH (Office 365 U.S. Government Commercial Cloud High
        DoD (Office 365 U.S. Government DoD) - IL5
        Germany (Germany)

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

# Get OS Version
function Get-OSVersion ($Name = '*') {
    $OSInfo = Get-WmiObject Win32_OperatingSystem | Select-Object *
    If (($OSInfo).Caption -like '*Microsoft Windows*') {
        Write-Host "You are using a Microsft Windows System, All tests will work correctly" #-ForegroundColor Yellow
        #$OSInfo | Select-Object PSComputerName, Caption, OSArchitecture, Version, BuildNumber | Format-List
        $Linux = 'No'
    }
    Else {
        $Linux = 'Yes'
        Write-Host "You are using a Linux System, All tests will work correctly"
        <#
        Pause
        Get-UserVariable | Remove-Variable -ErrorAction SilentlyContinue -ForegroundColor Yellow
        Break
        #>
    }
}

# Connect to O365 Needed for Variable creations
function Connect-ServiceMSOL {
    If ($Linux -eq 'No') {
        try {
            If ($mfaUsed -eq 'No') {
                Write-Host "Connecting to MSOL"
                #Connect-MsolService -Credential $cred
                If ($TenantType -eq "Commercial") {Connect-MsolService -Credential $cred -ErrorAction Stop}
                If ($TenantType -eq "GCC") {Connect-MsolService -Credential $cred -ErrorAction Stop}
                #If ($TenantType -eq "GCCH") {Connect-MsolService -Credential $cred -AzureEnvironment USGovernment -ErrorAction Stop}
                #If ($TenantType -eq "DoD") {Connect-MsolService -Credential $cred -AzureEnvironment USGovernment -ErrorAction Stop}
                If ($TenantType -eq "GCCH") {Connect-MsolService -Credential $cred -AzureEnvironment AzureUSGovernmentCloud -ErrorAction Stop}
                If ($TenantType -eq "DoD") {Connect-MsolService -Credential $cred -AzureEnvironment AzureUSGovernmentCloud -ErrorAction Stop}
                If ($TenantType -eq "Germany") {Connect-MsolService -Credential $cred -AzureEnvironment AzureGermanyCloud -ErrorAction Stop}
            }
            Else {
                Write-Host "Connecting to MSOL - MFA"
                #Connect-MsolService
                If ($TenantType -eq "Commercial") {Connect-MsolService -ErrorAction Stop}
                If ($TenantType -eq "GCC") {Connect-MsolService -ErrorAction Stop}
                #If ($TenantType -eq "GCCH") {Connect-MsolService -AzureEnvironment USGovernment -ErrorAction Stop}
                #If ($TenantType -eq "DoD") {Connect-MsolService -AzureEnvironment USGovernment -ErrorAction Stop}
                If ($TenantType -eq "GCCH") {Connect-MsolService -AzureEnvironment AzureUSGovernmentCloud -ErrorAction Stop}
                If ($TenantType -eq "DoD") {Connect-MsolService -AzureEnvironment AzureUSGovernmentCloud -ErrorAction Stop}
                If ($TenantType -eq "Germany") {Connect-MsolService -AzureEnvironment AzureGermanyCloud -ErrorAction Stop}
            }
        }
		catch {
			$errorMessage = $_.Exception.Message
			Write-Host $errormessage
			"Connect MSOL Fail"
			break
		}
    }
}

# Connect to AzureAD
function Connect-ServiceAAD {
    If ($Linux -eq 'No') {
        try {
            If ($mfaUsed -eq 'No') {
                Write-Host "Connecting to Azure AD"
                #Connect-AzureAD -Credential $cred # Use if MFA is Not Used
                If ($TenantType -eq "Commercial") {Connect-AzureAD -Credential $cred -ErrorAction Stop}
                If ($TenantType -eq "GCC") {Connect-AzureAD -Credential $cred -ErrorAction Stop}
                If ($TenantType -eq "GCCH") {Connect-AzureAD -Credential $cred -AzureEnvironmentName AzureUSGovernment -ErrorAction Stop}
                If ($TenantType -eq "DoD") {Connect-AzureAD -Credential $cred -AzureEnvironmentName AzureUSGovernment -ErrorAction Stop}
                If ($TenantType -eq "Germany") {Connect-AzureAD -Credential $cred -AzureEnvironmentName AzureGermanyCloud -ErrorAction Stop}
            }
            Else {
                Write-Host "Connecting to Azure AD - MFA"
                #Connect-AzureAD # Use if MFA is Used
                If ($TenantType -eq "Commercial") {Connect-AzureAD -ErrorAction Stop}
                If ($TenantType -eq "GCC") {Connect-AzureAD -ErrorAction Stop}
                If ($TenantType -eq "GCCH") {Connect-AzureAD -AzureEnvironmentName AzureUSGovernment -ErrorAction Stop}
                If ($TenantType -eq "DoD") {Connect-AzureAD -AzureEnvironmentName AzureUSGovernment -ErrorAction Stop}
                If ($TenantType -eq "Germany") {Connect-AzureAD -AzureEnvironmentName AzureGermanyCloud -ErrorAction Stop}
            }
        }
		catch {
			$errorMessage = $_.Exception.Message
			Write-Host $errormessage
			"Connect Azure AD Fail"
			break
		}
    }
}

# Connect to Microsoft Exchange Online
function Connect-ServiceEXO {
    If ($Linux -eq 'No') {
        try {
            If ($mfaUsed -eq 'No') {
                Write-Host "Connecting to Exchange Online"
                #Connect-ExchangeOnline -Credential $cred # Use if MFA is Not Used
                If ($TenantType -eq "Commercial") {Connect-ExchangeOnline -Credential $cred -ErrorAction Stop}
                If ($TenantType -eq "GCC") {Connect-ExchangeOnline -Credential $cred -ErrorAction Stop}
                If ($TenantType -eq "GCCH") {Connect-ExchangeOnline -Credential $cred -ExchangeEnvironmentName O365USGovGCCHigh -ErrorAction Stop}
                If ($TenantType -eq "DoD") {Connect-ExchangeOnline -Credential $cred -ExchangeEnvironmentName O365USGovDoD -ErrorAction Stop}
                If ($TenantType -eq "Germany") {Connect-ExchangeOnline -Credential $cred -ExchangeEnvironmentName O365GermanyCloud -ErrorAction Stop}
            }
            Else {
                Write-Host "Connecting to Exchange Online - MFA"
                #Connect-ExchangeOnline # Use if MFA is used
                If ($TenantType -eq "Commercial") {Connect-ExchangeOnline -ErrorAction Stop}
                If ($TenantType -eq "GCC") {Connect-ExchangeOnline -ErrorAction Stop}
                If ($TenantType -eq "GCCH") {Connect-ExchangeOnline -ExchangeEnvironmentName O365USGovGCCHigh -ErrorAction Stop}
                If ($TenantType -eq "DoD") {Connect-ExchangeOnline -ExchangeEnvironmentName O365USGovDoD -ErrorAction Stop}
                If ($TenantType -eq "Germany") {Connect-ExchangeOnline -ExchangeEnvironmentName O365GermanyCloud -ErrorAction Stop}
            }
        }
		catch {
			$errorMessage = $_.Exception.Message
			Write-Host $errormessage
			"Connect Exchange Online Fail"
			break
		}
    }
}

# Connect to Security & Compliance Center
function Connect-ServiceSCC {
    If ($Linux -eq 'No') {
        If ($mfaUsed -eq 'No') {
            Write-Host "Connecting to Security & Compliance Center"
            #Connect-IPPSSession -Credential $cred # Use if MFA is Not Used
            If ($TenantType -eq "Commercial") {Connect-IPPSSession -Credential $cred -ErrorAction Stop}
            If ($TenantType -eq "GCC") {Connect-IPPSSession -Credential $cred -ErrorAction Stop}
            If ($TenantType -eq "GCCH") {Connect-IPPSSession -Credential $cred -ConnectionUri https://ps.compliance.protection.office365.us/powershell-liveid/ -ErrorAction Stop}
            If ($TenantType -eq "DoD") {Connect-IPPSSession -Credential $cred -ConnectionUri https://l5.ps.compliance.protection.office365.us/powershell-liveid/ -ErrorAction Stop}
            If ($TenantType -eq "Germany") {Connect-IPPSSession -Credential $cred -ConnectionUri https://ps.compliance.protection.outlook.de/PowerShell-LiveID -ErrorAction Stop}
        }
        Else {
            Write-Host "Connecting to Security & Compliance Center - MFA"
            #Connect-IPPSSession # Use if MFA is Used
            If ($TenantType -eq "Commercial") {Connect-IPPSSession -ErrorAction Stop}
            If ($TenantType -eq "GCC") {Connect-IPPSSession -ErrorAction Stop}
            If ($TenantType -eq "GCCH") {Connect-IPPSSession -ConnectionUri https://ps.compliance.protection.office365.us/powershell-liveid/ -ErrorAction Stop}
            If ($TenantType -eq "DoD") {Connect-IPPSSession -ConnectionUri https://l5.ps.compliance.protection.office365.us/powershell-liveid/ -ErrorAction Stop}
            If ($TenantType -eq "Germany") {Connect-IPPSSession -ConnectionUri https://ps.compliance.protection.outlook.de/PowerShell-LiveID/ -ErrorAction Stop}
        }
    }
}

# Connect to SharePoint Online
function Connect-ServiceSPO {
    If ($Linux -eq 'No') {
        # Build Connection String
        $TenantName = (Get-MsolDomain | Where-Object {$_.isInitial}).name
        $TenantSName = $TenantName.Substring(0,$TenantName.IndexOf('.'))
        $sharePTURL = "https://$TenantSName-admin.sharepoint.com"
        # Connect to SharePoint Online
        If ($TenantType -eq "Commercial") {$sharePTURL = "https://$TenantSName-admin.sharepoint.com"}
        If ($TenantType -eq "GCC") {$sharePTURL = "https://$TenantSName-admin.sharepoint.com"}
        If ($TenantType -eq "GCCH") {$sharePTURL = "https://$TenantSName-admin.sharepoint.us"}
        #If ($TenantType -eq "DoD") {$sharePTURL = "https://$TenantSName-admin.sharepoint.us"}
        #If ($TenantType -eq "DoD") {$sharePTURL = "https://$TenantSName-admin.dps.mil"}
        If ($TenantType -eq "DoD") {$sharePTURL = "https://$TenantSName-admin.sharepoint-mil.us"}
        If ($TenantType -eq "Germany") {$sharePTURL = "https://$TenantSName-admin.sharepoint.com"}
        try {
            If ($mfaUsed -eq 'No') {
                Write-Host "Connecting to SharePoint Online"
                Connect-SPOService -Url $sharePTURL -Credential $cred -ErrorAction Stop # Use if MFA is Not Used
            }
            Else {
                Write-Host "Connecting to SharePoint Online - MFA"
                Connect-SPOService -Url $sharePTURL -ErrorAction Stop # Use if MFA is Used
            }
        }
		catch {
			$errorMessage = $_.Exception.Message
			Write-Host $errormessage
			"Connect SharePoint Online Fail"
			break
		}

    }
}

# Connect to Microsoft Teams
function Connect-ServiceMSTeams {
    try {
        If ($mfaUsed -eq 'No') {
            Write-Host "Connecting to Microsoft Teams"
            #Connect-MicrosoftTeams -Credential $cred # Use if MFA is Not Used
            If ($TenantType -eq "Commercial") {Connect-MicrosoftTeams -Credential $cred -ErrorAction Stop}
            If ($TenantType -eq "GCC") {Connect-MicrosoftTeams -Credential $cred -ErrorAction Stop}
            If ($TenantType -eq "GCCH") {Connect-MicrosoftTeams -Credential $cred -TeamsEnvironmentName TeamsGCCH -ErrorAction Stop}
            If ($TenantType -eq "DoD") {Connect-MicrosoftTeams -Credential $cred -TeamsEnvironmentName TeamsDOD -ErrorAction Stop}
            If ($TenantType -eq "Germany") {Connect-MicrosoftTeams -Credential $cred -ErrorAction Stop}
        }
        Else {
            Write-Host "Connecting to Microsoft Teams - MFA"
            #Connect-MicrosoftTeams # Use if MFA is Used
            If ($TenantType -eq "Commercial") {Connect-MicrosoftTeams -ErrorAction Stop}
            If ($TenantType -eq "GCC") {Connect-MicrosoftTeams -ErrorAction Stop}
            If ($TenantType -eq "GCCH") {Connect-MicrosoftTeams -TeamsEnvironmentName TeamsGCCH -ErrorAction Stop}
            If ($TenantType -eq "DoD") {Connect-MicrosoftTeams -TeamsEnvironmentName TeamsDOD -ErrorAction Stop}
            If ($TenantType -eq "Germany") {Connect-MicrosoftTeams -ErrorAction Stop}
        }
    }
    catch {
        $errorMessage = $_.Exception.Message
        Write-Host $errormessage
        "Connect Microsoft Teams Fail"
        break
    }
}

# Connect to Microsoft Graph
function Connect-ServiceMSGraph {
    #Update-MSGraphEnvironment -AuthUrl https://login.microsoftonline.com/common -GraphBaseUrl https://graph.microsoft.com -GraphResourceId https://graph.microsoft.com #-Quiet
    If ($TenantType -eq "Commercial") {Update-MSGraphEnvironment -AuthUrl https://login.microsoftonline.com/common -GraphBaseUrl https://graph.microsoft.com -GraphResourceId https://graph.microsoft.com}
    If ($TenantType -eq "GCC") {Update-MSGraphEnvironment -AuthUrl https://login.microsoftonline.com/common -GraphBaseUrl https://graph.microsoft.com -GraphResourceId https://graph.microsoft.com}
    #If ($TenantType -eq "GCCH") {Update-MSGraphEnvironment -AuthUrl https://login.microsoftonline.us/common -GraphBaseUrl https://graph.microsoft.us -GraphResourceId https://graph.microsoft.us}
    If ($TenantType -eq "GCCH") {Update-MSGraphEnvironment -AuthUrl https://portal.azure.us/common -GraphBaseUrl https://graph.microsoft.us -GraphResourceId https://graph.microsoft.us}
    #If ($TenantType -eq "DoD") {Update-MSGraphEnvironment -AuthUrl https://login.microsoftonline.us/common -GraphBaseUrl https://dod-graph.microsoft.us -GraphResourceId https://dod-graph.microsoft.us}
    If ($TenantType -eq "DoD") {Update-MSGraphEnvironment -AuthUrl https://portal.azure.us/common -GraphBaseUrl https://dod-graph.microsoft.us -GraphResourceId https://dod-graph.microsoft.us}
    #If ($TenantType -eq "Germany") {Update-MSGraphEnvironment -AuthUrl https://login.microsoftonline.com/common -GraphBaseUrl https://graph.microsoft.de -GraphResourceId https://graph.microsoft.de}
    If ($TenantType -eq "Germany") {Update-MSGraphEnvironment -AuthUrl https://login.microsoftonline.de/common -GraphBaseUrl https://graph.microsoft.de -GraphResourceId https://graph.microsoft.de}
    If ($mfaUsed -eq 'No') {
        Write-Host "Connecting to Microsoft Graph"
        Connect-MSGraph -Credential $cred -ErrorAction Stop # Use if MFA is Not Used
    }
    Else {
        Write-Host "Connecting to Microsoft Graph - MFA"
        Connect-MSGraph -ErrorAction Stop # Use if MFA is Used
    }
}

# Connect to Microsoft Commerce
function Connect-ServiceMSCommerce {
    If ($Linux -eq 'No') {
        # Can not Connect with stored Credentials
        # Need GA Access to view Settings
        If ($mfaUsed -eq 'No') {
            Write-Host "Connecting to Microsoft Commerce"
            Connect-MSCommerce -Credential $cred -ErrorAction Stop # Use if MFA is Not Used
            #If ($TenantType -eq "Commercial") {Connect-MSCommerce -Credential $cred -ErrorAction Stop}
            #If ($TenantType -eq "GCC") {Connect-MSCommerce -Credential $cred -ErrorAction Stop}
            #If ($TenantType -eq "GCCH") {Connect-MSCommerce -Credential $cred -TeamsEnvironmentName TeamsGCCH -ErrorAction Stop}
            #If ($TenantType -eq "DoD") {Connect-MSCommerce -Credential $cred -TeamsEnvironmentName TeamsDOD -ErrorAction Stop}
            #If ($TenantType -eq "Germany") {Connect-MSCommerce -Credential $cred -ErrorAction Stop}
        }
        Else {
            Write-Host "Connecting to Microsoft Commerce - MFA"
            Connect-MSCommerce -ErrorAction Stop # Use if MFA is Used
            #If ($TenantType -eq "Commercial") {Connect-MSCommerce -ErrorAction Stop}
            #If ($TenantType -eq "GCC") {Connect-MSCommerce -ErrorAction Stop}
            #If ($TenantType -eq "GCCH") {Connect-MSCommerce -TeamsEnvironmentName TeamsGCCH -ErrorAction Stop}
            #If ($TenantType -eq "DoD") {Connect-MSCommerce -TeamsEnvironmentName TeamsDOD -ErrorAction Stop}
            #If ($TenantType -eq "Germany") {Connect-MSCommerce -ErrorAction Stop}
        }
    }
}

# Connect to Microsoft Power Apps
function Connect-ServiceMSPowerApps {
    If ($Linux -eq 'No') {
        # Need GA Access to view Settings
        If ($mfaUsed -eq 'No') {
            Write-Host "Connecting to Microsoft Power Apps"
            If ($TenantType -eq "Commercial") {Add-PowerAppsAccount -Username $cred.GetNetworkCredential().UserName -Password $cred.GetNetworkCredential().SecurePassword}
            If ($TenantType -eq "GCC") {Add-PowerAppsAccount -Endpoint usgov -Username $cred.GetNetworkCredential().UserName -Password $cred.GetNetworkCredential().SecurePassword}
            If ($TenantType -eq "GCCH") {Add-PowerAppsAccount -Endpoint usgovhigh -Username $cred.GetNetworkCredential().UserName -Password $cred.GetNetworkCredential().SecurePassword}
            If ($TenantType -eq "DoD") {Add-PowerAppsAccount -Endpoint dod -Username $cred.GetNetworkCredential().UserName -Password $cred.GetNetworkCredential().SecurePassword}
            If ($TenantType -eq "Germany") {Add-PowerAppsAccount -Username $cred.GetNetworkCredential().UserName -Password $cred.GetNetworkCredential().SecurePassword}
        }
        Else {
            Write-Host "Connecting to Microsoft Power Apps - MFA"
            If ($TenantType -eq "Commercial") {Add-PowerAppsAccount}
            If ($TenantType -eq "GCC") {Add-PowerAppsAccount -Endpoint usgov}
            If ($TenantType -eq "GCCH") {Add-PowerAppsAccount -Endpoint usgovhigh}
            If ($TenantType -eq "DoD") {Add-PowerAppsAccount -Endpoint dod}
            If ($TenantType -eq "Germany") {Add-PowerAppsAccount}
        }
    }
}

# Connect to Microsoft Power BI
function Connect-ServiceMSPowerBI {
    #If ($Linux -eq 'No') {
    # Need GA Access to view Settings
    If ($mfaUsed -eq 'No') {
        Write-Host "Connecting to Microsoft Power BI"
        If ($TenantType -eq "Commercial") {Connect-PowerBIServiceAccount -Credential $cred}
        If ($TenantType -eq "GCC") {Connect-PowerBIServiceAccount -Environment USGov -Credential $cred}
        If ($TenantType -eq "GCCH") {Connect-PowerBIServiceAccount -Environment USGovHigh -Credential $cred}
        If ($TenantType -eq "DoD") {Connect-PowerBIServiceAccount -Environment USGovMil -Credential $cred}
        If ($TenantType -eq "Germany") {Connect-PowerBIServiceAccount -Environment Germany -Credential $cred}
    }
    Else {
        Write-Host "Connecting to Microsoft Power BI - MFA"
        If ($TenantType -eq "Commercial") {Add-PowerAppsAccount}
        If ($TenantType -eq "GCC") {Connect-PowerBIServiceAccount -Environment USGov}
        If ($TenantType -eq "GCCH") {Connect-PowerBIServiceAccount -Environment USGovHigh}
        If ($TenantType -eq "DoD") {Connect-PowerBIServiceAccount -Environment USGovMil}
        If ($TenantType -eq "Germany") {Connect-PowerBIServiceAccount -Environment Germany}
    }
    #}
}

# Disconnect Services
function Disconnect-Services {
    # Disconnect MSOL Service
    # ? Connect-MsolService
    # Disconnect AzureAD
    #Disconnect-AzureAD -Confirm $False
    Disconnect-AzureAD -Confirm:$False
    # Disconnect Exchange Online
    #Disconnect-ExchangeOnline -Confirm $False
    Disconnect-ExchangeOnline -Confirm:$False
    Get-PSSession | Where-Object {$_.Name -match 'Exchange'}
    Get-PSSession | Where-Object {$_.Name -match 'Exchange'} | Disconnect-PSSession
    # Disconnect SharePoint Online
    #Disconnect-SPOService
    Disconnect-SPOService -Confirm:$False
    # Disconnect Microsoft Teams
    #Disconnect-MicrosoftTeams
    Disconnect-MicrosoftTeams -Confirm:$False
    # Disconnect to Microsoft Commerce
    # ? Connect-MSCommerce
    # Disconnect Microsoft Power Apps
    #Remove-PowerAppsAccount
    Remove-PowerAppsAccount -Confirm:$False
    # Disconnect Microsoft Power BI
    #Disconnect-PowerBIServiceAccount
    Disconnect-PowerBIServiceAccount -Confirm:$False

}


# Functions - End

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
    Write-Host "`t 5`tGermany (Germany)" -Fore Cyan
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
        $TenantType = "Germany" # Germany
    }
    If ($select -gt '5') {
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
    #$TenantType = "Germany" # (Germany)
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

# Check OS Version
Get-OSVersion

# Connect to MSOL Service
Connect-ServiceMSOL

# Script Variables
If ($Linux -eq 'No') {
    $TenantID = (Get-MsolCompanyInformation).ObjectId
    $Script:msolDomainName = (Get-MsolCompanyInformation).InitialDomain #'<Tanant>.onmicrosoft.com' # Microsoft 365 Tenant
    $InitialDomain = ($Script:msolDomainName).Split('.')[0]
}
else {$Script:msolDomainName = $tenantDomain}

# Connect to Other Services
#Connect-ServiceMSOL
#Connect-ServiceAAD
#Connect-ServiceEXO
Connect-ServiceSCC # Do Not Call at this time, only called when needed
#Connect-ServiceSPO
#Connect-ServiceMSTeams
#Connect-ServiceMSGraph
#Connect-ServiceMSCommerce # Not Credential passthrough currrently
#Connect-ServiceMSPowerApps
#Connect-ServiceMSPowerBI # Issues with Module and Arrays with Other Modules installed


<#
If ($TenantType -eq "GCCH") {$EXOOptions = New-PSSessionOption -ExchangeEnvironmentName O365USGovGCCHigh}
If ($TenantType -eq "DoD") {$EXOOptions = New-PSSessionOption -ExchangeEnvironmentName O365USGovDoD}
If ($TenantType -eq "Germany") {$EXOOptions = New-PSSessionOption -ExchangeEnvironmentName O365GermanyCloud}
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