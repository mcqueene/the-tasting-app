. 'C:\Users\matt\OneDrive\Beer Club\tasting_file_to_array_function.ps1'
cd 'C:\Users\matt\OneDrive\Beer Club'

[array]$sourcearray = Import-Excel -Path 'NewCombinedList.xlsx' -Raw

#get unique styles
[array]$array = $sourcearray | Select-Object StatedStyle -Unique |  Sort-Object StatedStyle    
$array | Select-Object -First 5 

$array | Export-Excel -Path './StatedStyle.xlsx'
