. .\src\scripts\tasting_file_to_array_function.ps1 -Verbose
. .\src\scripts\normalize_data_functions.ps1
#
# recreates the master list by reading the original master then all the archived updates
#
#20240227 mrm copied from tasting_excel_to_json

$d_start = get-date
$datestr = $d_start.ToString("yyyyMMdd")
[string]$sourcedir = "C:\Users\matt\OneDrive\Beer Club\archived_updates\"
$out_fixed_master_json_file = 'C:\Users\matt\OneDrive\Beer Club\fixed_list_' +  $datestr + '.json'
$out_fixed_master_excel_file = 'C:\Users\matt\OneDrive\Beer Club\fixed_list_' +  $datestr + '.xlsx'

$input_master_file = (Get-ChildItem -Path $sourcedir -Filter '*Master Copy*.xlsx' | Sort-Object LastWriteTime | Select-Object -Last 1).FullName
Write-Host "Start at $(Get-Date) with file" $input_master_file
$file = Import-Excel -Path $input_master_file -WorksheetName "Beer" -Raw

[array]$newarray = $null
$newarray = TastingFileToArray -File $file -RowCount 2 -FileName $input_master_file | Sort-Object -Property id 

$updatefilelist = Get-ChildItem -Path $sourcedir -Filter '*taste update*.xlsx'
[array]$mergearray = $null
foreach($updatefile in $updatefilelist) {
    [string]$filepath = $sourcedir + $updatefile
    $file = Import-Excel -Path $filepath -Raw
    $cnt = $newarray.Length + $mergearray.Length + 1
    $mergearray += TastingFileToArray -File $file -RowCount $cnt -FileName $updatefile
}

$mergearray = $mergearray |  Sort-Object -Property DateTasted -Descending 

[array]$sortedarray = $null
$sortedarray += $newarray
$sortedarray += $mergearray
$sortedarray = $sortedarray | Sort-Object keyv2 -Unique | Sort-Object -Property @{Expression = "DateTasted"; Descending = $true}, @{Expression = "Beer"; Descending = $false}
[int]$cnt = $newarray.Length + $mergearray.Length
Write-Host "master count" $newarray.Length "merge count" $mergearray.Length "expected count" $cnt "sorted count" $sortedarray.Length
$sortedarray | Select-Object -First 15 | Format-Table

$combinedjson = $sortedarray |  ConvertTo-Json -Depth 100
$combinedjson | Out-File -FilePath $out_fixed_master_json_file
$sortedarray | Export-Excel -Path $out_fixed_master_excel_file -TableName 'FixedMasterList' -TableStyle Medium16 -Show

#get unique dates
[array]$datearray = $sortedarray | Select-Object DateTasted -Unique | Select-Object -Property @{ 
    Name='MyDate';Expression={[DateTime]::ParseExact($($_.DateTasted), "yyyyMMdd", $null)}}, DateTasted |
    Sort-Object MyDate -Unique -Descending
    
$datearray | Select-Object -First 5 