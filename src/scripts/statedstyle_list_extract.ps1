
[array]$sourcearray = @()
$sourcearray = Import-Excel -Path 'C:\Users\matt\OneDrive\Beer Club\NewCombinedList.xlsx' -Raw
Write-Host 'file imported'
#get unique styles
[array]$array = $sourcearray | Select-Object StatedStyle -Unique |  Sort-Object StatedStyle    
Write-Host 'found' $array.Count 'styles'
$array | Select-Object -First 5 
Write-Host 'removing old files'
Remove-Item 'C:\Users\matt\OneDrive\Beer Club\StatedStyle.xlsx'
$array | Export-Excel -Path 'C:\Users\matt\OneDrive\Beer Club\StatedStyle.xlsx'
Remove-Item 'C:\Users\matt\OneDrive\Beer Club\StatedStyle_Count.xlsx'
$sourcearray | Group-Object StatedStyle | Sort-Object Name | Select-Object Name, Count | Export-Excel -Path 'C:\Users\matt\OneDrive\Beer Club\StatedStyle_Count.xlsx' -TableName 'StyleCount' -TableStyle Medium16 -Show