

# Define Variables - Label
$labelname = "Test Label"
$labeldescription = "Test Label Created Using PowerShell"
$tooltip = "Test Tooltip"
$labelActionHeader = 'Yes'
$labelActionFooter = 'Yes'
$labelActionWatermark = 'Yes'


# Create Label
$label = New-Label `
    -DisplayName $labelname `
    -Name $labelname `
    -Comment $labeldescription `
    -Tooltip $tooltip

    
# Set Label
# Set Header 
if ($labelActionHeader -eq 'Yes') { 
    Set-Label `
        -Identity $label.Id `
        -LabelActions '{
        "Type":"applycontentmarking",
        "SubType":"header",
        "Settings":[
            {"Key":"fontsize","Value":"10"},
            {"Key":"placement","Value":"Header"},
            {"Key":"text","Value":"Header"},
            {"Key":"fontcolor","Value":"#000000"}
        ]}'
}
# Set Footer
if ($labelActionFooter -eq 'Yes') { 
    Set-Label `
        -Identity $label.Id `
        -LabelActions '{
        "Type":"applycontentmarking",
        "SubType":"footer",
        "Settings":[
            {"Key":"fontsize","Value":"10"},
            {"Key":"placement","Value":"Footer"},
            {"Key":"text","Value":"Footer"},
            {"Key":"fontcolor","Value":"#000000"}
        ]}'
}
# Set Watermark
if ($labelActionWatermark -eq 'Yes') { 
    Set-Label `
        -Identity $label.Id `
        -LabelActions '{
        "Type":"applywatermarking",
        "SubType":null,
        "Settings":[
            {"Key":"fontsize","Value":"10"},
            {"Key":"layout","Value":"Diagonal"},
            {"Key":"fontcolor","Value":"#000000"},
            {"Key":"disabled","Value":"false"},
            {"Key":"text","Value":"Watermark"}
        ]}'
}

# Create Auto-Label Policy
$labelpolicyname = "Test Label Policy"
$policy = New-LabelPolicy `
    -Name $labelpolicyname `
    -Labels $label.DisplayName
 
Set-LabelPolicy `
    -Identity $policy.Id `
    -AddExchangeLocation "All" `
    -AddOneDriveLocation "All" `
    -AddSharePointLocation "All" `
    -AdvancedSettings @{ AttachmentAction = "Automatic" } `
    -Settings '{
        "powerbimandatory":"false",
        "requiredowngradejustification":"requiredowngradejustification",
        "mandatory":"true",
        "disablemandatoryinoutlook":"false"
    }'

<#
# New Auto-Label Policy
# Auto-Policy Variables
$autolabelpolicyname = "Test Auto Label Policy"
$autolabelpolicydescription = "Demo Auto Label Policy Created Using PowerShell"
$site = "https://shareplicitytraining.sharepoint.com/sites/wgive"
$mode = "TestWithoutNotifications"

# New Auto-Policy Label
New-AutoSensitivityLabelPolicy `
    -Name $autolabelpolicyname `
    -Comment $autolabelpolicydescription `
    -SharePointLocation $site `
    -Mode $mode `
    -ApplySensitivityLabel $label.DisplayName
#>



