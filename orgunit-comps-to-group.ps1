Function Get-OrgUnits{
    param($searchBase)
    return Get-ADOrganizationalUnit -Filter {Name -notlike 'Test*' -and Name -notlike 'Micro*' -and Name -notlike 'BLASTERS*' -and Name -notlike 'Workstations*'} -SearchScope OneLevel -SearchBase $searchBase | Select-Object -ExpandProperty DistinguishedName
}

$BuildingOUs = Get-OrgUnits("OU=Computers,OU=CAE,OU=orgUnits,DC=ad,DC=engr,DC=wisc,DC=edu")
foreach($building in $BuildingOUs){
    
}