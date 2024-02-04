. 'C:\Users\matt\Documents\GitHub\the-tasting-app\src\scripts\normalize_data_functions.ps1'

#20240114 mrm copied from tasting_file_to_array_function.ps1
#20240119 mrm changed relative directory to direct path

function Test-DateTimePattern
{
    param(
        [string]$String,
        [string]$Pattern,
        [System.Globalization.CultureInfo]$Culture = (Get-Culture),
        [switch]$PassThru
    )
    $result = try{ [DateTime]::ParseExact($String,$Pattern,$Culture) } catch{}

    if($PassThru -and $result)
    {
        $result
    }
    else
    {
        [bool]$result
    }
}


function TastingArrayToCalculatedArray{
    param (
             [array]$InputArray,
             [string]$FileName = ''
         )

    [array]$filteredarray =  $InputArray | Select-Object "Date","Beer","Stated Style","Container","Taste","Style","Overall Score","Brewer","City","State/Country","Comments","ABV","IBU","Org Gravity"
    $filteredarray = $filteredarray | Where-Object {( $null -ne $_.Date) -and ($null -ne $_.Beer ) } 
    if($InputArray.Count -ne $filteredarray.Count) {
        Write-Host -ForegroundColor Red 'inputarray='$InputArray.Count 'filteredarray='$filteredarray.Count
    }

    [array]$newarray = $null
    foreach($row in $filteredarray) {
        [int]$id = $RowCount
        [string]$Beer = $row.Beer
        [string]$Vintage = ''
        $Vintage = ExtractVintage -InputKey $Beer
        if($Vintage -ne '') {
            $Beer = $Beer -replace $Vintage, ''
            $Beer = $Beer -replace '\(\)', ''
        }
        $Beer = $Beer.Trim()
        [string]$DateTasted = ''

        if(Test-DateTimePattern -String $row.Date -Pattern 'yyyyMMdd') {
            $DateTasted = [DateTime]::ParseExact($row.Date, 'yyyyMMdd',$null)
        }
        else {
            if($row.Date -as [double]) {
                $DateTasted = [DateTime]::FromOADate($row.Date)
            }
            else {
                if($row.Date -as [DateTime]) {
                    $DateTasted = [DateTime]::Parse($row.Date)
                }
                else {
                    $DateTasted = [DateTime]::parseexact($row.Date, 'yyyy/mm/dd', $null)
                }
            }    
        }


        if(!$DateTasted) {
             Write-Host 'Error on row' $rowcount 'with Date value:' $row.Date
        }
        else {
            [DateTime]$d = $DateTasted
            $DateTasted = $d.ToString("yyyyMMdd")
        }
        [string]$StatedStyle = $row."Stated Style"
        $StatedStyle = $StatedStyle.Trim()
        $StatedStyle = NormalizeStyle -InputString $StatedStyle


        [string]$Container = $row.Container
        $Container = $Container.Trim()
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
                #Write-Host 'Error on row' $rowcount 'beer' $Beer 'with overall value:' $row."Overall Score"
            }
        }
        [string]$Brewer = $row.Brewer
        $Brewer = $Brewer.Trim()
        [string]$s_Brewer = NormalizeBrewer -InputString $Brewer
        
        [string]$City = $row.City
        $City = $City.Trim()
        
        [string]$StateCountry = $row."State/Country"
        $StateCountry = $StateCountry.Trim()
        $StateCountry = NormalizeState -InputString $StateCountry
               
        [string]$Comments = $row.Comments
        $Comments = $Comments.Trim()
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
        if($ABV -lt 1) {
            $ABV = $ABV * 100
        }
        [string]$IBU = $row.IBU
        [string]$OrgGravity = $row."Org Gravity"
        [string]$key = $Beer + $DateTasted
        [string]$shortbrewername = ShortenBrewer -InputString $s_Brewer
        [string]$keyBeerBrewer = $Beer + $shortbrewername
        $key = NormalizeKey -InputKey $key
        $keyBeerBrewer = NormalizeKey -InputKey $keyBeerBrewer
        #$key = $key -replace '\W', ''
    
        $obj = new-object PSObject
        $obj | add-member -membertype NoteProperty -name "Beer" -Value $Beer
        $obj | add-member -membertype NoteProperty -name "DateTasted" -Value $DateTasted
        $obj | add-member -membertype NoteProperty -name "StatedStyle" -Value $StatedStyle
        $obj | add-member -membertype NoteProperty -name "ABV" -Value $ABV
        $obj | add-member -membertype NoteProperty -name "Taste" -Value $Taste
        $obj | add-member -membertype NoteProperty -name "Style" -Value $Style
        $obj | add-member -membertype NoteProperty -name "OverallScore" -Value $OverallScore
        $obj | add-member -membertype NoteProperty -name "Brewer" -Value $s_Brewer
        $obj | add-member -membertype NoteProperty -name "City" -Value $City
        $obj | add-member -membertype NoteProperty -name "StateCountry" -Value $StateCountry
        $obj | add-member -membertype NoteProperty -name "Container" -Value $Container
        $obj | add-member -membertype NoteProperty -name "IBU" -Value $IBU
        $obj | add-member -membertype NoteProperty -name "OrgGravity" -Value $OrgGravity
        $obj | add-member -membertype NoteProperty -name "Vintage" -Value $Vintage
        $obj | add-member -membertype NoteProperty -name "Comments" -Value $Comments
        $obj | add-member -membertype NoteProperty -name "id" -Value $id
        $obj | add-member -membertype NoteProperty -name "key" -Value $key
        $obj | add-member -membertype NoteProperty -name "keyBeerBrewer" -Value $keyBeerBrewer

        $newarray += $obj
        $RowCount++
    }

    Write-Host 'finished array count='$newarray.Length 'inputarray count='$InputArray.Count 'filename='$FileName
    Return $newarray
}