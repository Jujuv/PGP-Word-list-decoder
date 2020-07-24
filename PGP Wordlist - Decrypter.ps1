<#
Role: Decode strings using PGP Word list.
Author: Jujuv
Version: 1.1
#>
param ([String]$EncryptedString)

$wordlist = Import-CSV -path $PSScriptRoot"\wordlist.csv" -ErrorAction Stop

 
if($EncryptedString.Length -eq 0) # If param EncrtyptedString has not been passed to script OR fed with empty string
    { $EncryptedString = Read-Host -Prompt "Please type string to decode" }

$output = New-Object Collections.Generic.List[string]

# Split input string every two alphanumeric char + Removes whitespaces
$parsed = $EncryptedString -replace '\s','' -split "([a-zA-Z0-9]{2})" | Where-Object {$_} -ErrorAction Stop

$i = 0;
foreach ($hex in $parsed)
{
    $search = $wordlist | Where-Object { $_.Hex -eq $hex}
        
    if($search.Hex -ne $hex) # No result found for HEX (bad input)
       {  $output.Add("????") 
          continue }
     
    if($i%2 -eq 0) # Even number
       { $output.Add($search.Even) }    
    else # Odd number 
       { $output.Add($search.Odd) }

    $i++      
}

Write-Host "`n------------- RESULT -------------" -BackgroundColor Black
Write-Host $output "`n" -NoNewLine -BackgroundColor Black
if(!$PSBoundParameters.ContainsKey('EncryptedString')) # If param "EncryptedString" has been passed to script
    { Read-Host -Prompt "Press any key to continue..." }