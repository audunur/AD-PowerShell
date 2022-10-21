$domainObj = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()

$PDC = ($domainObj.PdcRoleOwner).Name

$SearchString = "LDAP://"

$SearchString += $PDC + "/"

$DistinguishedName = "DC=$($domainObj.Name.Replace('.', ',DC='))"

$SearchString += $DistinguishedName

$Searcher = New-Object System.DirectoryServices.DirectorySearcher([ADSI]$SearchString)

$objDomain = New-Object System.DirectoryServices.DirectoryEntry

$Searcher.SearchRoot = $objDomain

# quick win search: serviceprincipalname=*server*"
# search for IIS server: serviceprincipalname=*http*"
# search for SQL server: serviceprincipalname=*sql*"
# search for exchange server: serviceprincipalname=*exchange*"
# search for machines: serviceprincipalname=*host*"
$Searcher.filter="serviceprincipalname=*server*"

$Result = $Searcher.FindAll()

Foreach($obj in $Result)
{
    Foreach($prop in $obj.Properties)
    {
    ""
    $prop.name
    "SamAccountName: " + $prop.samaccountname
    "ServicePrincipalName: " + $prop.serviceprincipalname
    $option = [System.StringSplitOptions]::RemoveEmptyEntries
    $address1 = ($prop.serviceprincipalname -split "/")[-1]
    $address2 = ($address1 -split ":")[0]
    Write-Host "ADDRESS = $address2"
    $ip = nslookup $address2
    Write-Host "$ip"
    ""
    }
}