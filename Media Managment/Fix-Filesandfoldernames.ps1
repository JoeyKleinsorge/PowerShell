<#
.SYNOPSIS
   Renames files and folders
.DESCRIPTION
   Actions Performed
    - Double check dir
    - Delete empty folders
    - Create folders for items
    - Remove "." from folder names
    - Remove file extension from folder names
    - Add "()" to year in folder names
    - Remove "." from file names
    - Add "()" to year in file names
    - Delete files and folders with the name "sample"
.EXAMPLE
   Fix-Filesandfoldernames -dir C:\movies
.INPUTS
   Directory of file location
.OUTPUTS
   Renamed files and folders
.NOTES
   Author: Joey Kleinsorge
   Script provided "AS IS" without warranties or guarantees of any kind. USE AT YOUR OWN RISK. Public domain, no rights reserved.
#>

Param(
    [Parameter(Mandatory=$true)]
    $Directory
)

#Functions
function Add-Parentheses {
  [CmdletBinding()]
  param (
      [Parameter(Mandatory=$true)] $path
    )
  begin{
      $regex = '\((.*)\)'
      $pattern = '[0-9]{4,}'
      $parentFolder = Get-ChildItem -Path $path -Directory 
  }
  process{
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
}

function Remove-EmptyFolders{
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

}

function Remove-SmallSizedFolders{
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
}

function New-FoldersForItems{
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
}

function Remove-PeriodFromNames{
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
}

#_Check before running
$msgboxinput = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to change folder and file names in $directory" , "Double Check",'OKCancel',[System.Windows.Forms.MessageBoxIcon]::Warning)
switch ($msgboxinput){
    'OK' {
          #_Delete Empty folders
          Remove-EmptyFolders -path $Directory

          #_Removed SmallSizedFolders
          Remove-SmallSizedFolders -path $Directory

          #_Create folders for items
          New-FoldersForItems -path $Directory

          #_Remove "." from file and folder names
          $folders = Get-ChildItem -Directory -Path $Directory -Recurse
          Foreach ($folder in $folders){
            $Newname = $folder.BaseName.Replace("."," ")
            if ( $Newname -ne $folder.Name){
                Rename-Item -path $folder.fullname -NewName $newname -ErrorAction SilentlyContinue
            }
          }

          #_Remove file extension from file and folder names
          $folders = Get-ChildItem -Directory -Path $Directory -Recurse
          Foreach ($folder in $folders){
            $Newname = $folder.BaseName.Replace("mp4","")
            $Newname = $Newname.Replace("mkv","")
            $Newname = $Newname.Replace("avi","")
            if ( $Newname -ne $folder.Name){
                Rename-Item -path $folder.fullname -NewName $newname -ErrorAction SilentlyContinue
            }
          }

          #_Add "()" to year in folder names
          Add-Parentheses -Path


          #_Delete files and folders with the name "sample"
          $Allitems = get-childitem -path $Directory -Recurse
          Foreach ($item in $Allitems){
            if ($item.basename -contains "sample"){
                Remove-Item -Path $item.fullname
            }
          }
    }
    'Cancel'{exit}      
}
   