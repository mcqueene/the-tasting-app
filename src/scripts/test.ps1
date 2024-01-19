
$updatefilelist = Get-ChildItem -Path "C:\Users\matt\OneDrive\Beer Club\" -Filter '*taste update*.xlsx'
foreach($updatefile in $updatefilelist) {
    Write-Host $updatefile
}

$updatefilelist = Get-ChildItem -Path "C:\Users\matt\OneDrive\Beer Club\archived_updates\" -Filter '*taste update*.xlsx'
[array]$mergearray = $null

foreach($updatefile in $updatefilelist) {
    [string]$filename = "C:\Users\matt\OneDrive\Beer Club\archived_updates\" + $updatefile
    $file = Import-Excel -Path $filename -Raw
    $filerows =  $file | Select-Object "Date","Beer","Stated Style","Container","Taste","Style","Overall Score","Brewer","City","State/Country","Comments","ABV","IBU","Org Gravity"
    #Write-Host 'searching' $updatefile
    foreach($row in $filerows) {
        [string]$Beer = $row.Beer
        if($Beer -match 'Citra Shenanigans') {
            Write-Host -Foregroundcolor Red 'found' $Beer $updatefile
        }
    }
}

#$ExecutionContext.SessionState.LanguageMode
function ShortenBrewer{
    param (
             [string]$InputString = ''
         )
    [string]$newvalue = $InputString
    $newvalue = $newvalue -replace 'Brewing Company',''
    $newvalue = $newvalue -replace 'Brewing Co',''
    $newvalue = $newvalue -replace 'Brewing Co.',''
    $newvalue = $newvalue -replace 'Brewing',''
    $newvalue = $newvalue -replace 'Brewery',''
    return $newvalue
}

function NormalizeKey {
    param ( [string]$InputKey = '')
    return ($InputKey -replace '[^a-zA-Z0-9]', '').ToLower()
}
$json_objs = Get-Content -Raw 'c:\users\matt\OneDrive\Beer Club\tg_tap_list.json' | ConvertFrom-Json
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
    #Write-Host $beer $beer.Id $beer.Active $beer.DatePutOn
    Write-Host $beveragetype $beername $keyBeerBrewer
    #$beer.GetType()
}


$test = '{ "key1":"value1", "key1":"value2", "key1":"value3" }' | ConvertFrom-Json 
foreach($x in $test) {
    Write-Host $x.key1
}