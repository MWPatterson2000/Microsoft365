

# Define Variables - Label
$labelname = "Demo Label"
$labeldescription = "Demo Label Created Using PowerShell"
$tooltip = "Demo Tooltip"


# Create Label
$label = New-Label `
    -DisplayName $labelname `
    -Name $labelname `
    -Comment $labeldescription `
    -Tooltip $tooltip

    
# Set Label
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


# Create Auto-Label Policy
$labelpolicyname = "Demo Label Policy"
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
        "defaultlabelid":"0ce5a23d-3ff6-4781-b09d-6efa6f44ae23",
        "disablemandatoryinoutlook":"false"
    }'


# New Auto-Label Policy
$autolabelpolicyname = "Demo Auto Label Policy"
$autolabelpolicydescription = "Demo Auto Label Policy Created Using PowerShell"
$site = "https://shareplicitytraining.sharepoint.com/sites/wgive"
$mode = "TestWithoutNotifications"
 
New-AutoSensitivityLabelPolicy `
    -Name $autolabelpolicyname `
    -Comment $autolabelpolicydescription `
    -SharePointLocation $site `
    -Mode TestWithoutNotifications `
    -ApplySensitivityLabel $label.DisplayName


# 
$sampledata = '{
        "LabelName":"Label 1",
        "LabelDescription":"Label 1 - Created with PowerShell",
        "LabelTooltip":"Label 1 Tooltip"
    },  
    {
        "LabelName":"Label 2",
        "LabelDescription":"Label 2 - Created with PowerShell",
        "LabelTooltip":"Label 2 Tooltip"
    }'
 
$labels = $sampledata | ConvertFrom-Json
 
foreach($label in $labels)
{
    $createlabel = New-Label `
        -DisplayName $label.LabelName `
        -Name $label.LabelName `
        -Comment $label.LabelDescription `
        -Tooltip $label.LabelTooltip
}







