#
# 20240119 mrm added worksheet for error list
# 20240211 mrm add sheet for unique brewer names

[array]$sourcearray = @()
$sourcearray = Import-Excel -Path 'C:\Users\matt\OneDrive\Beer Club\NewCombinedList.xlsx' -Raw
Write-Host 'file imported'
#get unique styles
[array]$array = $sourcearray | Select-Object StatedStyle -Unique |  Sort-Object StatedStyle    
Write-Host 'found' $array.Count 'styles'
$array | Select-Object -First 5 

#$sourcearray | Group-Object StatedStyle | Sort-Object Name | Where-Object Count -eq 1 | Select-Object Name, Count, Group.Beer, Group.Brewer, Group.StateCountry, Group.ABV, Group.DateTasted

[array]$brewerarray = @()
$brewerarray = $sourcearray | Where-Object -Property StatedStyle -NotLike 'Other Beverage*' | Group-Object Brewer, City, StateCountry  | Sort-Object Brewer 

[array]$errorlist = @()
$grouparray = $sourcearray | Where-Object -Property StatedStyle -NotLike 'Other Beverage*' | Group-Object StatedStyle  | Sort-Object Name | Where-Object Count -lt 7 
foreach($row in $grouparray) {
    [string]$style = $row.Name
    [string]$count = $row.Count
    foreach($g in $row.Group) {
        $obj = new-object PSObject
        $obj | add-member -membertype NoteProperty -name "Style" -Value $style
        $obj | add-member -membertype NoteProperty -name "Count" -Value $count
        $obj | add-member -membertype NoteProperty -name "Beer" -Value $g.Beer
        $obj | add-member -membertype NoteProperty -name "Brewer" -Value $g.Brewer
        $obj | add-member -membertype NoteProperty -name "StateCountry" -Value $g.StateCountry
        $obj | add-member -membertype NoteProperty -name "ABV" -Value $g.ABV
        $obj | add-member -membertype NoteProperty -name "DateTasted" -Value $g.DateTasted
        $errorlist += $obj    
    }
}

[array]$toplist = @()
$toparray = $sourcearray | Where-Object -Property StatedStyle -NotLike 'Other Beverage*' | Group-Object StatedStyle | Where-Object Count -gt 100  | Sort-Object Name 
foreach($row in $toparray) {
    [string]$style = $row.Name
    $top5array = $row.Group | Sort-Object OverallScore, DateTasted -Descending | Select-Object -First 5
    foreach($g in $top5array) {
        $obj = new-object PSObject
        $obj | add-member -membertype NoteProperty -name "Style" -Value $style
        $obj | add-member -membertype NoteProperty -name "Beer" -Value $g.Beer
        $obj | add-member -membertype NoteProperty -name "Brewer" -Value $g.Brewer
        $obj | add-member -membertype NoteProperty -name "StateCountry" -Value $g.StateCountry
        $obj | add-member -membertype NoteProperty -name "ABV" -Value $g.ABV
        $obj | add-member -membertype NoteProperty -name "DateTasted" -Value $g.DateTasted
        $obj | add-member -membertype NoteProperty -name "OverallScore" -Value $g.OverallScore
        $toplist += $obj    
    }
}


[array]$avgscorelist = @()
$avgscorearray = $sourcearray | Where-Object -Property StatedStyle -NotLike 'Other Beverage*' | Group-Object DateTasted
foreach($row in $avgscorearray) {
    [string]$datetasted = $row.Name
    [string]$beerlist = ''
    [int]$count = 0
    [decimal]$abv = 0
    [decimal]$avgscore = 0
    foreach($g in $row.Group) {
        $count +=1
        $avgscore += $g.OverallScore
        $abv += $g.ABV
        [string]$temp = $g.Beer
        $beerlist += ($temp + ';')
        #Write-Host $g
    }
    $obj = new-object PSObject
    $obj | add-member -membertype NoteProperty -name "DateTasted" -Value $datetasted
    $obj | add-member -membertype NoteProperty -name "Count" -Value $count
    $obj | add-member -membertype NoteProperty -name "AvgScore" -Value ($avgscore / $count)
    $obj | add-member -membertype NoteProperty -name "ABV" -Value ($abv / $count)
    $obj | add-member -membertype NoteProperty -name "BeerList" -Value $beerlist
    $avgscorelist += $obj    
}
Remove-Item 'C:\Users\matt\OneDrive\Beer Club\avgscorelist.xlsx' 
$excelpkg3 = $avgscorelist | Export-Excel -PassThru -AutoSize -WorksheetName 'AvgScores' -Path 'C:\Users\matt\OneDrive\Beer Club\avgscorelist.xlsx' -TableName 'AvgScores' -TableStyle Medium16 
Set-ExcelColumn -ExcelPackage $excelpkg3 -WorksheetName "AvgScores" -Column 5 -Width 150
Close-ExcelPackage -ExcelPackage $excelpkg3 -Show


Write-Host 'removing old files'
Remove-Item 'C:\Users\matt\OneDrive\Beer Club\StatedStyle.xlsx'
Remove-Item 'C:\Users\matt\OneDrive\Beer Club\top5list.xlsx' 
$excelpkg1 = $array | Export-Excel -PassThru -AutoSize -WorksheetName 'Styles' -Path 'C:\Users\matt\OneDrive\Beer Club\StatedStyle.xlsx' -TableName 'Styles' -TableStyle Medium16 
Set-ExcelColumn -ExcelPackage $excelpkg1 -WorksheetName "Styles" -Column 1 -Width 30
$sourcearray | Group-Object StatedStyle | Sort-Object Name | Select-Object Name, Count | Export-Excel -PassThru -AutoSize -WorksheetName 'StyleCount' -ExcelPackage $excelpkg1 -TableName 'StyleCount' -TableStyle Medium16 
Set-ExcelColumn -ExcelPackage $excelpkg1 -WorksheetName "StyleCount" -Column 1 -Width 30
$errorlist | Sort-Object Count, Style | Export-Excel -PassThru -AutoSize -WorksheetName 'LowCountStyles' -ExcelPackage $excelpkg1 -TableName 'LowCountStyles' -TableStyle Medium16 
$brewerarray | Select-Object Name, Count | Sort-Object Name | Export-Excel -PassThru -AutoSize -WorksheetName 'BrewerCount' -ExcelPackage $excelpkg1 -TableName 'BrewerCount' -TableStyle Medium16 
$excelpkg2 = $toplist | Export-Excel -PassThru -AutoSize -WorksheetName 'TopList' -Path 'C:\Users\matt\OneDrive\Beer Club\top5list.xlsx' -TableName 'TopList' -TableStyle Medium16 


Close-ExcelPackage -ExcelPackage $excelpkg1 -Show
Close-ExcelPackage -ExcelPackage $excelpkg2 -Show

#Remove-Item 'C:\Users\matt\OneDrive\Beer Club\StatedStyle_Count.xlsx'
#$sourcearray | Group-Object StatedStyle | Sort-Object Name | Select-Object Name, Count | Export-Excel -Path 'C:\Users\matt\OneDrive\Beer Club\StatedStyle_Count.xlsx' -TableName 'StyleCount' -TableStyle Medium16 -Show