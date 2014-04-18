Add-PSSnapin Citrix.Broker.Admin.V2 
$unregistered_machines = Get-BrokerDesktop -Filter { RegistrationState -eq 'Unregistered' }
$disconnected_sessions = Get-BrokerSession -Filter { SessionState -eq 'Disconnected' -and SessionStateChangeTime -lt '-0:15' }
$long_sessions = Get-BrokerSession -Filter { SessionState -eq 'Active' -and SessionStateChangeTime -lt '-12:00' }
$sessions = $disconnected_sessions + $long_sessions
foreach ($s in $sessions){
    $registered_machine = $true
    foreach ($machine in $unregistered_machines){
        if($machine.MachineName.compareTo($s.MachineName) -eq 0){
            $registered_machine = $false
        }
    }
    if($registered_machine -eq $true){
        Stop-BrokerSession -inputobject $s
    }
}