New-RetentionCompliancePolicy -Name "Company Policy" -ExchangeLocation All -SharePointLocation All -ModernGroupLocation All -OneDriveLocation All -PublicFolderLocation All -Enabled $true
New-RetentionComplianceRule -Name "Company Policy Rule" -Policy "Company Policy" -RetentionDuration Unlimited
