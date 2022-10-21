$domainObj = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()

$PDC = ($domainObj.PdcRoleOwner).Name

$SearchString = "LDAP://"

$SearchString += $PDC + "/"

$DistinguishedName = "DC=$($domainObj.Name.Replace('.', ',DC='))"

$SearchString += $DistinguishedName

$Searcher = New-Object System.DirectoryServices.DirectorySearcher([ADSI]$SearchString)

$objDomain = New-Object System.DirectoryServices.DirectoryEntry

$Searcher.SearchRoot = $objDomain

# choose one of these two

# all users
# if you want to list all users
#$Searcher.filter="samAccountType=805306368"

# one spesified user 
# if you only want to filter for the domain admin using name property
#$Searcher.filter="name=Jeff_Admin"


# iteration for above filters, make sure 
# loop is not commented out, bit
# filters below it are ...

<#
$Result = $Searcher.FindAll()
Foreach($obj in $Result)
{
    Foreach($prop in $obj.Properties)
    {
        $prop

    }
    
    Write-Host "------------------------"
}
#>


#-- comment out section above when using these below

# Domain Admins
<#
$Searcher.filter='samAccountName=Domain Admins'
$Result = $Searcher.FindAll()
Foreach($obj in $Result)
{
    "Domain Admin members: "
    $obj.Properties.member
    ""
}
#>


# List all domain computers
<#
$Searcher.filter='objectClass=Computer'
$Result = $Searcher.FindAll()
Foreach($obj in $Result)
{
    "Domain computer: "
    "Name: " + $obj.Properties.name
    "OS: " + $obj.Properties.operatingsystem
    "DNS: " + $obj.Properties.dnshostname
    "Critical: " + $obj.Properties.iscriticalsystemobject
    "Last logon: " + $obj.Properties.lastlogon
    ""
}
#>


# Windows 10
<#
$Searcher.filter='operatingsystem=Windows 10*'
$Result = $Searcher.FindAll()
Foreach($obj in $Result)
{
    "Name: " + $obj.Properties.name
    "OS: " + $obj.Properties.operatingsystem
    "DNS: " + $obj.Properties.dnshostname
    "Critical: " + $obj.Properties.iscriticalsystemobject
    "Last logon: " + $obj.Properties.lastlogon
    ""
}
#>