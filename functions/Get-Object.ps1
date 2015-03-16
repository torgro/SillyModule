Function Get-Object
{
[cmdletbinding()]
Param(
    [Parameter(Mandatory)]
    [ValidateSet("Person","Group")]
    [string]$ObjectType
    ,
    [string]$ObjectName
    ,
    [string]$ObjectValue
    ,
    [pscredential]$Credential
    ,
    [string]$Uri = "http://localhost:34544/Sillysystem"
)
    $F = $MyInvocation.InvocationName
    Write-Verbose -Message "$f - START"

    [string]$xPath = "//$ObjectType"

    If($ObjectName -and $ObjectValue)
    {
        $xPath += "[@$ObjectName='$ObjectValue']"
    }

    $Export_Object = @{
        xPath      = $xPath
        Credential = $Credential
        Uri        = $Uri
    }

    Write-Verbose -Message "$f -  Remove null values from hashtable"
    $Export_Object = $Export_Object | Remove-HashtableNullValue

    Export-Object @Export_Object
    
}