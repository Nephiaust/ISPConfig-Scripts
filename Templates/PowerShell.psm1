#Requires -PSEdition Core
#Requires -Version 6.0 
Function FunctionName {
    <#
    .SYNOPSIS
        
    .DESCRIPTION
        
    .PARAMETER Username
        None
    .EXAMPLE
        None
    .INPUTS
        None
    .OUTPUTS
        None
    .NOTES
        Author: 
    .LINK
        https://github.com/Nephiaust
    #>
    [CmdletBinding()]param (
        # Any parameters go in here
        #
        # EXAMPLE - [Parameter(Mandatory)][String]$Username
    )
    begin {
        # Do some stuff to pre-setup the environment for the function such as
        # create internal variables, load modules, etc.
        #
        # EXAMPLE - Create a blank variable called ANS; 
    }
    process {
        # Do the actual work in the function
        #
        # e.g. Add A & B together
    }
    end {
        # Do any cleanup, wrapping up  work here. Then return any results as
        # required.
    }
}
