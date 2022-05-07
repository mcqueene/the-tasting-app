
$updatefilelist = Get-ChildItem -Path "C:\Users\matt\OneDrive\Beer Club\" -Filter '*update*.xlsx'
[array]$mergearray = $null

foreach($updatefile in $updatefilelist) {
    $file = Import-Excel -Path $updatefile -Raw
    #dir $updatefile | Get-ExcelFileSummary | ft
    $filteredrows = $file | ? {( $_.Date -ne $null) -and ($_.Beer -ne $null) } 
    [int]$rowcount = 2

    foreach($row in $filteredrows) {
        [int]$id = $rowcount
        [string]$Beer = $row.Beer

        [string]$DateTasted = ''
        if($row.Date -as [double]) {
            $DateTasted = [DateTime]::FromOADate($row.Date)
        }
        else {
            if($row.Date -as [DateTime]) {
                $DateTasted = [DateTime]::Parse($row.Date)
            }
            else {
                $DateTasted = [datetime]::parseexact($row.Date, 'yyyy/mm/dd', $null)
            }
        }
        if(!$DateTasted) {
             Write-Host 'Error on row' $rowcount 'with Date value:' $row.Date
        }
        [string]$StatedStyle = $row."Stated Style"
        [string]$Container = $row.Container
        [decimal]$Taste = 0
        if($row.Taste -as [decimal]) {
            $Taste = $row.Taste
        } else {
            Write-Host 'Error on row' $rowcount 'beer' $Beer 'with taste value:' $row.Taste
        }
        [decimal]$Style = 0
        if($row.Style -as [decimal])
        {
            $Style = $row.Style
        }
 
        [decimal]$OverallScore = 0
        if($row."Overall Score" -as [decimal]) {
            $OverallScore = $row."Overall Score"
        } else {
            $OverallScore = $Taste + $Style
            if($OverallScore -eq 0) {
                Write-Host 'Error on row' $rowcount 'beer' $Beer 'with overall value:' $row."Overall Score"
            }
        }
        [string]$Brewer = $row.Brewer
        [string]$City = $row.City
        [string]$StateCountry = $row."State/Country"
        [string]$Comments = $row.Comments
        [string]$ABV_temp = $row.ABV
        [decimal]$ABV = 0
        $ABV_temp = $ABV_temp.Replace('%','')
        $ABV_temp = $ABV_temp.Replace('abw','')
        if($ABV_temp -as [decimal]) {
            $ABV = $ABV_temp;    
        }
        else {
            #Write-Host 'Error on row' $rowcount 'beer' $Beer 'with ABV value:' $row.ABV 'converted to' $ABV_temp
        }
        $ABV = $ABV * 100
    
        $rowcount++
        $obj = new-object PSObject
        $obj | add-member -membertype NoteProperty -name "id" -Value $id
        $obj | add-member -membertype NoteProperty -name "Beer" -Value $Beer
        $obj | add-member -membertype NoteProperty -name "DateTasted" -Value $DateTasted
        $obj | add-member -membertype NoteProperty -name "StatedStyle" -Value $StatedStyle
        $obj | add-member -membertype NoteProperty -name "Container" -Value $Container
        $obj | add-member -membertype NoteProperty -name "Taste" -Value $Taste
        $obj | add-member -membertype NoteProperty -name "Style" -Value $Style
        $obj | add-member -membertype NoteProperty -name "OverallScore" -Value $OverallScore
        $obj | add-member -membertype NoteProperty -name "Brewer" -Value $Brewer
        $obj | add-member -membertype NoteProperty -name "City" -Value $City
        $obj | add-member -membertype NoteProperty -name "StateCountry" -Value $StateCountry
        $obj | add-member -membertype NoteProperty -name "Comments" -Value $Comments
        $obj | add-member -membertype NoteProperty -name "ABV" -Value $ABV

        $mergearray += $obj
    }

}
$mergearray | 
    Sort-Object -Property DateTasted -Descending |
    ConvertTo-Json -depth 100 -Compress | Out-File -Encoding ASCII "merged_update_list.json"
