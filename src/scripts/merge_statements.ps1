
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
            $mergearray += $obj
        }
    }


}

foreach($x in $mergearray) {
    Write-Host $x.Date $x.Amount $x.Desc
}

