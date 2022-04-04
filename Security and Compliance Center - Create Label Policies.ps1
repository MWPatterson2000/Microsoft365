
# Show/Hide the bar
Set-LabelPolicy -Identity "Policy Name" -AdvancedSettings @{HideBarByDefault="False"}
 
# Set a separate label as default for just Outlook and keep the other default for rest of the application.
Set-LabelPolicy -Identity "Policy Name" -AdvancedSettings @{OutlookDefaultLabel="f6eda0a9-61e2-4f48-be69-d6cba1328015"}
 
# Disable the function of separate default label
Set-LabelPolicy -Identity "Policy Name" -AdvancedSettings @{OutlookDefaultLabel="None"}
 
# Excempt Outlook from standard label
Set-LabelPolicy -Identity Global -AdvancedSettings @{DisableMandatoryInOutlook="True"}
 
# CustomPermissions
Set-LabelPolicy -Identity "Policy Name" -AdvancedSettings @{EnableCustomPermissions="False"}
 
# Set Attachment action to automatic
Set-LabelPolicy -Identity Global -AdvancedSettings @{AttachmentAction="Automatic"}
