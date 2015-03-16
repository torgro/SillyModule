Function Update-Person
{
[cmdletbinding()]
Param(
    [string]$Name
    ,
    [string]$DisplayName
    ,
    [Parameter(Mandatory)]
    [string]$ObjectID
    ,
    [pscredential]$Credential
    ,
    [string]$Uri
)
    $f = $MyInvocation.InvocationName
    Write-Verbose -Message "$f - START"

    [string]$ObjectType = "Person"
    [string]$Operation = "Update"
    
    Write-Verbose -Message "$f -  Checking if object exists"
    $ObjectExists = Get-Person @PSBoundParameters

    if(-not $ObjectExists)
    {
        throw "Object does not exist"
    }

    $KeyValue  = @{
        ObjectType  = $ObjectType
        ObjectID    = $ObjectExists.Node.ObjectID
        Operation   = $Operation
        ObjectName  = $null
        ObjectValue = $null
    }

    if($Name)
    {
        $KeyValue.ObjectName = "Name"
        $KeyValue.ObjectValue = "$Name"
    }

    if($DisplayName)
    {
        $KeyValue.ObjectName = "DisplayName"
        $KeyValue.ObjectValue = "$DisplayName"
    }

    $Import_Object = @{
        KeyValue   = $KeyValue
        Credential = $Credential
        Uri        = $Uri
    } #| Remove-HashtableNullValue

    Import-Object @Import_Object
}