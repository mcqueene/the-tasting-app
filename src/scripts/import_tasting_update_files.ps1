. 'C:\Users\matt\OneDrive\Beer Club\tasting_file_to_array_function.ps1'

[array]$sourcearray = Import-Excel -Path 'C:\Users\matt\OneDrive\Beer Club\NewCombinedList.xlsx' -Raw 
$sourcearray | Select-Object -First 100 | Select-Object -Property @{name='Date';expression={$_.DateTasted}}, Beer, `
    @{name='Stated Style';expression={$_.'StatedStyle'}}, Container, Taste, Style, @{name='Overall Score ';expression={$_.OverallScore}}, `
    Brewer, City, @{name='State/Country';expression={$_.StateCountry}}, Comments, ABV, @{name='Org Gravity';expression={$_.OrgGravity}}, IBU
      
    [array]$newarray = $null
    $newarray = TastingFileToArray -File $file -RowCount 2 -FileName $input_master_file
    

$updatefilelist = Get-ChildItem -Path "C:\Users\matt\OneDrive\Beer Club\" -Filter '*taste update*.xlsx'
[array]$mergearray = @()

#Select "Date","Beer","Stated Style","Container","Taste","Style","Overall Score","Brewer","City","State/Country","Comments","ABV","IBU","Org Gravity"
#Date	Beer	Stated Style	Container	Taste	Style	Overall Score	Brewer	City	State/Country	Comments	ABV	Org Gravity	IBU
#Beer	DateTasted	StatedStyle	ABV	Taste	Style	OverallScore	Brewer	City	StateCountry	Comments	Container	IBU	OrgGravity	Vintage	id	key	keyBeerBrewer

#archive old combined list
#read old combined list | reformat to old layout
#send old combined list thru the to array function to regenerate the keys
#get list of update files
#loop update files thru array function to generate a merge array
#merge the old list with the merge array
#sort
#create new combined
#archive update files