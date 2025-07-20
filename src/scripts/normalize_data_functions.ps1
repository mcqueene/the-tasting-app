
# 20240114 mrm fixed normalizebrewer to only replace at end of string with \s*$
# 20240726 mrm added meadery to the shorten brewer
# 20250718 mrm todo add Klosterbrauerei (ex Weltenburg), Privatbrauerei, and even brauerei to shortenbrewer function?

<#
'2020 matt' -replace "^([2][0][012][0-9])", '**'
$found = '2021 matt' -match '^([2][0][012][0-9])'
if ($found) {
    $matches[1]
}
'2021 matt brewing CO' -match 'co$'
'2021 matt brewing COmpany' -match 'co$'
#>
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
    $newvalue = $newvalue -replace 'Meadery',''
    $newvalue = $newvalue -replace 'Klosterbrauerei',''
    $newvalue = $newvalue -replace 'Privatbrauerei',''
    $newvalue = $newvalue -replace 'brauerei',''
    return $newvalue
}

function NormalizeBrewer{
    param (
             [string]$InputString = ''
         )
    [string]$newvalue = $InputString
    $newvalue = $newvalue -replace "Brewing Co.\s*$","Brewing Company"
    $newvalue = $newvalue -replace 'Brewing Co\s*$','Brewing Company'
    $newvalue = $newvalue -replace 'Brewing\s*$','Brewing Company'
    #Write-Host -ForegroundColor Yellow '3normalizebrewer input='$InputString ' newvalue='$newvalue
    return $newvalue
}


function ExtractVintage {
    param ( [string]$InputKey = '')
    [string]$vintage = ''
    $found = $InputKey -match '^.*([2][0][012][0-9])'
    if($found) {
        $vintage = ($matches[1]).Trim()
    }
    return $vintage
}


$ht_state = @{
    “California” = “CA”
    "Kanas" = "KS"
    "Oklahoma" = "OK"
    “Texas” = “TX”
}

$ht_style = @{
    “Abbey Style” = “Abbey Ale”
    “Abbey Style Ale” = “Abbey Ale”
    “Amber” = “Amber Ale”
    “Ale,ESB” = “ESB”
    “Ale, ESB” = “ESB”
    “Ale, Rausch” = “Rauchbier”
    “Ale, Saisson” = “Saison”
    “Ale, Saisson, tripel” = “Saison”
    “Ale, Wheat” = “Wheat Beer”
    “Alt” = “Altbier”
    “Alt Beer” = “Altbier”
    “Alt bier” = “Altbier”
    “Amber Beer” = “Amber Ale”
    “Amber / Red” = “Amber Ale”
    “Amber/Red ale” = “Amber Ale”
    “Amber ale” = “Amber Ale”
    “American Barley wine” = “American Barleywine”
    “American barleywine” = “American Barleywine”
    “American Barleyeine” = “American Barleywine”
    "Amber lager" = "Amber Lager"
    "American Blonde" = "American Blonde Ale"
    "American Brown" = "American Brown Ale"
    "American Ipa" = "American IPA"
    "American lager" = "American Lager"
    "American light" = "American Light"
    "American PA" = "American Pale Ale"
    "American Pale" = "American Pale Ale"
    "American Pale ale" = "American Pale Ale"
    "American Plae" = "American Pale Ale"
    "American Plae Ale" = "American Pale Ale"
    "American sour" = "American Sour"
    "American Sour Ale" = "American Sour"
    "American Whaet" = "American Wheat Ale"
    "American Wheat" = "American Wheat Ale"
    "BA stout" = "Barrel Aged Stout"
    "BA Wee Heavy/Tripel" = "Barrel Aged Wee Heavy"
    "Baltic porter" = "Baltic Porter"
    "Barel Aged Barleywine" = "Barrel Aged Barleywine"
    "Barel Aged Stout" = "Barrel Aged Stout"
    "Barrely Wine" = "Barleywine"
    "Barely Wine" = "Barleywine"
    "Pis" = "Pilsner"
    "Pils" = "Pilsner"
}

$ht_brewer = @{
    “Tupps” = “Tupps Brewery”
    "Tupps Brewing" = "Tupps Brewery"
    "512 Brewers" = "512 Brewing Company"
    "512 Brewery" = "512 Brewing Company"
    "512 Brewing" = "512 Brewing Company"
    "903 Brewing" = "903 Brewers"
    "Allagash Brewery" = "Allagash Brewing Company"
    "Allagash Brewing" = "Allagash Brewing Company"
    "Alesmith" = "AleSmith Brewing Company"
    "Alesmith Brewing" = "AleSmith Brewing Company"
    "Alesmith Brewing Co" = "AleSmith Brewing Company"
    "AleSmith Brewing Co." = "AleSmith Brewing Company"
}

function NormalizeKey {
    param ( [string]$InputKey = '')
    return ($InputKey -replace '[^a-zA-Z0-9]', '').ToLower()
}

function NormalizeState{
    param (
             [string]$InputString = ''
         )
    [string]$newvalue = $InputString
    [string]$searchvalue = $ht_state[$InputString]

    if ($searchvalue -eq '') {return $InputString} else {return $searchvalue}

}


function NormalizeStyle{
    param (
             [string]$InputString = ''
         )
    [string]$newvalue = $InputString
    $newvalue = $newvalue -replace 'Barell ', 'Barrel '
    $newvalue = $newvalue -replace 'Barel', 'Barrel'
    $newvalue = $newvalue -replace 'Barrle ', 'Barrel '
    $newvalue = $newvalue -replace 'Barrlel ', 'Barrel '
    $newvalue = $newvalue -replace 'Barley Wine', 'Barleywine'
    $newvalue = $newvalue -replace 'Begian', 'Belgian'
    $newvalue = $newvalue -replace 'Begium', 'Belgian'
    $newvalue = $newvalue -replace 'Belgain', 'Belgian'
    $newvalue = $newvalue -replace ' aged', ' Aged'
    $newvalue = $newvalue -replace ' stout', ' Stout'
    $newvalue = $newvalue -replace ' ale', ' Ale'
    [string]$searchvalue = $ht_style[$newvalue]

    if ($searchvalue -eq '') {return $newvalue} else {return $searchvalue}

}


#NormalizeState 'Texas'
#NormalizeState 'TX'
#NormalizeState 'OK'
#ExtractVintage -InputKey 'ale 2022'
#ExtractVintage -InputKey 'ale (2022) test'
#ExtractVintage -InputKey '2001 ale test'
#ShortenBrewer '512 Brewing Co'