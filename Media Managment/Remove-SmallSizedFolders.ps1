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
    foreach ($folder in $dirs){
        $fullPath = $folder.FullName
        $foldersize = Get-Childitem -Path $fullPath -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue           
        if ($foldersize.sum -le 5000000){
            Write-Verbose -Message "Removing: $folder"
            Remove-Item -Path $fullPath -Recurse
            $count++
        }  
    }
}
end{
    Write-Verbose -Message "Removed $count folders"
}