#. 'C:\Users\matt\OneDrive\Beer Club\normalize_data_functions.ps1'
. 'C:\Users\matt\Documents\GitHub\the-tasting-app\src\scripts\normalize_data_functions.ps1'

#20220730 mrm added normalize functions to use new brewerybeer key
#20240114 mrm update path to shared function files
#20240119 mrm added direct path and removed change directory
#20250321 mrm there was something going on with the tap feed that caused the json return to be different but later it fixed itself so I left the foreach logic in just in case

#cd 'C:\Users\matt\OneDrive\Beer Club'
[string]$tg_beer_list_json = Invoke-WebRequest -Uri  https://server.digitalpour.com/DashboardServer/api/v3/MenuItems/56ba39265e002c0c8446de27/1/Tap?apiKey=56ba38b25e002c0d38510298 

[array]$newmasterlist = Import-Excel -Path 'c:\users\matt\OneDrive\Beer Club\NewCombinedList.xlsx' -Raw
#$ht_source = @{}
#$newmasterlist | % {$ht_source[$_.key] = $_.DateTasted}

$tg_beer_list_json | Out-File -Force -Encoding ASCII 'c:\users\matt\OneDrive\Beer Club\tg_tap_list.json'

$json_objs = $tg_beer_list_json | ConvertFrom-Json
[array]$notfound = $null
[array]$justtapped = $null

foreach($beer in $json_objs) {
#foreach($beer in $json_objs.'$values') {
    $tapnumber = $beer.MenuItemDisplayDetail.DisplayName
    $dayson = $beer.MenuItemProductDetail.DaysOn
    $beername = $beer.MenuItemProductDetail.Beverage.BeverageName
    $brewery = $beer.MenuItemProductDetail.Beverage.Brewery.BreweryName
    $brewerylocation = $beer.MenuItemProductDetail.Beverage.Brewery.Location
    $style = $beer.MenuItemProductDetail.Beverage.BeerStyle.StyleName
    $beveragetype = $beer.MenuItemProductDetail.BeverageType
    $ibu = $beer.MenuItemProductDetail.Beverage.Ibu
    $abv = $beer.MenuItemProductDetail.Beverage.Abv
    $year = $beer.MenuItemProductDetail.Year
    $dateon = $beer.DatePutOn
    $active = $beer.Active
    $key = NormalizeKey -InputKey $beername
    [string]$shortbrewername = ShortenBrewer -InputString $brewery
    $keyBeerBrewer = NormalizeKey -InputKey ($beername + $shortbrewername)
    #Write-Host $beveragetype $beername $keyBeerBrewer
    #Write-Host $tapnumber $dayson $beername $brewery $brewerylocation $beveragetype $shortbrewername $keyBeerBrewer

    if($beveragetype -eq 'Beer'){
        #[array]$foundlist = $newmasterlist | Where-Object Beer -Match $beername
        #[array]$foundlist = $newmasterlist | Where-Object key -Match $key
        #Write-Host 'searching' $beername $brewery $shortbrewername $keyBeerBrewer
        [array]$foundlist = $newmasterlist | Where-Object keyBeerBrewer -Match $keyBeerBrewer

        #$find = $ht_source[$key]
        #if($find -eq $null) {
        
        if($foundlist.Length -eq 0) {
            Write-Host 'no match' $tapnumber $beername $brewery $style $abv $keyBeerBrewer
            #Write-Host $tapnumber $beername $brewery $abv $active $dateon $key
            #Write-Host 'no match->'$beername'<'

            $obj = new-object PSObject
            $obj | add-member -membertype NoteProperty -name "Tap" -Value $tapnumber
            $obj | add-member -membertype NoteProperty -name "BeerName" -Value $beername
            $obj | add-member -membertype NoteProperty -name "Abv" -Value $abv
            $obj | add-member -membertype NoteProperty -name "StatedStyle" -Value $style
            $obj | add-member -membertype NoteProperty -name "Brewery" -Value $brewery
            $obj | add-member -membertype NoteProperty -name "BreweryLocation" -Value $brewerylocation
            $obj | add-member -membertype NoteProperty -name "IBU" -Value $ibu
            $obj | add-member -membertype NoteProperty -name "Year" -Value $year
            $obj | add-member -membertype NoteProperty -name "DateKegged" -Value $dateon
            $obj | add-member -membertype NoteProperty -name "Active" -Value $active
            $obj | add-member -membertype NoteProperty -name "DaysOnTop" -Value $dayson

            $notfound += $obj
            if($dayson -le 2) {
                $justtapped += $obj
            }
        }
    }
}

#$notfound | Export-Csv -Path 'c:\users\matt\OneDrive\Beer Club\TG_NotFound_List.csv' -NoTypeInformation

Remove-Item -Path 'c:\users\matt\OneDrive\Beer Club\TG_NotFound_List.xlsx'  -Force
Remove-Item -Path 'c:\users\matt\OneDrive\Beer Club\TG_JustTapped_List.xlsx'  -Force

$excelpkg1 = $notfound | Export-Excel -PassThru  -WorksheetName 'NotFound' -Path 'c:\users\matt\OneDrive\Beer Club\TG_NotFound_List.xlsx' -TableName 'NotFound' -TableStyle Medium16
Set-ExcelColumn -ExcelPackage $excelpkg1 -WorksheetName "NotFound" -Column 2 -Width 30
Set-ExcelColumn -ExcelPackage $excelpkg1 -WorksheetName "NotFound" -Column 4 -Width 15
Set-ExcelColumn -ExcelPackage $excelpkg1 -WorksheetName "NotFound" -Column 5 -Width 25
$excelpkg2 = $justtapped | Export-Excel -PassThru  -WorksheetName 'JustTapped' -Path 'c:\users\matt\OneDrive\Beer Club\TG_JustTapped_List.xlsx' -TableName 'JustTapped' -TableStyle Medium16
Set-ExcelColumn -ExcelPackage $excelpkg2 -WorksheetName "JustTapped" -Column 2 -Width 30
Set-ExcelColumn -ExcelPackage $excelpkg2 -WorksheetName "JustTapped" -Column 4 -Width 15
Set-ExcelColumn -ExcelPackage $excelpkg2 -WorksheetName "JustTapped" -Column 5 -Width 25

Close-ExcelPackage -ExcelPackage $excelpkg1 -Show
Close-ExcelPackage -ExcelPackage $excelpkg2 -Show

$justtapped