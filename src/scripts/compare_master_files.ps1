. 'C:\Users\matt\OneDrive\Beer Club\tasting_file_to_array_function.ps1'
cd 'C:\Users\matt\OneDrive\Beer Club'


. 'C:\Users\matt\OneDrive\Beer Club\tasting_file_to_array_function.ps1'
cd 'C:\Users\matt\OneDrive\Beer Club'
$comparefile = Import-Excel -Path 'Tasting List Master from doug.xlsx' -WorksheetName "Beverages" -Raw
[array]$comparearray = $null
$comparearray = TastingFileToArray -File $comparefile 
$ht_copy = @{}
$comparearray | % {$ht_copy[$_.key] = $_.DateTasted}
$ht_copy.Count

$sourcefile = Import-Excel -Path 'Tasting List Master copy 202110.xlsx' -WorksheetName "Beer" -Raw
[array]$sourcearray = $null
$sourcearray = TastingFileToArray -File $sourcefile 
$ht_source = @{}
$sourcearray | % {$ht_source[$_.key] = $_.id}
$ht_source.Count

$ht_missing = @{}
$ht_copy.GetEnumerator() |
    ForEach-Object {
        $find = $ht_source[$_.Key]
        if($find -eq $nul) {
            Write-Host 'failed to find key' $_.Key 'value of' $_.Value
            $ht_missing.Add($_.Key, $_.Value)
        }   
    }

PSCustomObject]$ht_missing | Export-Csv -Path "missing_report2.csv" -NoTypeInformation

<#



$comparefile = Import-Excel -Path 'Tasting List Master from doug.xlsx' -WorksheetName "Beverages" -Raw
[array]$comparearray = $null

$comparearray = TastingFileToArray -File $comparefile 
$myfile = Import-Excel -Path 'NewCombinedList.xlsx' -Raw 
[array]$missingarray = $null

foreach($row in $comparearray) {
    $beer = $row.Beer
    $beer = $beer.Replace('(', '\(')
    $beer = $beer.Replace(')', '\)')
    $beer = $beer.Replace('+', '')
    $beer = $beer.trim()
    $datetasted = $row.DateTasted

    [array]$foundlist = $myfile | Where-Object {($_.Beer -Match $beer) -and ($_.DateTasted -Match $datetasted )}   

    if($foundlist.length -eq 0) {
        Write-Host 'not found in myfile' $row.Beer $row.DateTasted
        $missingarray += $row
    }

}

$missingarray | Export-Csv -Path "missing_report.csv" -NoTypeInformation
#>

<#
$b = "Augustiner"
$d = "20000506"
$myfile | Where-Object {($_.Beer -Match $b)}  | Sort-Object Beer |Format-Table
$myfile | Where-Object {($_.DateTasted -Match $d)}  | Sort-Object Beer |Format-Table
$comparearray | Where-Object {($_.DateTasted -Match $d)}  | Sort-Object Beer | Format-Table



$b = "Baltika 9 Strong Lager (Extra Pale Ale)"
$b2 = "Baltika 9 Strong Lager \(Extra Pale Ale"
$d = "20021026"

Write-Host 'myfile'
$myfile | Where-Object {($_.Beer -match $b2)}  | Sort-Object Beer | Format-Table

Write-Host 'compare array'
$comparearray | Where-Object {($_.DateTasted -Match $d)}  | Sort-Object Beer | Format-Table

$o2 = $comparearray | Where-Object {($_.Beer -Match $b2) -and ($_.DateTasted -Match $d )}   
Write-Host 'o2 is' $o2
$o2beer = $o2.Beer
[double]$o2date = $o2.DateTasted
Write-host 'o2beer is' $o2beer
$o2beer = $o2beer.Replace('(', '\(')
$o2beer = $o2beer.Replace(')', '\)')
Write-Host 'o2beer now' $o2beer

$myobj = $myfile | Where-Object {($_.Beer -Match $b2) -and ($_.DateTasted -Match $d )}   

$o1 = $myfile | Where-Object {($_.Beer -Match $o2beer) -and ($_.DateTasted -Match $o2date )}   

$o1
$o1.Beer -eq $o2.Beer
$o1.DateTasted -eq $o2.DateTasted
#>