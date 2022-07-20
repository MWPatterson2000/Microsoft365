# https://office365itpros.com/2022/07/20/sharepoint-external-users-report/

$Sites = Get-SPOSite -Limit All | Sort-Object Title
$ExternalSPOUsers = [System.Collections.Generic.List[Object]]::new() 
#Iterate through each site and retrieve external users
$Counter = 0
ForEach ($Site in $Sites) {
    $Counter++
    Write-Host ("Checking Site {0}/{1}: {2}" -f $Counter, $Sites.Count, $Site.Title)
    [array]$SiteUsers = $Null
    $i = 0; $Done = $False
    Do {
      [array]$SUsers = Get-SPOExternalUser -SiteUrl $Site.Url -PageSize 50 -Position $i
      If ($SUsers) { 
        $i = $i + 50
        $SiteUsers = $SiteUsers + $SUsers }
      If ($SUsers.Count -lt 50) {$Done = $True}   
    }  While ($Done -eq $False)
    ForEach ($User in $SiteUsers) {
       $ReportLine    = [PSCustomObject] @{  
         Email        = $User.Email 
         Name         = $User.DisplayName
         Accepted     = $User.AcceptedAs
         Created      = $User.WhenCreated
         SPOUrl       = $Site.Url
         TeamsChannel = $Site.IsTeamsChannelConnected
         ChannelType  = $Site.TeamsChannelType
         CrossTenant  = $User.IsCrossTenant
         LoginName    = $User.LoginName }
        $ExternalSPOUsers.Add($ReportLine) }
} #End ForEach Site

<#
Import-Module PSWriteHTML.psd1 -Force
$ExternalSPOUsers | Sort Email | Out-HtmlView -HideFooter -Title "SharePoint Online External Users Report"
#>