#
# 20240119 mrm added worksheet for error list

[array]$sourcearray = @()
$sourcearray = Import-Excel -Path 'C:\Users\matt\OneDrive\Beer Club\NewCombinedList.xlsx' -Raw
Write-Host 'file imported'
#get unique styles
[array]$array = $sourcearray | Select-Object StatedStyle -Unique |  Sort-Object StatedStyle    
Write-Host 'found' $array.Count 'styles'
$array | Select-Object -First 5 


#$sourcearray | Group-Object StatedStyle | Sort-Object Name | Where-Object Count -eq 1 | Select-Object Name, Count, Group.Beer, Group.Brewer, Group.StateCountry, Group.ABV, Group.DateTasted
[array]$errorlist = @()
$grouparray = $sourcearray | Group-Object StatedStyle | Sort-Object Name | Where-Object Count -lt 3 
foreach($row in $grouparray) {
    [string]$style = $row.Name
    [string]$count = $row.Count
    foreach($g in $row.Group) {
        $obj = new-object PSObject
        $obj | add-member -membertype NoteProperty -name "Style" -Value $style
        $obj | add-member -membertype NoteProperty -name "Count" -Value $count
        $obj | add-member -membertype NoteProperty -name "Beer" -Value $g.Beer
        $obj | add-member -membertype NoteProperty -name "Brewer" -Value $g.Brewer
        $obj | add-member -membertype NoteProperty -name "StateCountry" -Value $g.StateCountry
        $obj | add-member -membertype NoteProperty -name "ABV" -Value $g.ABV
        $obj | add-member -membertype NoteProperty -name "DateTasted" -Value $g.DateTasted
        $errorlist += $obj    
    }
}

Write-Host 'removing old files'
Remove-Item 'C:\Users\matt\OneDrive\Beer Club\StatedStyle.xlsx'
$excelpkg1 = $array | Export-Excel -PassThru -AutoSize -WorksheetName 'Styles' -Path 'C:\Users\matt\OneDrive\Beer Club\StatedStyle.xlsx' -TableName 'Styles' -TableStyle Medium16 
Set-ExcelColumn -ExcelPackage $excelpkg1 -WorksheetName "Styles" -Column 1 -Width 30
$sourcearray | Group-Object StatedStyle | Sort-Object Name | Select-Object Name, Count | Export-Excel -PassThru -AutoSize -WorksheetName 'StyleCount' -ExcelPackage $excelpkg1 -TableName 'StyleCount' -TableStyle Medium16 
Set-ExcelColumn -ExcelPackage $excelpkg1 -WorksheetName "StyleCount" -Column 1 -Width 30
$errorlist | Sort-Object Count, Style | Export-Excel -PassThru -AutoSize -WorksheetName 'ErrorList' -ExcelPackage $excelpkg1 -TableName 'ErrorList' -TableStyle Medium16 
Close-ExcelPackage -ExcelPackage $excelpkg1 -Show

#Remove-Item 'C:\Users\matt\OneDrive\Beer Club\StatedStyle_Count.xlsx'
#$sourcearray | Group-Object StatedStyle | Sort-Object Name | Select-Object Name, Count | Export-Excel -Path 'C:\Users\matt\OneDrive\Beer Club\StatedStyle_Count.xlsx' -TableName 'StyleCount' -TableStyle Medium16 -Show