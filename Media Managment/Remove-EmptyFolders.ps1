<#
.SYNOPSIS
Removes all empty folders in path.
.DESCRIPTION
Removes all empty folders in path.
.EXAMPLE
Remove-EmptyFolders -path C:/media
.NOTES
   Author: Joey Kleinsorge
   Script provided "AS IS" without warranties or guarantees of any kind. USE AT YOUR OWN RISK. Public domain, no rights reserved.
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)] $path
  )
begin{
    $count = 0
}
process{
    $dirs = Get-ChildItem -path $path -directory -recurse 
    foreach ($dir in $dirs){
        $files = Get-ChildItem $dir.FullName
        if ($files.Count -eq 0){
            Write-Verbose -Message "Removing: $dir"
            Remove-Item -Path $dir}
            $count++
    }
}
end{
    Write-Verbose -Message "Removed $count folders"
}
