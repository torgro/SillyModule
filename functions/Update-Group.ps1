Function Update-Group
{
[cmdletbinding()]
Param(
    [string]$Name
    ,
    [string]$Description
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

    [string]$ObjectType = "Group"
    [string]$Operation = "Update"
    
    Write-Verbose -Message "$f -  Checking if object exists"
    $ObjectExists = Get-Group @PSBoundParameters

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
        $KeyValue.ObjectName  = "Name"
        $KeyValue.ObjectValue = "$Name"
    }

    if($Description)
    {
        $KeyValue.ObjectName  = "Description"
        $KeyValue.ObjectValue = "$Description"
    }

    $Import_Object = @{
        KeyValue   = $KeyValue
        Credential = $Credential
        Uri        = $Uri
    }

    Import-Object @Import_Object
}