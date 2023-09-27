<#
.SYNOPSIS
    Creates a new PowerShell script module in the specified location.

.DESCRIPTION
    New-MrScriptModule is an advanced function that creates a new PowerShell script module in the
    specified location including creating the module folder and both the PSM1 script module file
    and PSD1 module manifest.

.PARAMETER Name
    Name of the script module.

.EXAMPLE
    New-MrScriptModule -Name MyModuleName

.INPUTS
    None

.OUTPUTS
    None

.NOTES
    Author:  
    Website: 
    Twitter: 
#>

[CmdletBinding()]param (
    [Parameter()][string]$Name
)
