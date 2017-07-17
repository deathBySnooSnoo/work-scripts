$computers = Get-ADComputer -Filter {Name -like 'WIN-1*'} -SearchBase "ou=Computers,ou=CAE,ou=OrgUnits,dc=ad,dc=engr,dc=wisc,dc=edu"
foreach($computer in $computers){
    write-host $computer.Name
    Invoke-Command -ComputerName $computer.Name -ScriptBlock {
        get-hotfix -id kb4015217
        get-hotfix -id kb4016635
    }
}