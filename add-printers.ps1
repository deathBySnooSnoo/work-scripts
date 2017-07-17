$printers = @(`
    [System.Tuple]::Create("cae-116-color", "cae-116-color", "CAE 116"),`
    [System.Tuple]::Create("cae-116-laser1", "cae-116-duplex1", "CAE 116"),`
    [System.Tuple]::Create("cae-116-laser2", "cae-116-duplex2", "CAE 116"),`
    [System.Tuple]::Create("ecb-m1053-laser", "ecb-m1053-duplex", "ECB M1053"),`
    [System.Tuple]::Create("engr-2261-laser", "engr-2261-duplex", "ENGR 2261"),`
    [System.Tuple]::Create("engr-2324-laser", "engr-2324-duplex", "ENGR 2324"),`
    [System.Tuple]::Create("engr-3654-laser", "engr-3654-duplex", "ENGR 3654"),`
    [System.Tuple]::Create("engr-b103c-laser", "engr-b103c-laser", "ENGR B103C"),`
    [System.Tuple]::Create("engr-b555-laser", "engr-b555-laser", "ENGR B555"),`
    [System.Tuple]::Create("kfw-105-laser", "kfw-105-duplex", "KFW 105"),`
    [System.Tuple]::Create("me-1262-laser1", "me-1262-duplex1", "ME 1262"),`
    [System.Tuple]::Create("me-1262-laser2", "me-1262-duplex2", "ME 1262"),`
    [System.Tuple]::Create("me-2109-laser", "me-2109-duplex", "ME 2109")`
)

foreach($p in $printers){
    Add-PrinterPort -Name $p.Item1 -PrinterHostAddress $p.Item1
    Add-Printer -PortName $p.Item1 -DriverName "Lexmark Universal v2 XL" -Shared -ShareName $p.Item2 -Name $p.Item2 -Location $p.Item3
}