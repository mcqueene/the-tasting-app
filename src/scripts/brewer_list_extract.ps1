. .\src\scripts\tasting_file_to_array_function.ps1 -Verbose

cd 'C:\Users\matt\OneDrive\Beer Club'

[array]$sourcearray = Import-Excel -Path 'NewCombinedList.xlsx' -Raw

#get unique brewers
[array]$brewerarray = $sourcearray | Select-Object Brewer, City, StateCountry -Unique |  Sort-Object Brewer    
$brewerarray | Select-Object -First 5 

$brewerarray | Export-Excel -Path './BrewerList.xlsx'
