
#  Define Label Variables
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
 
#  Convert JSON to Variable
$labels = $sampledata | ConvertFrom-Json
 
#  Build Policy Lables
foreach($label in $labels) { 
    $createlabel = New-Label `
        -DisplayName $label.LabelName `
        -Name $label.LabelName `
        -Comment $label.LabelDescription `
        -Tooltip $label.LabelTooltip
}






