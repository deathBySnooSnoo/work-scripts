$listener = new-object System.Net.HttpListener
$listener.Prefixes.Add('http://joker.engr.wisc.edu:80/')
$listener.Start()
while($listener.IsListening){
    $context = $listener.GetContext()
    $request = $context.Request.Url
    $response = $context.Response

    $content = "hi"
    $buffer = [System.Text.Encoding]::UTF8.GetBytes($content)
    $response.ContentLength64 = $buffer.Length
    $response.OutputStream.Write($buffer, 0, $buffer.Length)
    $response.Close()

}