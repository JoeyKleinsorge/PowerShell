<#
.SYNOPSIS
Gets Dell server BIOS settings
.DESCRIPTION
Uses REDFISH REST call to to get BIOS data. 
.EXAMPLE
Get-BIOSData -server serveridracname
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)] $server
  )

Begin{
    function Ignore-SSLCertificates{
    $Provider = New-Object Microsoft.CSharp.CSharpCodeProvider
    $Compiler = $Provider.CreateCompiler()
    $Params = New-Object System.CodeDom.Compiler.CompilerParameters
    $Params.GenerateExecutable = $false
    $Params.GenerateInMemory = $true
    $Params.IncludeDebugInformation = $false
    $Params.ReferencedAssemblies.Add("System.DLL") > $null
    $TASource=@'
        namespace Local.ToolkitExtensions.Net.CertificatePolicy
        {
            public class TrustAll : System.Net.ICertificatePolicy
            {
                public bool CheckValidationResult(System.Net.ServicePoint sp,System.Security.Cryptography.X509Certificates.X509Certificate cert, System.Net.WebRequest req, int problem)
                {
                    return true;
                }
            }
        }
'@ 
    $TAResults=$Provider.CompileAssemblyFromSource($Params,$TASource)
    $TAAssembly=$TAResults.CompiledAssembly
    $TrustAll = $TAAssembly.CreateInstance("Local.ToolkitExtensions.Net.CertificatePolicy.TrustAll")
    [System.Net.ServicePointManager]::CertificatePolicy = $TrustAll
}

    Ignore-SSLCertificates
    $Results = @()
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::TLS12
    $credential = get-credential
}

Process{
    write-host "BIOS Settings" -foregroundcolor "yellow"
    $biosURI = "https://$server/redfish/v1/Systems/System.Embedded.1/Bios"
    $bios = Invoke-WebRequest -Uri $biosURI -Credential $credential -Contenttype "application/JSON" -ErrorAction:Stop
    $biosdata=$bios.Content | ConvertFrom-Json
    $biosdata.Attributes
}

End{}
