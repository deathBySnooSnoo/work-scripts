$java_version = "1.7.0_55"
$jre_installer = "jre1.7.0_55.msi"
$jdk_installer = "jdk1.7.0_55.msi"
$old_jre_uninstaller = "jre1.7.0_51.msi"

function install_java($java_installer){
    if($java_installer -eq $jdk_installer){
        $argslist = "/qn INSTALLDIR=`"C:\Program Files\Java\jdk`" /lv C:\windows\logs\jdkmsix64.log REBOOT=Suppress"
        $modify_registry = $false
    }
    else{
        $argslist = "/qn /lv C:\windows\logs\jremsix64.log /norestart ADDLOCAL=ALL IEXPLORER=1 MOZILLA=1 REBOOT=Suppress JAVAUPDATE=0"
        $modify_registry = $true
    }
    start -wait -filepath $java_installer -ArgumentList $argslist
    if($modify_registry){
        New-Item -Path "HKLM:\SOFTWARE\JavaSoft\Java Plug-in\$java_version"
        New-ItemProperty -Path "HKLM:\SOFTWARE\JavaSoft\Java Plug-in\$java_version" -Name "HideSystemTrayIcon" -PropertyType "DWORD" -Value 1 -Force
    }
}

if (test-path -Path "C:\Program Files\Java\jre7\bin"){
    (start -wait -FilePath msiexec.exe -ArgumentList "/x $old_jre_uninstaller /qn").ExitCode
    if(test-path -Path "HKLM:\SOFTWARE\JavaSoft\Java Runtime Environment"){
        $jre_keys = get-childitem 'HKLM:\SOFTWARE\JavaSoft\Java Runtime Environment'
        foreach($key in $jre_keys){
            if($key -match "\b1.7.0_\d{1,}\b"){
                $key_name = $key.Name -replace "\bHKEY_LOCAL_MACHINE", "HKLM:"
                Remove-Item $key_name -recurse
            }
        }
        $classes = Get-ChildItem HKLM:\SOFTWARE\Classes\Installer\Products
        foreach($GUID in $classes){
            if((Get-ItemProperty $GUID.PsPath).ProductName -match "\bJava 7 Update \d{1,} (64-bit)$\b"){
                $GUID_name = $GUID.Name -replace "\bHKEY_LOCAL_MACHINE", "HKLM:"
                Remove-Item $GUID_name -Recurse
            }
        }
        (start -wait -FilePath msiexec.exe -ArgumentList "/x $old_jre_uninstaller /qn").ExitCode
    }
}
install_java($jre_installer)
install_java($jdk_installer)