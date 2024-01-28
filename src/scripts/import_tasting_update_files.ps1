. "C:\Users\matt\Documents\GitHub\the-tasting-app\src\scripts\tasting_array_to_calculated_array_function.ps1"

# 20240127 mrm add auto size to export excel 

$d_start = get-date
$datestr = $d_start.ToString("yyyyMMdd")
[string]$inputfile_newcombinedlist = 'C:\Users\matt\OneDrive\Beer Club\NewCombinedList.xlsx'
[string]$sourcedirupdatefiles = "C:\Users\matt\OneDrive\Beer Club\"
[string]$archivedir = "C:\Users\matt\OneDrive\Beer Club\archived_updates\"

#backup old combined list
$backup_master_file_json = 'C:\Users\matt\OneDrive\Beer Club\backedup_master_lists\btg_master_list_combined_' +  $datestr + '.json'
$backup_newcombined_file_excel = 'C:\Users\matt\OneDrive\Beer Club\backedup_master_lists\NewCombinedList_' +  $datestr + '.xlsx'
[string]$yn_backup_current_files = Read-Host "Enter y backup btg_master_list_combined.json and NewCombinedList.xlsx"
if($yn_backup_current_files) {
    Copy-Item 'C:\Users\matt\OneDrive\Beer Club\btg_master_list_combined.json' -Destination $backup_master_file_json
    Copy-Item 'C:\Users\matt\OneDrive\Beer Club\NewCombinedList.xlsx' -Destination $backup_newcombined_file_excel
}

#read old combined list | reformat to old layout
[array]$sourcearray = Import-Excel -Path $inputfile_newcombinedlist -Raw 
[array]$convertedarray = $sourcearray | Select-Object -Property @{name='Date';expression={$_.DateTasted}}, Beer, `
    @{name='Stated Style';expression={$_.'StatedStyle'}}, Container, Taste, Style, @{name='Overall Score ';expression={$_.OverallScore}}, `
    Brewer, City, @{name='State/Country';expression={$_.StateCountry}}, Comments, ABV, @{name='Org Gravity';expression={$_.OrgGravity}}, IBU
      
#send old combined list thru the to array function to regenerate the keys
[array]$newarray = $null
$newarray = TastingArrayToCalculatedArray -InputArray $convertedarray -FileName $inputfile_newcombinedlist
    
#get list of update files
$updatefilelist = Get-ChildItem -Path "C:\Users\matt\OneDrive\Beer Club\" -Filter '*taste update*.xlsx'

[int]$expectedrowcount = $newarray.Count
#loop update files thru array function to generate a merge array
[array]$mergearray = @()
foreach($updatefile in $updatefilelist) {
    [array]$filecontents = @()
    [string]$filepath = $sourcedirupdatefiles + $updatefile
    $filecontents = Import-Excel -Path $filepath -Raw
    $expectedrowcount += $filecontents.Count
    $mergearray += TastingArrayToCalculatedArray -InputArray $filecontents -FileName $updatefile
}
$mergearray | 
    Sort-Object -Property DateTasted -Descending |
    ConvertTo-Json -depth 100 -Compress | Out-File -Encoding ASCII ($sourcedirupdatefiles + "merged_update_list.json")

#merge the old list with the merge array
[array]$sortedarray = $null
$sortedarray += $newarray
$sortedarray += $mergearray

#sort
$sortedarray = $sortedarray | Sort-Object key -Unique | Sort-Object -Property @{Expression = "DateTasted"; Descending = $true}, @{Expression = "Beer"; Descending = $false}
if($expectedrowcount -ne $newarray.Length) {
    Write-Host -ForegroundColor Red "newarray count="$newarray.Length "merge count="$mergearray.Length "expected count="$expectedrowcount "sorted count="$sortedarray.Length
}
Write-Host 'Process complete - wrapping up'
$sortedarray | Select-Object -First 15 | Format-Table

#get unique dates
[array]$datearray = $sortedarray | Select-Object DateTasted -Unique | Select-Object -Property @{ 
    Name='MyDate';Expression={[DateTime]::ParseExact($($_.DateTasted), "yyyyMMdd", $null)}}, DateTasted |
    Sort-Object MyDate -Unique -Descending   
$datearray | Select-Object -First 5 

#mrm todo --> need to split out the alt beverages to separate array and put them on separate tab and maybe remove them from json extract

#create new combined
$combinedjson = $sortedarray |  ConvertTo-Json -Depth 100
[string]$fullpath_btg_master_list = ($sourcedirupdatefiles + "btg_master_list_combined.json")
[string]$fullpath_app_uploadfile = 'C:\Users\matt\Documents\GitHub\the-tasting-app\btg_master_list.json'
[string]$fullpath_new_combined_excel = ($sourcedirupdatefiles + "NewCombinedList.xlsx")
[string]$yn_update_files = Read-Host "Enter y to update btg_master_list_combined.json, copy it to the app, and export NewCombinedList.xlsx "
if($yn_update_files -eq 'y') {
    Write-Host 'updating new json master list for app' $fullpath_btg_master_list
    $combinedjson | Out-File -FilePath $fullpath_btg_master_list
    Write-Host 'copying to app upload json file' $fullpath_app_uploadfile
    Copy-Item $fullpath_btg_master_list $fullpath_app_uploadfile
    Write-Host 'updating new combined excel file' $fullpath_new_combined_excel
    Remove-Item -Path $fullpath_new_combined_excel -Force
    $sortedarray | Export-Excel -AutoSize -Path $fullpath_new_combined_excel -TableName 'MasterBeerList' -TableStyle Medium16 -Show
} else {
    Write-Host -ForegroundColor Yellow 'skipping update of files'
}

#archive update files
[string]$yn_archive_files = Read-Host "Enter y to archive update files to the folder" $archivedir
if($yn_archive_files -eq 'y') {
    foreach($updatefile in $updatefilelist) {
        [string]$fullpath = $sourcedirupdatefiles + $updatefile
        Write-Host 'moving file' $fullpath 'to dir' $archivedir
        Move-Item -Path $fullpath -Destination $archivedir
    }    
} else {
    Write-Host -ForegroundColor Yellow 'skipping the archive of update files'
}


#Select "Date","Beer","Stated Style","Container","Taste","Style","Overall Score","Brewer","City","State/Country","Comments","ABV","IBU","Org Gravity"
#Date	Beer	Stated Style	Container	Taste	Style	Overall Score	Brewer	City	State/Country	Comments	ABV	Org Gravity	IBU
#Beer	DateTasted	StatedStyle	ABV	Taste	Style	OverallScore	Brewer	City	StateCountry	Comments	Container	IBU	OrgGravity	Vintage	id	key	keyBeerBrewer
