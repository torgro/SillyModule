Function Get-Group
{
[cmdletbinding()]
Param(
    
    [string]$Name
    ,
    [string]$Description
    ,
    [string]$ObjectID
    ,
    [pscredential]$Credential
    ,
    [string]$Uri
)
    $f = $MyInvocation.InvocationName
    Write-Verbose -Message "$f - START"

    [string]$ObjectType = "Group"

    $Get_Object = @{
        ObjectType  = $ObjectType
        Credential  = $Credential
        Uri         = $Uri
        ObjectName  = $null
        ObjectValue = $null
    }

    if($Name)
    {
        $Get_Object.ObjectName  = "Name"
        $Get_Object.ObjectValue = "$Name"
    }

    if($Description)
    {
        $Get_Object.ObjectName  = "Description"
        $Get_Object.ObjectValue = "$Description"
    }

    if($ObjectID)
    {
        $Get_Object.ObjectName  = "ObjectID"
        $Get_Object.ObjectValue = "$ObjectID"
    }
    
    Write-Verbose -Message "$f -  Removing null values from hashtable"
    $Get_Object = $Get_Object | Remove-HashtableNullValue

    Write-Verbose -Message "$f -  Getting objects"
    Get-Object @Get_Object

    Write-Verbose -Message "$f - END"
}

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

 Function Get-Person
{
[cmdletbinding()]
Param(
    
    [string]$Name
    ,
    [string]$DisplayName
    ,
    [string]$ObjectID
    ,
    [pscredential]$Credential
    ,
    [string]$Uri
)
    $f = $MyInvocation.InvocationName
    Write-Verbose -Message "$f - START"

    [string]$ObjectType = "Person"

    $Get_Object = @{
        ObjectType  = $ObjectType
        Credential  = $Credential
        Uri         = $Uri
        ObjectName  = $null
        ObjectValue = $null
    }

    if($Name)
    {
        $Get_Object.ObjectName  = "Name"
        $Get_Object.ObjectValue = "$Name"
    }

    if($DisplayName)
    {
        $Get_Object.ObjectName  = "DisplayName"
        $Get_Object.ObjectValue = "$DisplayName"
    }

    if($ObjectID)
    {
        $Get_Object.ObjectName  = "ObjectID"
        $Get_Object.ObjectValue = "$ObjectID"
    }
    
    Write-Verbose -Message "$f -  Removing null values from hashtable"
    $Get_Object = $Get_Object | Remove-HashtableNullValue

    Write-Verbose -Message "$f -  Getting objects"
    Get-Object @Get_Object

    Write-Verbose -Message "$f - END"
}

 Function Remove-HashtableNullValue
{
[cmdletbinding()]
Param(
    [Parameter(ValueFromPipeline)]
    [Alias("InputObject")]
    [hashtable]$Hash
)
    BEGIN
    {
        $F = $MyInvocation.InvocationName
        Write-Verbose -Message "$f - START"
        [int]$CountNonNull = 0
    }

    PROCESS
    {    
        foreach($key in $Hash.Keys)
        {
            if($Hash.$key -ne $null)
            {
                $CountNonNull ++
            }
        }
        if($CountNonNull -gt 0)
        {
            foreach($KeyValue in $Hash.Clone().GetEnumerator())
            {
                if($KeyValue.Value -eq $null)
                {
                    Write-Verbose -Message "$f -  Key '$($KeyValue.key)' is null, removing it"
                    $Hash.Remove($KeyValue.Key)
                }
            }
            return $hash
        }
        else
        {
            Write-Verbose -Message "$f -  All keys were null"
            return @{}
        }
    }

    END
    {
        Write-Verbose -Message "$f - END"
    }
}

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


