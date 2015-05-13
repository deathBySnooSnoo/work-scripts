$csvLocation = "D:\testlicense.csv"
$inUseLics = @{}
$inUse = $null
$data = $null
$feature = $null
$csv = Get-Content $csvLocation
foreach($line in $csv){
    $line = $line.Split(',')
    $type = $line[0]
    $licfile = $line[1]
    if($type -eq "flexlm"){
        $data = & D:\lmutil.exe lmstat -a -c $licfile | Where-Object { $_ -match '^Users' }
        foreach($d in $data){
            $d = $d.TrimStart("Users of ")
            $feature = $d.Substring(0,$d.IndexOf(":"))
            $inUse = $d.Substring($d.IndexOf(";")).split(" ") | Where-Object {$_ -match '[0123456789]'}
            $inUseLics.Add($feature, $inUse)
        }
    }
}
$inUseLics.GetEnumerator() | foreach { write-host $_.Key $_.Value }