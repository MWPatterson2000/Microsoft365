<#
    .SYNOPSIS
    Exports all Azure AD Conditional Access Names Locations
    
    .DESCRIPTION
    Exports all Azure AD Conditional Access Names Locations into a CSV file in c:\Temp
	Requires M365 account account with atleast Security Reader role
    	Dependant on Azure AD PowerShell modulee
    
    #>
    
# Export File
$exportFile = "C:\Temp\$(Get-Date -Format yyyy-MM-dd-HH-mm) - AAD - CA namedLocations.csv"

#Get Conditional Access Policies   
$tempAR = @(Get-AzureADMSNamedLocationPolicy)

$Policies = @()

# Build Export Array
$count = @(($tempAR).Displayname).Count
$count = $count - 1
for ($num = 0 ; $num -le $count ; $num++) {
    $temp = (($tempAR[$num]).ipRanges).cidrAddress -join ','
    $Policies += New-Object PSobject -Property @{
        "Displayname"  = ($tempAR[$num]).displayName
        "isTrusted" = ($tempAR[$num]).isTrusted
        "ID"  = ($tempAR[$num]).id
        "ipRanges" = $temp
    }
}

# Export Data
$Policies | export-csv -Path $exportFile -NoTypeInformation
