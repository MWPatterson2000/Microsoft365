<#
Name: AzureAD Password Protection Report.ps1

This script is used to generate an AzureAD Password Protection Status Report when you have it implemented.  It send also send information via email to selected address

Below is a list of the files created from this script:
    <Year>-<Month>-<Date>-<Hour>-<Minuite>-<Domain>-AzureAD Password Protection Summary Report.csv   - This is a summary report of all password changes on the DC's and contains the following information: DomainController	PasswordChangesValidated	PasswordSetsValidated	PasswordChangesRejected	PasswordSetsRejected	PasswordChangeAuditOnlyFailures	PasswordSetAuditOnlyFailures	PasswordChangeErrors	PasswordSetErrors
    <Year>-<Month>-<Date>-<Hour>-<Minuite>-<Domain>-AzureAD Password Protection Agent Report.csv     - This is a summary report of all agent information on the DC's and contains the following information: ServerFQDN	SoftwareVersion	Domain	Forest	PasswordPolicyDateUTC	HeartbeatUTC	AzureTenant
    <Year>-<Month>-<Date>-<Hour>-<Minuite>-<Domain>-AzureAD Password Protection Proxy Report.csv     - This is a summary report of all agent information on the Proxy Servers and contains the following information: ServerFQDN	SoftwareVersion	Domain	Forest	HeartbeatUTC	AzureTenant


This needs to be run from the Server(s) with the Azure AD Password Protection
The script also needs to be run with Admin Privledges

Michael Patterson
scripts@mwpatterson.com


Revision History
    2019-10-22 - Initial Release
    2020-02-19 - Added AD Agent & Proxy Settings, set formatting
    2022-01-13 - Cleanup

#>

# Clear Screen
Clear-Host

#<#
# Self-elevate the script if required
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { 
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
 }
#>

<#
# Check For Admin Mode
Requires -RunAsAdministrator
#>

# Funtions
# Email Function
function send_email () 
{
    $today = Get-Date
    $today = $today.ToString("dddd MMMM-dd-yyyy hh:mm tt")
    $SmtpClient = new-object system.net.mail.smtpClient 
    $mailmessage = New-Object system.net.mail.mailmessage 
    $SmtpClient.EnableSsl = $smtpssl
    #$SmtpClient.Credentials = New-Object System.Net.NetworkCredential("User", "Password"); 
    $SmtpClient.Host = $smtpserver
    $SmtpClient.Port = $smtpport
    $mailmessage.from = $emailfrom 
    $mailmessage.To.add($email1)
    #$mailmessage.To.add($email2)
    $mailmessage.Subject = "Azure AD Password Protection Report"
    $mailmessage.IsBodyHtml = $true
    $mailmessage.Attachments.Add($logPath)
    $mailmessage.Attachments.Add($logPath1)
    $mailmessage.Attachments.Add($logPath2)
#<#
    $mailmessage.Body = @"
<font size = "4">
<strong>Azure AD Protection Password Report <span style="background-color:yellow;color:black;">$env:USERDNSDOMAIN</strong></span>.<br /> <br />
<strong>AzureAD Password Protection Summary Report</strong><br />
$azureADPWSummaryR
<br />
<strong>AzureAD Password Protection Agent Report</strong><br />
$azureADAgentSummaryR
<br />
<strong>AzureAD Password Protection Proxy Report</strong><br />
$azureADProxySummaryR
<br />
Generated on : $today<br /><br />
<br /></font></h5>
"@
#>
    #$mailmessage.Body = $azureADPWSummaryR
    $smtpclient.Send($mailmessage) 
}
    
# Set Variables
#Configure Email notification recipient
#$smtpserver = "outlook.office365.com"
#$smtpport = "587"
#$smtpssl = "True"
$smtpserver = "<SMTP Server>"
$smtpport = "25"
$smtpssl = "False"
$emailfrom = "$env:computername <$env:computername@mfa.net>"
$email1 = "user1@test.local"
#$email2 = "user2@test.local"

# Format HTML Email
$style = "<style>BODY{font-family: Cabliri; font-size: 11pt;}"
$style = $style + "TABLE{border: 1px solid black; border-collapse: collapse;}"
$style = $style + "TH{border: 1px solid black; background: #dddddd; padding: 5px; }"
$style = $style + "TD{border: 1px solid black; padding: 5px; }"
$style = $style + "</style>"

#<#
# Get Date & Log Locations
$date = get-date -Format "yyyy-MM-dd-HH-mm"
$logRoot = "C:\"
$logFolder = "Scripts\Azure AD Password Report"
$logFolerP = $logRoot +$logFolder
$logFile = "AzureAD Password Protection Summary Report.csv"
$logFile1 = "AzureAD Password Protection Agent Report.csv"
$logFile2 = "AzureAD Password Protection Proxy Report.csv"
$logPath = $logFolerP +"\" +$date +"-" +$logFile
$logPath1 = $logFolerP +"\" +$date +"-" +$logFile1
$logPath2 = $logFolerP +"\" +$date +"-" +$logFile2
#>

# Verify Reporting Folder
if ((Test-Path $logFolerP) -eq $false) {
    New-Item -Path $logFolerP -ItemType directory
}

# Get Azure AD Password Protection Summary
$azureADPWSummary = Get-AzureADPasswordProtectionSummaryReport | Sort-Object DomainController
$azureADAgentSummary = Get-AzureADPasswordProtectionDCAgent | Sort-Object ServerFQDN
$azureADProxySummary = Get-AzureADPasswordProtectionProxy | Sort-Object ServerFQDN

# Create CSV Report
$azureADPWSummary | Export-Csv $logPath -NoTypeInformation -Encoding UTF8
$azureADAgentSummary | Export-Csv $logPath1 -NoTypeInformation -Encoding UTF8
$azureADProxySummary | Export-Csv $logPath2 -NoTypeInformation -Encoding UTF8

# Create HTML Report
$azureADPWSummaryR = $azureADPWSummary | ConvertTo-Html -Head $style
$azureADAgentSummaryR = $azureADAgentSummary | ConvertTo-Html #-Head $style
$azureADProxySummaryR = $azureADProxySummary | ConvertTo-Html #-Head $style

# Send email Notification
#send_email

