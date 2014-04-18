#ONLY NEED TO CHANGE THE VARIABLE NAMES

#Change to version of Java that is being INSTALLED
$java_version = "1.7.0_55"
#Change to version of JRE that is being INSTALLED
$jre_installer = "jre1.7.0_55.msi"
#Change to version of JDK that is being INSTALLED
$jdk_installer = "jdk1.7.0_55.msi"
#Change to version of JRE that is being UNINSTALLED
$old_jre_uninstaller = "jre1.7.0_51.msi"

########ONLY NEED TO CHANGE THE VARIABLE NAMES

#Install Java
function install_java($java_installer){
    #Checks to see which version is being installed (ie JDK or JRE)
    if($java_installer -eq $jdk_installer){
        $argslist = "/qn /lv C:\windows\logs\jdkmsix86.log REBOOT=Suppress"
        $modify_registry = $false
    }
    else{
        $argslist = "/qn /lv C:\windows\logs\jremsix86.log /norestart ADDLOCAL=ALL IEXPLORER=1 MOZILLA=1 REBOOT=Suppress JAVAUPDATE=0"
        $modify_registry = $true
    }
    #Installs JDK or JRE
    start -wait -filepath $java_installer -ArgumentList $argslist
    #Modifies the following registry key for the JRE install only
    if($modify_registry){
        New-Item -Path "HKLM:\SOFTWARE\Wow6432Node\JavaSoft\Java Plug-in\$java_version"
        New-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\JavaSoft\Java Plug-in\$java_version" -Name "HideSystemTrayIcon" -PropertyType "DWORD" -Value 1 -Force
    }
}

#Attempts to clean up old Java installs
#Checks if Java 32-bit folder exists
if (test-path -Path "C:\Program Files (x86)\Java\jre7\bin"){
    #Runs the uninstaller for the jre
    (start -wait -FilePath msiexec.exe -ArgumentList "/x $old_jre_uninstaller /qn").ExitCode
    #The following code deletes registry keys if the uninstaller did not work correctly
    #DO NOT MODIFY THIS SECTION. WE DON'T WANT YOU TO ACCIDENTLY DELETE THE WRONG REG KEYS!
    if(test-path -Path "HKLM:\SOFTWARE\Wow6432Node\JavaSoft\Java Runtime Environment"){
        $jre_keys = get-childitem 'HKLM:\SOFTWARE\Wow6432Node\JavaSoft\Java Runtime Environment'
        #Deletes each instance of the JRE keys
        foreach($key in $jre_keys){
            if($key -match "\b1.7.0_\d{1,}\b"){
                $key_name = $key.Name -replace "\bHKEY_LOCAL_MACHINE", "HKLM:"
                Remove-Item $key_name -recurse
            }
        }
        $classes = Get-ChildItem HKLM:\SOFTWARE\Classes\Installer\Products
        #Deletes each instance of the JRE keys
        foreach($GUID in $classes){
            if((Get-ItemProperty $GUID.PsPath).ProductName -match "\bJava 7 Update \d{1,}$\b"){
                $GUID_name = $GUID.Name -replace "\bHKEY_LOCAL_MACHINE", "HKLM:"
                Remove-Item $GUID_name -Recurse
            }
        }
    #Not sure why this one is in here...
    (start -wait -FilePath msiexec.exe -ArgumentList "/x $old_jre_uninstaller /qn").ExitCode
    }
}
#Installs JRE and JDK
install_java($jre_installer)
install_java($jdk_installer)