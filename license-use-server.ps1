$csvLocation = "C:\temp\testlicense.csv"
$inUseLics = @{}
$inUse = $null
$data = $null
$feature = $null
$csv = Get-Content $csvLocation


$listener = new-object System.Net.HttpListener
$listener.Prefixes.Add('http://localhost:80/')
$listener.Start()
while($listener.IsListening){
    $context = $listener.GetContext()
    $request = $context.Request.Url
    $response = $context.Response
    $date = Get-Date

    $content = "`{ `"$date`":["
    foreach($line in $csv){
        $line = $line.Split(',')
        $type = $line[0]
        $licfile = $line[1]
        if($type -eq "flexlm"){
            $first = $true
            $data = & C:\temp\lmutil.exe lmstat -a -c $licfile | Where-Object { $_ -match '^Users' }
            foreach($d in $data){
                $d = $d.TrimStart("Users of ")
                $feature = $d.Substring(0,$d.IndexOf(":"))
                $inUse = $d.Substring($d.IndexOf(";")).split(" ") | Where-Object {$_ -match '[0123456789]'}
                if($first){ 
                    $content += " `{`"$feature`":`"$inUse`"`}"
                    $first = $false
                }
                else{
                    $content += ", `{`"$feature`":`"$inUse`"`}"
                }
            }
        }
    }
    $content += "]`}"

    $buffer = [System.Text.Encoding]::UTF8.GetBytes($content)
    $response.ContentLength64 = $buffer.Length
    $response.OutputStream.Write($buffer, 0, $buffer.Length)
    $response.Close()
}