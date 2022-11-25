function GetYear{
    param (
             [DateTime]$Date = $null
         )
    return $Date.Year
}

class TxnObj {
    [DateTime]$Date
    [string]$Desc
    [decimal]$Amount
    [int]$Year
    [string]$Cat
    [string]$Subcat
    [string]$Type

    TxnObj(){
        $this.Cat = 'unknown'
        $this.Subcat = 'unknown'
        $this.Type = 'E'
    }
    TxnObj(
        [DateTime]$dt,
        [string]$de,
        [decimal]$amt,
        [int]$yr,
        [string]$c,
        [string]$sc,
        [string]$t
    ){
        $this.Date = $dt
        $this.Desc = $de
        $this.Amount = $amt
        $this.Year = $yr
        $this.Cat = $c
        $this.Subcat = $sc
        $this.Type = $t
    }
}

class TypeDetail {
    [string]$Cat
    [string]$Subcat
    [string]$Type
    TypeDetail(){
        $this.Cat = 'unknown'
        $this.Subcat = 'unknown'
        $this.Type = 'E'
    }
    TypeDetail(
        [string]$c,
        [string]$sc,
        [string]$t
    ){
        $this.Cat = $c
        $this.Subcat = $sc
        $this.Type = $t
    }
}
function CheckTravel{
    param (
            [TypeDetail]$td,
            [String]$desc = ''
         )
    if( ($desc -match 'red horse inn') -or ($desc -match 'hotel salem')) {
        $td.Cat = 'Travel'
        $td.Subcat = 'Lodging'
        $td.Type = 'E'
    }
    return $td
}
function AddCategory{
    param (
            [PSObject]$obj = $null,
            [String]$desc = ''
         )
    [TypeDetail]$td = [TypeDetail]::new()
    [String]$match = 'n'
    if( ($desc -match 'Jerry') -or ($desc -match 'Rollertown') -or ($desc -match 'thirsty growler') -or ($desc -match '3 nations') -or ($desc -match 'specs') -or ($desc -match 'mckinney wine merchant') ) {
        $obj | add-member -membertype NoteProperty -name "Category" -Value 'Entertainment'
        $obj | add-member -membertype NoteProperty -name "SubCategory" -Value 'Booze'
        $match = 'y'
    }
    if( ($desc -match 'red horse inn') -or ($desc -match 'hotel salem')) {
        $obj | add-member -membertype NoteProperty -name "Category" -Value 'Travel'
        $obj | add-member -membertype NoteProperty -name "SubCategory" -Value 'Lodging'
        $match = 'y'
    }
    if( ($desc -match 'steam games')) {
        $obj | add-member -membertype NoteProperty -name "Category" -Value 'Entertainment'
        $obj | add-member -membertype NoteProperty -name "SubCategory" -Value 'Games'
        $match = 'y'
    }
    if(($desc -match 'chick-fil-a') -or ($desc -match 'Bavarian Grill') -or ($desc -match 'killa pie')) {
        $obj | add-member -membertype NoteProperty -name "Category" -Value 'Entertainment'
        $obj | add-member -membertype NoteProperty -name "SubCategory" -Value 'Food'
        $match = 'y'
   }

    if($desc -match 'COSERV') {
        $obj | add-member -membertype NoteProperty -name "Category" -Value 'Util'
        $obj | add-member -membertype NoteProperty -name "SubCategory" -Value 'Gas'
        $match = 'y'
    }
    if($desc -match 'TXU ENERGY') {
        $obj | add-member -membertype NoteProperty -name "Category" -Value 'Util'
        $obj | add-member -membertype NoteProperty -name "SubCategory" -Value 'Electric'
        $match = 'y'
    }
    if($desc -match 'Town of Prosper') {
        $obj | add-member -membertype NoteProperty -name "Category" -Value 'Util'
        $obj | add-member -membertype NoteProperty -name "SubCategory" -Value 'Town'
        $match = 'y'
    }
    if($desc -match 'tempo inc') {
        $obj | add-member -membertype NoteProperty -name "Category" -Value 'Util'
        $obj | add-member -membertype NoteProperty -name "SubCategory" -Value 'HVAC'
        $match = 'y'
    }
    if($desc -match 'uverse') {
        $obj | add-member -membertype NoteProperty -name "Category" -Value 'Util'
        $obj | add-member -membertype NoteProperty -name "SubCategory" -Value 'Internet'
        $match = 'y'
    }
    if( ($desc -match 'netflix') -or ($desc -match 'youtube') -or ($desc -match 'disney plus')) {
        $obj | add-member -membertype NoteProperty -name "Category" -Value 'Util'
        $obj | add-member -membertype NoteProperty -name "SubCategory" -Value 'TV'
        $match = 'y'
    }
    if($desc -match 'sprint wireless') {
        $obj | add-member -membertype NoteProperty -name "Category" -Value 'Util'
        $obj | add-member -membertype NoteProperty -name "SubCategory" -Value 'Cell'
        $match = 'y'
    }
    if($desc -match 'ntta') {
        $obj | add-member -membertype NoteProperty -name "Category" -Value 'Util'
        $obj | add-member -membertype NoteProperty -name "SubCategory" -Value 'Toll'
        $match = 'y'
    }
    if( ($desc -match 'Organicare') -or ($desc -match 'Orkin') -or ($desc -match 'Smith Thompson') -or ($desc -match 'Ring Year') ) {
        $obj | add-member -membertype NoteProperty -name "Category" -Value 'Services'
        $obj | add-member -membertype NoteProperty -name "SubCategory" -Value 'Home'
        $match = 'y'
    }
    if( ($desc -match 'the gents place') ) {
        $obj | add-member -membertype NoteProperty -name "Category" -Value 'Lifestyle'
        $obj | add-member -membertype NoteProperty -name "SubCategory" -Value 'Hair'
        $match = 'y'
    }
    if( ($desc -match 'Adobe') -or ($desc -match 'Backblaze') -or ($desc -match 'Zwift') -or ($desc -match 'pandora') ) {
        $obj | add-member -membertype NoteProperty -name "Category" -Value 'Services'
        $obj | add-member -membertype NoteProperty -name "SubCategory" -Value 'Software'
        $match = 'y'
    }
    if($desc -match "Dick's Sporting Good") {
        $obj | add-member -membertype NoteProperty -name "Category" -Value 'Lifestyle'
        $obj | add-member -membertype NoteProperty -name "SubCategory" -Value 'Excercise'
        $match = 'y'
    }

    if( ($desc -match 'LL Bean') -or ($desc -match 'fleet feet') -or ($desc -match 'jockey com')  ) {
        $obj | add-member -membertype NoteProperty -name "Category" -Value 'Lifestyle'
        $obj | add-member -membertype NoteProperty -name "SubCategory" -Value 'Clothing'
        $match = 'y'
    }
    if(($desc -match 'Lodge') -or ($desc -match 'Madeincook') -or ($desc -match 'Williams-Sonoma') -or ($desc -match 'Premier grilling')) {
        $obj | add-member -membertype NoteProperty -name "Category" -Value 'Lifestyle'
        $obj | add-member -membertype NoteProperty -name "SubCategory" -Value 'Cooking'
        $match = 'y'
    }
    if($desc -match 'Michael Jones') {
        $obj | add-member -membertype NoteProperty -name "Category" -Value 'Medical'
        $obj | add-member -membertype NoteProperty -name "SubCategory" -Value 'Dental'
        $match = 'y'
    }
    if( ($desc -match 'USMD') -or ($desc -match 'texas radiology') -or ($desc -match 'Texas Health') -or ($desc -match 'Careflite') -or ($desc -match 'OrthoTexas') -or ($desc -match 'Diagnostex') -or ($desc -match 'health texas') ) {
        $obj | add-member -membertype NoteProperty -name "Category" -Value 'Medical'
        $obj | add-member -membertype NoteProperty -name "SubCategory" -Value 'Health'
        $match = 'y'
    }
    if($desc -match 'American Express Bill Payment') {
        $obj | add-member -membertype NoteProperty -name "Category" -Value 'Payment'
        $obj | add-member -membertype NoteProperty -name "SubCategory" -Value 'Credit'
        $match = 'y'
    }
    if($desc -match 'Beginning balance') {
        $obj | add-member -membertype NoteProperty -name "Category" -Value 'Bank'
        $obj | add-member -membertype NoteProperty -name "SubCategory" -Value 'Balance'
        $match = 'y'
    }
    if($desc -match 'Interest Earned') {
        $obj | add-member -membertype NoteProperty -name "Category" -Value 'Bank'
        $obj | add-member -membertype NoteProperty -name "SubCategory" -Value 'Interest'
        $match = 'y'
    }
    if($desc -match 'Electronic Payment') {
        $obj | add-member -membertype NoteProperty -name "Category" -Value 'Credit Card'
        $obj | add-member -membertype NoteProperty -name "SubCategory" -Value 'Payment'
        $match = 'y'
    }
    if( ($desc -match 'scheduled transfer') -or ($desc -match 'DES:TRANSFER') -or ($desc -match 'DES:EFT') -or ($desc -match 'online banking transfer') ) {
        $obj | add-member -membertype NoteProperty -name "Category" -Value 'Bank'
        $obj | add-member -membertype NoteProperty -name "SubCategory" -Value 'Transfer'
        $match = 'y'
    }
    if($desc -match 'Kenneth Maun') {
        $obj | add-member -membertype NoteProperty -name "Category" -Value 'Taxes'
        $obj | add-member -membertype NoteProperty -name "SubCategory" -Value 'Property'
        $match = 'y'
    }
    if($desc -match 'US Treasury') {
        $obj | add-member -membertype NoteProperty -name "Category" -Value 'Taxes'
        $obj | add-member -membertype NoteProperty -name "SubCategory" -Value 'Federal'
        $match = 'y'
    }
    if( ($desc -match 'tom thumb') -or ($desc -match 'sweetmarias') -or ($desc -match 'market street') -or ($desc -match 'sprouts farmers') -or ($desc -match 'kroger')) {
        $obj | add-member -membertype NoteProperty -name "Category" -Value 'Home'
        $obj | add-member -membertype NoteProperty -name "SubCategory" -Value 'Food'
        $match = 'y'
    }
    if($desc -match 'state farm') {
        $obj | add-member -membertype NoteProperty -name "Category" -Value 'Home'
        $obj | add-member -membertype NoteProperty -name "SubCategory" -Value 'Insurance'
        $match = 'y'
   }
    if($desc -match "Lindy's Lawns") {
        $obj | add-member -membertype NoteProperty -name "Category" -Value 'Home'
        $obj | add-member -membertype NoteProperty -name "SubCategory" -Value 'Landscape'
        $match = 'y'
   }
    if( ($desc -match 'cvs') -or ($desc -match 'walmart.com')) {
        $obj | add-member -membertype NoteProperty -name "Category" -Value 'Home'
        $obj | add-member -membertype NoteProperty -name "SubCategory" -Value 'Misc'
        $match = 'y'
   }
    if($desc -match 'willow ridge') {
        $obj | add-member -membertype NoteProperty -name "Category" -Value 'Home'
        $obj | add-member -membertype NoteProperty -name "SubCategory" -Value 'HOA'
        $match = 'y'
   }
    if($desc -match 'bestbuyco') {
        $obj | add-member -membertype NoteProperty -name "Category" -Value 'Home'
        $obj | add-member -membertype NoteProperty -name "SubCategory" -Value 'Misc'
        $match = 'y'
   }
    if($desc -match "lowe's") {
        $obj | add-member -membertype NoteProperty -name "Category" -Value 'Home'
        $obj | add-member -membertype NoteProperty -name "SubCategory" -Value 'Maintenance'
        $match = 'y'
   }
   if( ($desc -match 'austin home') -or ($desc -match 'austin home')) {
        $obj | add-member -membertype NoteProperty -name "Category" -Value 'Home'
        $obj | add-member -membertype NoteProperty -name "SubCategory" -Value 'Hobbies'
        $match = 'y'
    }
    if( ($desc -match 'what a great dog') -or ($desc -match 'every dogs day') ) {
        $obj | add-member -membertype NoteProperty -name "Category" -Value 'Pets'
        $obj | add-member -membertype NoteProperty -name "SubCategory" -Value 'Care'
        $match = 'y'
    }
    if( ($desc -match 'total care animal') ) {
        $obj | add-member -membertype NoteProperty -name "Category" -Value 'Pets'
        $obj | add-member -membertype NoteProperty -name "SubCategory" -Value 'Medical'
        $match = 'y'
    }
    if(($desc -match 'hollywood feed') -or ($desc -match 'petsmart') -or ($desc -match 'chewy inc') ) {
        $obj | add-member -membertype NoteProperty -name "Category" -Value 'Pets'
        $obj | add-member -membertype NoteProperty -name "SubCategory" -Value 'Food'
        $match = 'y'
    }
    if(($desc -match 'exxon') -or ($desc -match '7-eleven') ) {
        $obj | add-member -membertype NoteProperty -name "Category" -Value 'Auto'
        $obj | add-member -membertype NoteProperty -name "SubCategory" -Value 'Gas'
        $match = 'y'
    }
    if(($desc -match 'ewing subaru') ) {
        $obj | add-member -membertype NoteProperty -name "Category" -Value 'Auto'
        $obj | add-member -membertype NoteProperty -name "SubCategory" -Value 'Maintenance'
        $match = 'y'
    }
    if($desc -match 'amazon marketplace') {
        $obj | add-member -membertype NoteProperty -name "Category" -Value 'Amazon'
        $obj | add-member -membertype NoteProperty -name "SubCategory" -Value 'Amazon'
        $match = 'y'
   }

    if( ($desc -match 'Check ') -and ($match -eq 'n')) {
        $obj | add-member -membertype NoteProperty -name "Category" -Value 'Bank'
        $obj | add-member -membertype NoteProperty -name "SubCategory" -Value 'Random Check'
        $match = 'y'
    }
    if($match -eq 'n') {
        $obj | add-member -membertype NoteProperty -name "Category" -Value 'Unknown'
        $obj | add-member -membertype NoteProperty -name "SubCategory" -Value 'Unknown'
    }
    return $obj
}

#$path = 'E:\Users\matt\Documents\files\Finance\statement_download\'
$path = 'C:\Users\matt\OneDrive\statements\'
$filelist = Get-ChildItem -Path $path -Filter '*.xlsx'
[array]$mergearray = $null

foreach($file in $filelist) {
    [string]$newpath = $path + $file 
    $temp = $null
    $doc = Import-Excel -Path $newpath -Raw
    Write-Host $doc.length $file.Name

    if($file.Name -like 'boa*') {
        $temp = $null
        $temp = $doc | select "Date", "Description", "Amount", "Running Bal." | where Date -ne $null       
        foreach($row in $temp) {
            $obj = new-object PSObject
            $obj | add-member -membertype NoteProperty -name "Date" -Value $row.Date
            $obj | add-member -membertype NoteProperty -name "Desc" -Value $row.Description
            $obj | add-member -membertype NoteProperty -name "Amount" -Value $row.Amount
            $obj | add-member -membertype NoteProperty -name "Year" -Value  (GetYear -Date $row.Date)
            $obj = AddCategory -obj $obj -desc $row.Description
            $mergearray += $obj
        }
    }
    if($file.Name -like '*7861.xlsx') {
        $temp = $null
        #$temp = $doc | select "Date", "Description", "Debit", "Month", "Month Count", "Monthly sum" | where Date -ne $null
        $temp = $doc | select "Date", "Description", "Debit", "Credit" | where Date -ne $null
               
        foreach($row in $temp) {
            [decimal]$d = $row.Debit
            [decimal]$c = $row.Credit
            $obj = new-object PSObject
            $obj | add-member -membertype NoteProperty -name "Date" -Value $row.Date
            $obj | add-member -membertype NoteProperty -name "Desc" -Value $row.Description
            if($d -eq 0) {
                $obj | add-member -membertype NoteProperty -name "Amount" -Value $row.Credit
            }
            else {
                $obj | add-member -membertype NoteProperty -name "Amount" -Value $row.Debit
            }
            $obj | add-member -membertype NoteProperty -name "Year" -Value  (GetYear -Date $row.Date)
            $obj = AddCategory -obj $obj -desc $row.Description
            $mergearray += $obj
        }
    }
    if($file.Name -like '*8676.xlsx') {
        $temp = $null
        $temp = $doc | select "Status", "Date", "Description", "Debit", "Credit" | where Status -ne $null
        foreach($row in $temp) {
            $obj = new-object PSObject
            $obj | add-member -membertype NoteProperty -name "Date" -Value $row.Date
            $obj | add-member -membertype NoteProperty -name "Desc" -Value $row.Description
            [decimal]$d = $row.Debit
            [decimal]$c = $row.Credit
            #Write-Host 'd=' $d 'c=' $c 
            if($d -eq 0) {
                #Write-Host '0 d='$d 'c='$c 'using' $c
                $obj | add-member -membertype NoteProperty -name "Amount" -Value $c
            }
            else {
                #Write-Host '1 d='$d 'c='$c 'using' $d
                $obj | add-member -membertype NoteProperty -name "Amount" -Value $d      
            }
            $obj | add-member -membertype NoteProperty -name "Year" -Value  (GetYear -Date $row.Date)
            $obj = AddCategory -obj $obj -desc $row.Description
           #Write-Host $obj
            $mergearray += $obj
        }

    }
    
    if($file.Name -like 'amex*') {
        $temp = $null
        $temp = $doc | select "Date", "Description", "Amount", "Extended Details", "Appears On Your Statement As", "Address", "City/State", "Zip Code", "Country", "Reference", "Category" | where Date -ne $null
        foreach($row in $temp) {
            $obj = new-object PSObject
            $obj | add-member -membertype NoteProperty -name "Date" -Value $row.Date
            $obj | add-member -membertype NoteProperty -name "Desc" -Value $row.Description
            $obj | add-member -membertype NoteProperty -name "Amount" -Value $row.Amount
            $obj | add-member -membertype NoteProperty -name "Year" -Value  (GetYear -Date $row.Date)
            $obj = AddCategory -obj $obj -desc $row.Description
            $mergearray += $obj
        }
    }
}
$missing = $mergearray | Where-Object -Property Category -eq 'unknown'
foreach($x in $missing) {
    Write-Host $x.Date $x.Amount $x.Desc $x.Year $x.Category $x.Subcategory
    if($x.Category -eq 'unknown') {
        #Write-Host $x.Date $x.Amount $x.Desc $x.Year $x.Category $x.Subcategory
    }
}
Write-Host 'total' $missing.Count

