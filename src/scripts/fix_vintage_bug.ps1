#20240227 mrm fix vintage bug

[string]$inputfile_newcombinedlist = 'C:\Users\matt\OneDrive\Beer Club\NewCombinedList.xlsx'
[string]$fixedfile = 'C:\Users\matt\OneDrive\Beer Club\fixed_list_20240228.xlsx'
#read fixed list
[array]$fixedarray = Import-Excel -Path $fixedfile -Raw 
[array]$sourcearray = Import-Excel -Path $inputfile_newcombinedlist -Raw 

#get unique styles
[array]$fixedstyles = $fixedarray | Select-Object StatedStyle -Unique |  Sort-Object StatedStyle    
Write-Host 'found' $fixedstyles.Count 'styles'
$fixedstyles | Select-Object -First 5 
[array]$sourcestyles = $sourcearray | Select-Object StatedStyle -Unique |  Sort-Object StatedStyle    
Write-Host 'found' $sourcestyles.Count 'styles'

#for each 
[array]$errorlist = @()
[int]$foundcount = 0
foreach($row in $fixedarray) {
    # get old key
    [string]$key = $row.key
    [string]$keyv2 = $row.keyv2
    $foundrow = $sourcearray | Where-Object -Property key -eq $key
    if($foundrow -ne $null) {
        #Write-Host 'found' $key
        $row.Beer = $foundrow.Beer
        $row.StatedStyle = $foundrow.StatedStyle
        $row.ABV = $foundrow.ABV
        $row.Brewer = $foundrow.Brewer
        $row.City = $foundrow.City
        $row.StateCountry = $foundrow.StateCountry
        $foundcount++
    }
    else {
        #Write-Host -ForegroundColor Yellow 'not' $key
        $obj = new-object PSObject
        $obj | add-member -membertype NoteProperty -name "DateTasted" -Value $row.DateTasted
        $obj | add-member -membertype NoteProperty -name "Beer" -Value $row.Beer
        $obj | add-member -membertype NoteProperty -name "Brewer" -Value $row.Brewer
        $obj | add-member -membertype NoteProperty -name "key" -Value $row.key
        $obj | add-member -membertype NoteProperty -name "keyv2" -Value $row.keyv2
        $errorlist += $obj
    }
# read last btg master
# if found
#   update beer, statedstyle, abv, brewer, city, statecountry
# else ?? write to file?
# save New fixed file
# validate
# new fixed becomes new btg master
# test new merge process with recent updates
# update web app for vintage
}

Write-Host 'total' $fixedarray.Count 'found' $foundcount 'missing' $errorlist.Count 'old master count' $sourcearray.Count
Remove-Item 'C:\Users\matt\OneDrive\Beer Club\fixed_not_found.xlsx'
$excelpkg1 = $errorlist | Export-Excel -PassThru -AutoSize -WorksheetName 'NotFound' -Path 'C:\Users\matt\OneDrive\Beer Club\fixed_not_found.xlsx' -TableName 'fixednotfound' -TableStyle Medium16 
$excelpkg2 = $fixedarray | Export-Excel -PassThru -AutoSize -Path 'C:\Users\matt\OneDrive\Beer Club\fixed_list_20240228_post_updates.xlsx' -TableName 'MasterBeerList' -TableStyle Medium16 
Close-ExcelPackage -ExcelPackage $excelpkg1 -Show
Close-ExcelPackage -ExcelPackage $excelpkg2 -Show
#get unique styles
[array]$newfixedstyles = $fixedarray | Select-Object StatedStyle -Unique |  Sort-Object StatedStyle    
Write-Host 'found' $newfixedstyles.Count 'styles'
