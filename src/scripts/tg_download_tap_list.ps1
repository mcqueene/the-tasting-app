[string]$tg_beer_list_json = Invoke-WebRequest -Uri  https://server.digitalpour.com/DashboardServer/api/v3/MenuItems/56ba39265e002c0c8446de27/1/Tap?apiKey=56ba38b25e002c0d38510298 

[array]$newmasterlist = Import-Excel -Path 'NewCombinedList.xlsx' -Raw


$json_objs = $tg_beer_list_json | ConvertFrom-Json
[array]$notfound = $null

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
    #Write-Host $tapnumber $dayson $beername $brewery $brewerylocation

    if($beveragetype -eq 'Beer'){
        [array]$foundlist = $newmasterlist | Where-Object Beer -Match $beername
        if($foundlist.Length -eq 0) {
            Write-Host $tapnumber $beername $brewery $abv $active $dateon
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
            $notfound += $obj
        }
    }
}

$notfound | Export-Csv -Path 'TG_NotFound_List.csv' -NoTypeInformation
