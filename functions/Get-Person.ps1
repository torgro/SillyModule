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