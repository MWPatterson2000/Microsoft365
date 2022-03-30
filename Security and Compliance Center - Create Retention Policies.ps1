
#Install-Module ExchangeOnlineManagement
#Import-Module ExchangeOnlineManagement
Connect-IPPSSession #-UserPrincipalName user@domain.onmicrosoft.com


# Define Variables
# Exchange Only Policy
$exchname = 'Exchange Policy'
$exchnamerule = 'Exchange Policy Rule'
$exchdescription = 'Exchange Policy'
$exchRetentionDuration = '2555'
 
# Teams Only Policy
$teamsname = 'Teams Policy'
$teamsnamerule = 'Teams Policy Rule'
$teamsdescription = 'Teams Policy'
$teamsRetentionDuration = '2555'

# SharePoint Only Policy
$sponame = 'SharePoint Policy'
$sponamerule = 'SharePoint Policy Rule'
$spodescription = 'SharePoint Policy'
$spoRetentionDuration = '2555'


# Build Retention Policies
# Create the Exchange Only Policy
$exchpolicy = New-RetentionCompliancePolicy `
    -Name $exchname `
    -Comment $exchdescription `
    -ExchangeLocation All `
    -PublicFolderLocation All `
    -Enabled $false
#$exchpolicy = New-RetentionCompliancePolicy -Name 'Exchange Policy' -Comment 'Exchange Policy' -ExchangeLocation All -PublicFolderLocation All -Enabled $false

# Create the Teams Only Policy
$teamspolicy = New-RetentionCompliancePolicy `
    -Name $teamsname `
    -Comment $teamsdescription `
    -TeamsChannelLocation All `
    -TeamsChatLocation All `
    -Enabled $true
#$teamspolicy = New-RetentionCompliancePolicy -Name 'Teams Policy' -Comment 'Teams Policy' -TeamsChannelLocation All -TeamsChatLocation All -Enabled $true

# Create the SharePoint Only Policy
$spopolicy = New-RetentionCompliancePolicy `
    -Name $sponame `
    -Comment $spodescription `
    -SharePointLocation All `
    -ModernGroupLocation All `
    -OneDriveLocation All `
    -Enabled $true
#$spopolicy = New-RetentionCompliancePolicy -Name 'SharePoint Policy' -Comment 'SharePoint Policy' -SharePointLocation All -ModernGroupLocation All -OneDriveLocation All -Enabled $true


# Build Retention Policies Rules
# Create Exchange Only Policy Rule
New-RetentionComplianceRule `
    -Name $exchnamerule `
    -Policy $exchpolicy.Id `
    #-RetentionDuration 2555 `
    -RetentionDuration $exchRetentionDuration `
    -RetentionComplianceAction KeepAndDelete `
    -ExpirationDateOption ModificationAgeInDays
#New-RetentionComplianceRule -Name 'Exchange Policy Rule' -Policy $exchpolicy.Id -RetentionDuration $exchRetentionDuration -RetentionComplianceAction KeepAndDelete -ExpirationDateOption ModificationAgeInDays

# Create Teams Only Policy Rule
New-RetentionComplianceRule `
    -Name $teamsnamerule `
    -Policy $teamspolicy.Id `
    #-RetentionDuration 2555 `
    -RetentionDuration $teamsRetentionDuration `
    -RetentionComplianceAction KeepAndDelete
#New-RetentionComplianceRule -Name 'Teams Policy Rule' -Policy $teamspolicy.Id -RetentionDuration $teamsRetentionDuration -RetentionComplianceAction KeepAndDelete
    
# Create SharePoint Only Policy Rule
New-RetentionComplianceRule `
    -Name $sponamerule `
    -Policy $spopolicy.Id `
    #-RetentionDuration 2555 `
    -RetentionDuration $spoRetentionDuration `
    -RetentionComplianceAction KeepAndDelete `
    -ExpirationDateOption ModificationAgeInDays
#New-RetentionComplianceRule -Name 'SharePoint Policy Rule' -Policy $spopolicy.Id -RetentionDuration $spoRetentionDuration -RetentionComplianceAction KeepAndDelete -ExpirationDateOption ModificationAgeInDays


# End
