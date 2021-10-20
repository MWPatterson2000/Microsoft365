try 
{ $var = Get-AzureADTenantDetail } 

catch [Microsoft.Open.Azure.AD.CommonLibrary.AadNeedAuthenticationException] 
{ Write-Host "You're not connected."}
