$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"
Import-Module .\SillyModule.psd1

Describe "Get-Object" {
    Context "With Mandatory parameter spesified" {
        It "should not throw" {
            { Get-Object -ObjectType Person } | Should not throw
        }

    }
}


