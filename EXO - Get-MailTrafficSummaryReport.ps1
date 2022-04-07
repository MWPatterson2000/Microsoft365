# https://m365scripts.com/exchange-online/find-number-of-emails-sent-and-received-by-user-in-office-365/

# The cmdlet retrieves the number of emails received by the users for the last 15 day
Get-MailTrafficSummaryReport –Category TopMailRecipient | Select-Object C1,C2 

# If you want to get Outlook email statistics per day or month, you can use the StartDate and EndDate parameters. 
Get-MailTrafficSummaryReport –Category TopMailRecipient –StartDate “03/29/22 00:00:00” -EndDate “03/29/22 23:59:00” | Select-Object C1,C2 

# To get a monthly report on email traffic, you can use the following format. 
Get-MailTrafficSummaryReport –Category TopMailRecipient –StartDate 03/1/22 -EndDate 3/31/22 | Select-Object C1,C2 

# To get sent email statistics report, you can run the ‘Get-MailTrafficSummaryReport’ cmdlet with Category value TopMailSender. For example,
Get-MailTrafficSummaryReport –Category TopMailSender –StartDate 03/1/22 -EndDate 3/31/22 | Select-Object C1,C2 


# Spam and Malware Reports 
# Also, you can generate spam and malware statistics reports using ‘Get-MailTrafficSummaryReport’. 

# To identify users who received spam emails in the given period, run the cmdlet with the Category value TopSpamRecipient 
Get-MailTrafficSummaryReport –Category TopSpamRecipient | Select-Object C1,C2 

# To get the malware recipient stats, run the cmdlet with TopMalwareRecipient Category. 
Get-MailTrafficSummaryReport –Category TopMalwareRecipient | Select-Object C1,C2 

# To get a list of received malware, execute the cmdlet as follows. 
Get-MailTrafficSummaryReport –Category TopMalware | Select-Object C1,C2 
