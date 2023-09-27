#Requires -PSEdition Core
#Requires -Version 6.0 

<#
    .NAME
        Internal ISPConfig PowerShell functions
    .SYNOPSIS
        Creates a connection to ISPConfig.
    .DESCRIPTION
        Creates a connection to the ISPConfig API interface specified. Allows specifying
        the server name & port, API username & password, and if SSL/TLS is to be used.
#>

Function Connect-ISPConfig {
    <#
    .SYNOPSIS
        Creates a connection to ISPConfig.

    .DESCRIPTION
        Creates a connection to the ISPConfig API interface specified. Allows specifying
        the server name & port, API username & password, and if SSL/TLS is to be used.

    .PARAMETER Credential
        Specify the API credentials to use when connecting to the ISPConfig API interface

    .PARAMETER Server
        Specify the server address (E.G. webserver.domain.com) to access the ISPConfig API interface

    .PARAMETER Port
        Specify the port being used by ISPConfig for the API interface. The default is 8080

    .PARAMETER Secure
        Use HTTPS (SSL/TLS) when connecting to the ISPConfig API interface

    .PARAMETER IgnoreSSL
        Ignore any SSL/TLS errors (E.G. untrusted certificates) that may arise when connecting to the
        ISPConfig API interface

    .EXAMPLE
        PS> Connect-ISPConfig -Credential $MyCredentials -Server webserver.example.com -Port 8080 -Secure
        Uses the stored credentials (in $MyCredentials) to connect to the webserver.example.com ISPConfig instance, using HTTPS

    .EXAMPLE
        PS> Connect-ISPConfig -Credential $MyCredentials -Server webserver.example.com -Port 8080
        Uses the stored credentials (in $MyCredentials) to connect to the webserver.example.com ISPConfig instance, using HTTP

    .INPUTS 
        None. You can't pipe objects this function.

    .OUTPUTS
        System.String. Session ID for a successful login. Returns FALSE if it failed.

    .NOTES
        Author: Nephi.AU

    .LINK
        https://github.com/Nephiaust
    #>
    [CmdletBinding(DefaultParameterSetName = "Secure")]
    [OutputType("System.String")]
    param (
        [Parameter(Mandatory,
            ParameterSetName = "Insecure",
            ValueFromPipelineByPropertyName,
            HelpMessage = "Specifies the API credentials to use when authenticating with ISPConfig")]
        [Parameter(Mandatory,
            ParameterSetName = "Secure",
            ValueFromPipelineByPropertyName,
            HelpMessage = "Specifies the API credentials to use when authenticating with ISPConfig")]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,
        
        [Parameter(Mandatory,
            ParameterSetName = "Insecure",
            ValueFromPipelineByPropertyName,
            HelpMessage = "Specifies the server name where the ISPConfig API is installed")]
        [Parameter(Mandatory,
            ParameterSetName = "Secure",
            ValueFromPipelineByPropertyName,
            HelpMessage = "Specifies the server name where the ISPConfig API is installed")]
        [String]$Server,
        
        [Parameter(Mandatory,
            ParameterSetName = "Insecure",
            ValueFromPipelineByPropertyName,
            HelpMessage = "Specifies the port to connect to the ISPConfig API on the server")]
        [Parameter(Mandatory,
            ParameterSetName = "Secure",
            ValueFromPipelineByPropertyName,
            HelpMessage = "Specifies the port to connect to the ISPConfig API on the server")]
        [PSDefaultValue(Help = '8080', Value = 8080)]
        [ValidateScript({ $_ -ge 1 -and $_ -le 65535 },
            ErrorMessage = 'Port number needs to be between 1 and 65535')]
        [Int32]$Port,

        [Parameter(Mandatory,
            ParameterSetName = "Secure",
            ValueFromPipelineByPropertyName,
            HelpMessage = "Is the connection requiring HTTPS to access the ISPConfig API")]
        [Switch]$Secure,

        [Parameter(ParameterSetName = "Secure",
            ValueFromPipelineByPropertyName,
            HelpMessage = "Should any SSL/TLS errors be ignored (e.g. untrusted certificates)")]
        [Switch]$IgnoreSSL
    )
    begin {
        $Request = @{
            ContentType     = "application/json"
            Headers         = @{
                "Cache-Control" = "no-cache"
            }
            Method          = "POST"
            UseBasicParsing = $true
        }

        $LoginCredentials = @{
            username = $Credential.UserName
            password = $Credential.GetNetworkCredential().Password
        } | ConvertTo-Json -EnumsAsStrings
        

        If ($Secure) {
            $RequestURI = "https://" + $Server + ":" + $Port + "/remote/json.php"
            $RequestURL = "https://" + $Server + ":" + $Port + "/remote/"
        }
        else {
            $RequestURI = "http://" + $Server + ":" + $Port + "/remote/json.php"
            $RequestURL = "http://" + $Server + ":" + $Port + "/remote/"
        }

    }
    process {
        $Request['URI'] = $RequestURI + "?login"
        $Request['Body'] = $LoginCredentials
        $SessionRaw = try {
            Invoke-WebRequest @Request
        }
        catch {
            Write-Error $_.Exception
        }
        $Session = $SessionRaw | ConvertFrom-Json
        if ($Session.Code -eq 'ok') {
            return $Session.response
        } else {
            write-error $session.message
        }
    }
    end {
        Remove-Variable -Name ("RequestURI","RequestURL","SessionRaw","Session")
    }
}

Function Disconnect-ISPConfig {
    <#
    .SYNOPSIS
        Disconnects from an existing connection to ISPConfig.

    .DESCRIPTION
        Disconnects from an existing connection to the ISPConfig API interface specified.
        Allows specifying the server name & port, API username & password, and if SSL/TLS
        is to be used.

    .PARAMETER SessionID
        Specify the API session ID to disconnect/logoff from the ISPConfig API interface

        .PARAMETER Server
        Specify the server address (E.G. webserver.domain.com) to access the ISPConfig API interface

    .PARAMETER Port
        Specify the port being used by ISPConfig for the API interface. The default is 8080

    .PARAMETER Secure
        Use HTTPS (SSL/TLS) when connecting to the ISPConfig API interface

    .PARAMETER IgnoreSSL
        Ignore any SSL/TLS errors (E.G. untrusted certificates) that may arise when connecting to the
        ISPConfig API interface
    .EXAMPLE
        PS> Connect-ISPConfig -Credential $MyCredentials -Server webserver.example.com -Port 8080 -Secure
        Uses the stored credentials (in $MyCredentials) to connect to the webserver.example.com ISPConfig instance, using HTTPS

    .EXAMPLE
        PS> Connect-ISPConfig -Credential $MyCredentials -Server webserver.example.com -Port 8080
        Uses the stored credentials (in $MyCredentials) to connect to the webserver.example.com ISPConfig instance, using HTTP

    .INPUTS 
        None. You can't pipe objects this function.

    .OUTPUTS
        System.Boolean. Returns TRUE if the session was terminated successfully. Returns FALSE if it failed for any reason.

    .NOTES
        Author: Nephi.AU

    .LINK
        https://github.com/Nephiaust
    #>
    [CmdletBinding(DefaultParameterSetName = "Secure")]
    [OutputType("System.Bool")]
    param (
        [Parameter(Mandatory,
            ParameterSetName = "Insecure",
            ValueFromPipelineByPropertyName,
            HelpMessage = "Specifies the API session ID to use when disconnecting from ISPConfig")]
        [Parameter(Mandatory,
            ParameterSetName = "Secure",
            ValueFromPipelineByPropertyName,
            HelpMessage = "Specifies the API session ID to use when disconnecting from ISPConfig")]
        $SessionID,
        
        [Parameter(Mandatory,
            ParameterSetName = "Insecure",
            ValueFromPipelineByPropertyName,
            HelpMessage = "Specifies the server name where the ISPConfig API is installed")]
        [Parameter(Mandatory,
            ParameterSetName = "Secure",
            ValueFromPipelineByPropertyName,
            HelpMessage = "Specifies the server name where the ISPConfig API is installed")]
        [String]$Server,
        
        [Parameter(Mandatory,
            ParameterSetName = "Insecure",
            ValueFromPipelineByPropertyName,
            HelpMessage = "Specifies the port to connect to the ISPConfig API on the server")]
        [Parameter(Mandatory,
            ParameterSetName = "Secure",
            ValueFromPipelineByPropertyName,
            HelpMessage = "Specifies the port to connect to the ISPConfig API on the server")]
        [PSDefaultValue(Help = '8080', Value = 8080)]
        [ValidateScript({ $_ -ge 1 -and $_ -le 65535 },
            ErrorMessage = 'Port number needs to be between 1 and 65535')]
        [Int32]$Port,

        [Parameter(Mandatory,
            ParameterSetName = "Secure",
            ValueFromPipelineByPropertyName,
            HelpMessage = "Is the connection requiring HTTPS to access the ISPConfig API")]
        [Switch]$Secure,

        [Parameter(ParameterSetName = "Secure",
            ValueFromPipelineByPropertyName,
            HelpMessage = "Should any SSL/TLS errors be ignored (e.g. untrusted certificates)")]
        [Switch]$IgnoreSSL
    )
    begin {
        $Request = @{
            ContentType     = "application/json"
            Headers         = @{
                "Cache-Control" = "no-cache"
            }
            Method          = "POST"
            UseBasicParsing = $true
            Body = @{session_id = $SessionID} | ConvertTo-Json
        }

        If ($Secure) {
            $RequestURI = "https://" + $Server + ":" + $Port + "/remote/json.php"
            $RequestURL = "https://" + $Server + ":" + $Port + "/remote/"
        }
        else {
            $RequestURI = "http://" + $Server + ":" + $Port + "/remote/json.php"
            $RequestURL = "http://" + $Server + ":" + $Port + "/remote/"
        }

    }
    process {
        $Request['URI'] = $RequestURI + "?logout"
        $SessionRaw = try {
            Invoke-WebRequest @Request
        }
        catch {
            Write-Error $_.Exception
        }
        $Session = $SessionRaw | ConvertFrom-Json
        if ($Session.Code -eq 'ok') {
            return $true
        } else {
            return $false
            write-error $session.message
        }
    }
    end {
        Remove-Variable -Name ("RequestURI","RequestURL","SessionRaw","Session")
    }
}