<#
    .SYNOPSIS
    Exports all Exchange Online Client Access Rules  
    
    .DESCRIPTION
    Exports all Exchange Online Client Access Rules into a CSV file in c:\Temp
	Requires M365 account account with atleast Exchange Administrator role
    	Dependant on Exchange Online PowerShell module
    
    #>
    
# Export File
$exportFile = "C:\Temp\$(Get-Date -Format yyyy-MM-dd-HH-mm) - EXO - ClientAccessRule.csv"

Get-ClientAccessRule | Select-Object * | Export-Csv -Path $exportFile -Encoding utf8 -NoTypeInformation

<#
#Get Conditional Access Policies   
$tempAR = @(Get-ClientAccessRule)

$Policies = @()

# Build Export Array
$count = @(($tempAR).Displayname).Count
$count = $count - 1
for ($num = 0 ; $num -le $count ; $num++) {
    #$temp = (($tempAR[$num]).ipRanges).cidrAddress -join ','
    $Policies += New-Object PSobject -Property @{
        "Name"  = ($tempAR[$num]).Name
        "Priority" = ($tempAR[$num]).Priority
        "Enabled"  = ($tempAR[$num]).Enabled
        "DatacenterAdminsOnly" = ($tempAR[$num]).DatacenterAdminsOnly
    }
}

# Export Data
$Policies | export-csv -Path $exportFile -NoTypeInformation
#>