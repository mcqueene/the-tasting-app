. 'C:\Users\matt\OneDrive\Beer Club\tasting_file_to_array_function.ps1'
cd 'C:\Users\matt\OneDrive\Beer Club'

$d_start = get-date
$datestr = $d_start.ToString("yyyyMMdd")
$out_master_json_file = 'C:\Users\matt\OneDrive\Beer Club\btg_master_list_' +  $datestr + '.json'
$out_master_json_file_compressed = 'C:\Users\matt\OneDrive\Beer Club\btg_master_list_' +  $datestr + '.json'

$input_master_file = (Get-ChildItem -Path "C:\Users\matt\OneDrive\Beer Club\" -Filter '*Master Copy*.xlsx' | Sort LastWriteTime | Select -Last 1).FullName
#dir $input_master_file | Get-ExcelFileSummary | ft
Write-Host "Start at $(Get-Date) with file" $input_master_file
$file = Import-Excel -Path $input_master_file -WorksheetName "Beer" -Raw

[array]$newarray = $null
$newarray = TastingFileToArray -File $file -RowCount 2 -FileName $input_master_file

$newarray | 
    Sort-Object -Property id |
    ConvertTo-Json -depth 100 -Compress | Out-File -Encoding ASCII $out_master_json_file    

$updatefilelist = Get-ChildItem -Path "C:\Users\matt\OneDrive\Beer Club\" -Filter '*taste update*.xlsx'
[array]$mergearray = $null

foreach($updatefile in $updatefilelist) {
    $file = Import-Excel -Path $updatefile -Raw
    $cnt = $newarray.Length + $mergearray.Length + 1
    $mergearray += TastingFileToArray -File $file -RowCount $cnt -FileName $updatefile
}

$mergearray | 
    Sort-Object -Property DateTasted -Descending |
    ConvertTo-Json -depth 100 -Compress | Out-File -Encoding ASCII "merged_update_list.json"

[array]$sortedarray = $null
$sortedarray += $newarray
$sortedarray += $mergearray
#$sortedarray = $sortedarray | Sort-Object DateTasted, Beer, id -Unique | 
$sortedarray = $sortedarray | Sort-Object key -Unique | 
    Sort-Object -Property @{Expression = "DateTasted"; Descending = $true}, @{Expression = "Beer"; Descending = $false}
[int]$cnt = $newarray.Length + $mergearray.Length
Write-Host "master count" $newarray.Length "merge count" $mergearray.Length "expected count" $cnt "sorted count" $sortedarray.Length
$sortedarray | Select-Object -First 15 | Format-Table

#$combinedjson = $newarray + $mergearray |  ConvertTo-Json -Depth 100 | Sort-Object DateTasted, Beer, id -Unique | Sort-Object -Property @{Expression = "DateTasted"; Descending = $true}, @{Expression = "Beer"; Descending = $false}
$combinedjson = $sortedarray |  ConvertTo-Json -Depth 100
$combinedjson | Out-File -FilePath "btg_master_list_combined.json"
Copy-Item "C:\Users\matt\OneDrive\Beer Club\btg_master_list_combined.json"  'C:\Users\matt\Documents\GitHub\the-tasting-app\btg_master_list.json'

#Get-Content 'btg_master_list_combined.json' | ConvertFrom-Json | Sort-Object -Property 'DateTasted' -Descending | Export-Excel -Path './NewCombinedList.xlsx'

#$newarray + $mergearray  | Sort-Object -Property 'DateTasted' -Descending | Export-Excel -Path './NewCombinedList.xlsx'
#$combinedjson | ConvertFrom-Json | Sort-Object -Property @{Expression = "DateTasted"; Descending = $true}, @{Expression = "Beer"; Descending = $false} | Export-Excel -Path './NewCombinedList.xlsx'
#$combinedjson | ConvertFrom-Json | Sort-Object 'DateTasted' -Descending | Export-Excel -Path './NewCombinedList.xlsx'
$sortedarray | Export-Excel -Path './NewCombinedList.xlsx'

#get unique dates
[array]$datearray = $sortedarray | Select-Object DateTasted -Unique | Select-Object -Property @{ 
    Name='MyDate';Expression={[DateTime]::ParseExact($($_.DateTasted), "yyyyMMdd", $null)}}, DateTasted |
    Sort-Object MyDate -Unique -Descending
    
$datearray | Select-Object -First 5 