# convert tasting csv file to json
# 20211003 mrm created

$d_start = get-date
$datestr = $d_start.ToString("yyyyMMdd")
Write-Host "Start at $(Get-Date)"

$input_master_csv_file = (Get-ChildItem -Path "C:\Users\matt\OneDrive\Beer Club\" -Filter '*Master Copy*.csv' | Sort LastWriteTime | Select -Last 1).FullName

#$outUserGroupJson = "C:\Users\mmcqueeney\source\GitHub\prb-oneprb\data_samples\group_to_user_hashtable.json"
$out_master_json_file = 'C:\Users\matt\OneDrive\Beer Club\btg_master_list_' +  $datestr + '.json'
$out_master_json_file_compressed = 'C:\Users\matt\OneDrive\Beer Club\btg_master_list_' +  $datestr + '.json'

Write-Host -ForegroundColor Yellow "Reading file" $input_master_csv_file 

$input_master_file = $null

$input_master_file =  Get-Content -Path $input_master_csv_file | 
    ConvertFrom-Csv |
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
    if($row.Date -as [DateTime]) {
        $DateTasted = [DateTime]::Parse($row.Date)
    }
    else {
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
        Write-Host 'Error on row' $rowcount 'beer' $Beer 'with overall value:' $row."Overall Score"
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



#create json user file
#$input_master_file | #Add-Member -MemberType AliasProperty -Name id -Value Beer + Date -PassThru |
#    Sort-Object -Property Date |
    #Select-Object Date, Beer, Container,Taste,Style,Overall Score,Brewer,City,ABV |
    #ConvertTo-Json -depth 100 -Compress | Out-File -Encoding ASCII $out_master_json_file

#    ConvertTo-Json -depth 100  | Out-File -Encoding ASCII $out_master_json_file    
