<#
.SYNOPSIS
Adds Parentheses to 4 digit strings that start with 19 or 20. 
.DESCRIPTION
Encapulates a year in a file or folder name in parentheses. Will loop through all sub-driectories.  
.EXAMPLE
add-parentheses -parentFolder D:/media
.NOTES
   Author: Joey Kleinsorge
   Script provided "AS IS" without warranties or guarantees of any kind. USE AT YOUR OWN RISK. Public domain, no rights reserved.
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)] $path
  )
begin{
    $regex = '\((.*)\)'
    $pattern = '[0-9]{4,}'
}
process{
    $parentFolder = Get-ChildItem -Path $path -Directory 
    Foreach ($folder in $parentFolder){
        $name = $folder.Name
        $test = [regex]::match($name, $regex).Groups[1] 
        if (!$test.success){
            $result = $name | Select-String $pattern -AllMatches
            if ($result){
                $results = $result.Matches.Value
                foreach ($_ in $results){
                    if (($_ -match "19") -or ($_ -match "20")){
                        $year = $_
                        $index1 = $name.IndexOf($year) 
                        $index2 = $index1 + 6
                        $name = $name.Insert($index1," (")
                        $name = $name.Insert($index2,") ") 
                        $oldName = $folder.FullName
                        Write-Verbose -Verbose "Renaming: $oldName to: $name"
                        Rename-Item -Path $oldName -NewName $name
                    }
                }
            }
        }
    
        $files = Get-ChildItem -path $name -File
        Foreach ($file in $files){
            $name = $file.Name
            $test = [regex]::match($name, $regex).Groups[1] 
            if (!$test.success){
                $result = $name | Select-String $pattern -AllMatches
                if ($result){
                        $results = $result.Matches.Value
                        foreach ($_ in $results){
                            if (($_ -match "19") -or ($_ -match "20")){
                                $year = $_
                                $index1 = $name.IndexOf($year) 
                                $index2 = $index1 + 6
                                $name = $name.Insert($index1," (")
                                $name = $name.Insert($index2,") ") 
                                Rename-Item -Path $file.FullName -NewName $name
                            }
                        }
                    }
            }
        }
    }
    catch{
        Write-error $Error[0]
    }
}


