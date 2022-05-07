$input_master_file = (Get-ChildItem -Path "C:\Users\matt\OneDrive\Beer Club\" -Filter '*Master Copy*.xlsx' | Sort LastWriteTime | Select -Last 1).FullName
$input_master_file
#dir $input_master_file | Get-ExcelFileSummary | ft
$file = Import-Excel -Path $input_master_file -WorksheetName "Beer" -Raw


$d_start = get-date
$datestr = $d_start.ToString("yyyyMMdd")
Write-Host "Start at $(Get-Date)"


$out_master_json_file = 'C:\Users\matt\OneDrive\Beer Club\btg_master_list_' +  $datestr + '.json'
$out_master_json_file_compressed = 'C:\Users\matt\OneDrive\Beer Club\btg_master_list_' +  $datestr + '.json'

$input_master_file = $null

$input_master_file =  $file | 
    #ConvertFrom-Csv |
    #ConvertFrom-Csv -Header "Date","Beer","Stated Style","Container","Taste","Style","Overall Score","Brewer","City","State/Country","Comments","ABV","Org Gravity","IBU" |   
    #ConvertFrom-Csv -Header "Date","Beer","Stated Style","Container","Taste","Style","Overall Score","Brewer","City","State/Country","Comments","ABV" # | Sort-Object -Property Date, Beer
    Select "Date","Beer","Stated Style","Container","Taste","Style","Overall Score","Brewer","City","State/Country","Comments","ABV" 
#filter blanks
$input_master_file = $input_master_file | ? {( $_.Date -ne $null) -and ($_.Beer -ne $null) } 

[int]$rowcount = 2
[array]$newarray = $null
foreach($row in $input_master_file) {
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

    $newarray += $obj
}

$newarray | 
    Sort-Object -Property id |
    ConvertTo-Json -depth 100 -Compress | Out-File -Encoding ASCII $out_master_json_file    



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

$combinedjson = $newarray + $mergearray |  ConvertTo-Json -Depth 100 | Sort-Object DateTasted, Beer, id -Unique | 
    Sort-Object -Property @{Expression = "DateTasted"; Descending = $true}, @{Expression = "Beer"; Descending = $false}
#$newarray + $mergearray | ConvertTo-Json -Depth 100 | Out-File -FilePath "btg_master_list_combined.json"
$combinedjson | Out-File -FilePath "btg_master_list_combined.json"

Copy-Item "btg_master_list_combined.json"  'C:\Users\matt\Documents\GitHub\the-tasting-app\btg_master_list.json'

#Get-Content 'btg_master_list_combined.json' | ConvertFrom-Json | Sort-Object -Property 'DateTasted' -Descending | Export-Excel -Path './NewCombinedList.xlsx'

#$newarray + $mergearray  | Sort-Object -Property 'DateTasted' -Descending | Export-Excel -Path './NewCombinedList.xlsx'
#$combinedjson | ConvertFrom-Json | Sort-Object -Property @{Expression = "DateTasted"; Descending = $true}, @{Expression = "Beer"; Descending = $false} | Export-Excel -Path './NewCombinedList.xlsx'
$combinedjson | ConvertFrom-Json | Sort-Object 'DateTasted' -Descending| Export-Excel -Path './NewCombinedList.xlsx'
#$newarray + $mergearray |  ConvertTo-Json -Depth 100 | Sort-Object DateTasted, Beer, id -Unique | Sort-Object -Property @{Expression = "DateTasted"; Descending = $true}, @{Expression = "Beer"; Descending = $false} |  Export-Excel -Path './NewCombinedList.xlsx'

#get unique dates
#for some reason you need to convert from json to array variable then select-object, a bug prevents it from piping in one line
$array = $combinedjson | ConvertFrom-Json
$array | Select-Object DateTasted -Unique | Select-Object -Property @{ 
    Name='MyDate';Expression={[DateTime]::ParseExact($($_.DateTasted), "MM/dd/yyyy HH:mm:ss", $null)}}, DateTasted |
    Sort-Object MyDate -Unique -Descending