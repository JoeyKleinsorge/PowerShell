 <#
.SYNOPSIS
Removes all periods from folder and file names.
.DESCRIPTION
Removes all periods from folder and file names.
.EXAMPLE
Remove-PeriodFromNames -path C:/media
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
    $folders = Get-ChildItem -Path $path -Recurse
    Foreach ($folder in $folders){
        $Newname = $folder.BaseName.Replace("."," ")
        if ( $Newname -ne $folder.Name){
            Rename-Item -path $folder.fullname -NewName $newname -ErrorAction SilentlyContinue
            $count++
        }
    }
}
end{
    Write-Verbose -Message "Removed $count folders"
}