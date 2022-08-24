$ht_state = @{
    “CA” = “California”
    "KS" = "Kansas"
    "OK" = "Oklahoma"
    “TX” = “Texas”
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
    “American Barley wine” = “American Barley Wine”
    “American barleywine” = “American Barley Wine”
    “American Barleyeine” = “American Barley Wine”
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

function NormalizeBrewer{
    param (
             [string]$InputString = ''
         )
    [string]$newvalue = $InputString
    [string]$searchvalue = $ht_brewer[$InputString]

    if ($searchvalue -eq '') {return $InputString} else {return $searchvalue}

}

function NormalizeStyle{
    param (
             [string]$InputString = ''
         )
    [string]$newvalue = $InputString
    [string]$searchvalue = $ht_style[$InputString]

    if ($searchvalue -eq '') {return $InputString} else {return $searchvalue}

}


#NormalizeState 'TX'
#NormalizeState 'OK'