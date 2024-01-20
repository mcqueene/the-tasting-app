
#20240119 mrm added read-host to enter beer name

$updatefilelist = Get-ChildItem -Path "C:\Users\matt\OneDrive\Beer Club\archived_updates\" -Filter '*taste update*.xlsx'
[array]$mergearray = $null
[string]$searchstring = Read-Host "Enter beer name to find"
foreach($updatefile in $updatefilelist) {
    [string]$filename = "C:\Users\matt\OneDrive\Beer Club\archived_updates\" + $updatefile
    $file = Import-Excel -Path $filename -Raw
    $filerows =  $file | Select-Object "Date","Beer","Stated Style","Container","Taste","Style","Overall Score","Brewer","City","State/Country","Comments","ABV","IBU","Org Gravity"
    #Write-Host 'searching' $updatefile
    foreach($row in $filerows) {
        [string]$Beer = $row.Beer
        if($Beer -match $searchstring) {
            Write-Host -Foregroundcolor Red 'found' $Beer $updatefile
        }
    }
}
