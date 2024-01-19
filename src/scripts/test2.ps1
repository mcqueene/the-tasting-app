. .\src\scripts\tasting_file_to_array_function.ps1 -Verbose
. .\src\scripts\normalize_data_functions.ps1
#-Name C:\myRandomDirectory\myModule -Verbose
#C:\Users\matt\Documents\GitHub\the-tasting-app\src\scripts\tasting_file_to_array_function.ps1

<#
[array]$sourcearray = Import-Excel -Path 'C:\Users\matt\OneDrive\Beer Club\NewCombinedList.xlsx' -Raw 
$sourcearray | Select-Object -First 100 | Select-Object -Property @{name='Date';expression={$_.DateTasted}}, Beer, `
    @{name='Stated Style';expression={$_.'StatedStyle'}}, Container, Taste, Style, @{name='Overall Score ';expression={$_.OverallScore}}, `
    Brewer, City, @{name='State/Country';expression={$_.StateCountry}}, Comments, ABV, @{name='Org Gravity';expression={$_.OrgGravity}}, IBU
      
    [array]$newarray = $null
    $newarray = TastingFileToArray -File $file -RowCount 2 -FileName $input_master_file
    
#>

$updatefilelist = Get-ChildItem -Path "C:\Users\matt\OneDrive\Beer Club\" -Filter 'taste update 20240113.xlsx'
[array]$mergearray = @()

foreach($updatefile in $updatefilelist) {
    $file = Import-Excel -Path ('C:\Users\matt\OneDrive\Beer Club\' + $updatefile) -Raw
    $cnt = $newarray.Length + $mergearray.Length + 1
    $mergearray += TastingFileToArray -File $file -RowCount $cnt -FileName $updatefile
}
#$mergearray | Sort-Object -Property DateTasted -Descending | ConvertTo-Json -depth 100 


