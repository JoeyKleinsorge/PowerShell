<#
.SYNOPSIS
Copies unique files to alternate directory. 
.DESCRIPTION
Copies unique files to alternate directory. 
.EXAMPLE
Copy-UniqueFiles -path C:/scripts -copypath D:/git/scripts
.NOTES
   Author: Joey Kleinsorge
   Script provided "AS IS" without warranties or guarantees of any kind. USE AT YOUR OWN RISK. Public domain, no rights reserved.
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)] $path,
    [Parameter(Mandatory=$true)] $copypath
  )
process{
    $items = Get-ChildItem -Path $path  -Recurse | Sort-Object -Property Name -Unique 
    ForEach ($item in $items) { 
        Write-Verbose "Copying $item"
        Copy-Item -Path $item.fullname -Destination ($copypath + "/" + $item)
    }
}

