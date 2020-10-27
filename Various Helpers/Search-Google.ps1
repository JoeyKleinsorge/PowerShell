 <#
.SYNOPSIS
Searched Google.com with search query entered.
.DESCRIPTION
Opens Google.com in default web browser.
.EXAMPLE
Search-Google -Search query
.NOTES
   Author: Joey Kleinsorge
   Script provided "AS IS" without warranties or guarantees of any kind. USE AT YOUR OWN RISK. Public domain, no rights reserved.
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$Search= $(throw "Enter a Search.")
    )

$Query = "http://www.google.com/search?q=$Search"

Start-Process  $Query