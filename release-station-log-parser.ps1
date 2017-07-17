$log = Get-content D:\cae-kiosk-logs\release-station.log.full
$count = 0
$users = @{}
foreach($line in $log){
    if($line -match 'Successfully authenticated user: (\w+) '){
        #if(-not($users.Contains($Matches[1]))){
            write-host $Matches[1]
        #    $users.Add($Matches[1], 1)
            $count = $count + 1
        #}
    }
}
write-host $count