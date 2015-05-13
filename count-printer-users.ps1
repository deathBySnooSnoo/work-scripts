$dataset = get-content "C:\Users\dbittner\Desktop\print_summary_by_printer_by_user-2.csv"
$currentprinter = "none"
$usercount = 0
foreach ($line in $dataset){
    $data = $line.Split(',')
    $printer = $data[0]
    if($printer -eq $currentprinter){
        $usercount = $usercount + 1
    }
    else{
        write-host $currentprinter $usercount
        $currentprinter = $printer
        $usercount = 1
    }
}
write-host $currentprinter $usercount