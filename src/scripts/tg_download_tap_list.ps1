. 'C:\Users\matt\OneDrive\Beer Club\normalize_data_functions.ps1'

#20220730 mrm added normalize functions to use new brewerybeer key

cd 'C:\Users\matt\OneDrive\Beer Club'
[string]$tg_beer_list_json = Invoke-WebRequest -Uri  https://server.digitalpour.com/DashboardServer/api/v3/MenuItems/56ba39265e002c0c8446de27/1/Tap?apiKey=56ba38b25e002c0d38510298 

[array]$newmasterlist = Import-Excel -Path 'NewCombinedList.xlsx' -Raw
#$ht_source = @{}
#$newmasterlist | % {$ht_source[$_.key] = $_.DateTasted}

$tg_beer_list_json | Out-File -Force -Encoding ASCII 'c:\users\matt\OneDrive\Beer Club\tg_tap_list.json'

$json_objs = $tg_beer_list_json | ConvertFrom-Json
[array]$notfound = $null
[array]$justtapped = $null

foreach($beer in $json_objs) {
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
    #Write-Host $beer
    #Write-Host $tapnumber $dayson $beername $brewery $brewerylocation $beveragetype $shortbrewername $keyBeerBrewer

    if($beveragetype -eq 'Beer'){
        #[array]$foundlist = $newmasterlist | Where-Object Beer -Match $beername
        #[array]$foundlist = $newmasterlist | Where-Object key -Match $key
        
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

$notfound | Export-Csv -Path 'TG_NotFound_List.csv' -NoTypeInformation

Remove-Item -Path 'TG_NotFound_List.xlsx'  -Force
Remove-Item -Path 'TG_JustTapped_List.xlsx'  -Force

$notfound | Export-Excel -Path 'TG_NotFound_List.xlsx' 
$justtapped | Export-Excel -Path 'TG_JustTapped_List.xlsx'

$justtapped