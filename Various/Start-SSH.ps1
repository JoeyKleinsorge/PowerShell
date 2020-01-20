<#
.SYNOPSIS
Open a SSH session to a device within PowerShell
.DESCRIPTION
Uses Posh-SSH to start an SSH session with $Server
.EXAMPLE
Start-SSH -Server serveridracname
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$True)]
    [string]$Server,
    [System.Management.Automation.PSCredential]
    [System.Management.Automation.Credential()]
    $Credentials
)

Begin{
    Import-Module Posh-SSH
}

Process{
    Write-Host " "
    Write-host "Starting SSH connection to $Server" -ForegroundColor Cyan

    $SSH = New-SSHSession -ComputerName $Server -Credential $Credentials -AcceptKey -ErrorVariable $er

    if (!$er) {
        while ($True) {
            $command = Read-Host -Prompt "Enter command"
            Write-Host = " "
            $(Invoke-SSHCommand -SSHSession $SSH -Command $command).output
            Write-Host = " "
        }
    }
}

End{
    #_Remove any open SSH Sessions
    $Sessions = Get-SSHSession
    Foreach($_ in $Sessions){
        $quite = Remove-SSHSession -SessionId $_.SessionID
    } 
}
