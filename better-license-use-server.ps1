$csvLocation = "D:\testlicense.csv"
$inUseLics = @()
$inUse = $null
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
            D:\lmutil.exe lmstat -a -c $licfile | %{
                if($_ -match 'Users of (\w+): \D+ (\d+) \D+ (\d+) \D+$'){
                    if($first){
                        $content += " `{`""+$Matches[1]+"`":`""+$Matches[3]+"`"`}"
                        $first = $false
                    }
                    else{
                        $content += ", `{`""+$Matches[1]+"`":`""+$Matches[3]+"`"`}"
                    }
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