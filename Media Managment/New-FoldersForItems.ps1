<#
.SYNOPSIS
Creates a folder for each file in path.
.DESCRIPTION
Will create a folder with the same name for each file in the path and move the file into the folder.
.EXAMPLE
Create-FoldersForItems -path C:/media
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
    $files = get-childitem -Path $path -file;
    ForEach($file in $files) {
        $folder = New-Item -type Directory -Name ($file.Basename -replace "_.*")
        Move-Item -path $file.fullname -Destination $folder.FullName
        Write-Verbose -Message "Creating $folder"
        $count++
    }
}
end{
    Write-Verbose -Message "Created $count folders"
}
