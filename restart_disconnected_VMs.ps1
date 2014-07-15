Add-PSSnapin Citrix.Broker.Admin.V2
$unregistered_machines = Get-BrokerDesktop -Filter { (RegistrationState -eq 'Unregistered') -and (PowerState -eq 'On') }
foreach($machine in $unregistered_machines){
    New-BrokerHostingPowerAction -MachineName $machine.MachineName -Action Reset
}