 <#
.SYNOPSIS
Searches directory for files names that contian the search cirteria.
.DESCRIPTION
By default, will only search file names. When -ReadScripts is used, it will find all files that contain the search criteria.
.EXAMPLE
Search-scripts -Search temp
.EXAMPLE
Search-scripts -Search temp -Path c:/scripts
.EXAMPLE
Search-scripts -Search temp -Path c:/scripts -ReadScripts
.NOTES
   Author: Joey Kleinsorge
   Script provided "AS IS" without warranties or guarantees of any kind. USE AT YOUR OWN RISK. Public domain, no rights reserved.

#>
param(
    [Parameter(Mandatory=$True)]
    [string]$Search,
    [Parameter(Mandatory=$False)]
    [string]$Path,
    [Parameter(Mandatory=$False)]
    [Switch]$ReadScripts 
    )  
process{
    if($Path){
        Set-location -path $Path
    }
    $scripts = Get-childitem -file -Recurse 
    if($ReadScripts){
        $scripts | Select-String -pattern $search | Group-Object path | Select-Object name
    }
    else {
        $scripts | Where-Object { $_.FullName -match $search }
    }
}
