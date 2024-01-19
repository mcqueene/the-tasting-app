$updatefilelist = Get-ChildItem -Path "C:\Users\matt\OneDrive\Beer Club\archived_updates\" -Filter '*taste update*.xlsx'
[array]$mergearray = $null

foreach($updatefile in $updatefilelist) {
    [string]$filename = "C:\Users\matt\OneDrive\Beer Club\archived_updates\" + $updatefile
    $file = Import-Excel -Path $filename -Raw
    $filerows =  $file | Select-Object "Date","Beer","Stated Style","Container","Taste","Style","Overall Score","Brewer","City","State/Country","Comments","ABV","IBU","Org Gravity"
    #Write-Host 'searching' $updatefile
    foreach($row in $filerows) {
        [string]$Beer = $row.Beer
        if($Beer -match 'Happy Holidiculous') {
            Write-Host -Foregroundcolor Red 'found' $Beer $updatefile
        }
    }
}
