Configuration XenDesktop{
    param($node)
    Import-DscResource -ModuleName PsDesiredStateConfiguration
    Node $node{
        WindowsFeature WebServer{
            Ensure = "Present"
            Name = "Web-Server"
        }
        WindowsFeature WebCommonHttp{
            Ensure = "Present"
            Name = "Web-Common-Http"
            DependsOn = "[WindowsFeature]WebServer"
        }
        WindowsFeature WebDefaultDoc{
            Ensure = "Present"
            Name = "Web-Default-Doc"
            DependsOn = "[WindowsFeature]WebServer"
        }
        WindowsFeature WebDirBrowsing{
            Ensure = "Present"
            Name = "Web-Dir-Browsing"
            DependsOn = "[WindowsFeature]WebServer"
        }
        WindowsFeature WebHttpErrors{
            Ensure = "Present"
            Name = "Web-Http-Errors"
            DependsOn = "[WindowsFeature]WebServer"
        }
        WindowsFeature WebStaticContent{
            Ensure = "Present"
            Name = "Web-Static-Content"
            DependsOn = "[WindowsFeature]WebServer"
        }
        WindowsFeature WebHttpRedirect{
            Ensure = "Present"
            Name = "Web-Http-Redirect"
            DependsOn = "[WindowsFeature]WebServer"
        }
        WindowsFeature WebHealth{
            Ensure = "Present"
            Name = "Web-Health"
            DependsOn = "[WindowsFeature]WebServer"
        }
        WindowsFeature WebHttpLogging{
            Ensure = "Present"
            Name = "Web-Http-Logging"
            DependsOn = "[WindowsFeature]WebServer"
        }
        WindowsFeature WebLogLibraries{
            Ensure = "Present"
            Name = "Web-Log-Libraries"
            DependsOn = "[WindowsFeature]WebServer"
        }
        WindowsFeature WebHttpTracing{
            Ensure = "Present"
            Name = "Web-Http-Tracing"
            DependsOn = "[WindowsFeature]WebServer"
        }
        WindowsFeature WebPerformance{
            Ensure = "Present"
            Name = "Web-Performance"
            DependsOn = "[WindowsFeature]WebServer"
        }
        WindowsFeature WebStatCompression{
            Ensure = "Present"
            Name = "Web-Stat-Compression"
            DependsOn = "[WindowsFeature]WebServer"
        }
        WindowsFeature WebDynCompression{
            Ensure = "Present"
            Name = "Web-Dyn-Compression"
            DependsOn = "[WindowsFeature]WebServer"
        }
        WindowsFeature WebSecurity{
            Ensure = "Present"
            Name = "Web-Security"
            DependsOn = "[WindowsFeature]WebServer"
        }
        WindowsFeature WebFiltering{
            Ensure = "Present"
            Name = "Web-Filtering"
            DependsOn = "[WindowsFeature]WebServer"
        }
        WindowsFeature WebBasicAuth{
            Ensure = "Present"
            Name = "Web-Basic-Auth"
            DependsOn = "[WindowsFeature]WebServer"
        }
        WindowsFeature WebWindowsAuth{
            Ensure = "Present"
            Name = "Web-Windows-Auth"
            DependsOn = "[WindowsFeature]WebServer"
        }
        WindowsFeature WebAppDev{
            Ensure = "Present"
            Name = "Web-App-Dev"
            DependsOn = "[WindowsFeature]WebServer"
        }
        WindowsFeature WebNetExt45{
            Ensure = "Present"
            Name = "Web-Net-Ext45"
            DependsOn = "[WindowsFeature]WebServer"
        }
        WindowsFeature WebASP{
            Ensure = "Present"
            Name = "Web-ASP"
            DependsOn = "[WindowsFeature]WebServer"
        }
        WindowsFeature WebAspNet45{
            Ensure = "Present"
            Name = "Web-Asp-Net45"
            DependsOn = "[WindowsFeature]WebServer"
        }
        WindowsFeature WebCGI{
            Ensure = "Present"
            Name = "Web-CGI"
            DependsOn = "[WindowsFeature]WebServer"
        }
        WindowsFeature WebISAPIExt{
            Ensure = "Present"
            Name = "Web-ISAPI-Ext"
            DependsOn = "[WindowsFeature]WebServer"
        }
        WindowsFeature WebISAPIFilter{
            Ensure = "Present"
            Name = "Web-ISAPI-Filter"
            DependsOn = "[WindowsFeature]WebServer"
        }
        WindowsFeature WebIncludes{
            Ensure = "Present"
            Name = "Web-Includes"
            DependsOn = "[WindowsFeature]WebServer"
        }
        WindowsFeature WebMgmtTools{
            Ensure = "Present"
            Name = "Web-Mgmt-Tools"
            DependsOn = "[WindowsFeature]WebServer"
        }
        WindowsFeature WebMgmtConsole{
            Ensure = "Present"
            Name = "Web-Mgmt-Console"
            DependsOn = "[WindowsFeature]WebServer"
        }
        WindowsFeature WebMgmtCompat{
            Ensure = "Present"
            Name = "Web-Mgmt-Compat"
            DependsOn = "[WindowsFeature]WebServer"
        }
        WindowsFeature WebMetabase{
            Ensure = "Present"
            Name = "Web-Metabase"
            DependsOn = "[WindowsFeature]WebServer"
        }
        WindowsFeature WebLgcyScripting{
            Ensure = "Present"
            Name = "Web-Lgcy-Scripting"
            DependsOn = "[WindowsFeature]WebServer"
        }
        WindowsFeature WebWMI{
            Ensure = "Present"
            Name = "Web-WMI"
            DependsOn = "[WindowsFeature]WebServer"
        }
        WindowsFeature WebScriptingTools{
            Ensure = "Present"
            Name = "Web-Scripting-Tools"
            DependsOn = "[WindowsFeature]WebServer"
        }
        Script HTTPS{
            SetScript = {New-WebBinding -Name "Default Web Site" -Protocol "https" -Port 443 -IPAddress "*"}
            TestScript = {
                if((Get-WebBinding -Name "Default Web Site" -Port 443) -ne $null){
                    return $true
                }
                else{
                    return $false
                }
            }
            GetScript = {
                return @{Result = (Get-WebBinding -Name "Default Web Site" -Port 443)}
            }
            DependsOn = "[WindowsFeature]WebServer"
        }
        #File TempDir{
        #    DestinationPath = C:\temp
        #    Ensure = Present
        #}
        Script XenDesktopDC{
            SetScript = {
                & "\\engr-srv.ad.engr.wisc.edu\iso\Citrix\XenDesktop7\7.14\x64\XenDesktop Setup\XenDesktopServerSetup.exe" /logpath "C:\temp\xendesktop.log" /noreboot /configure_firewall /components CONTROLLER,DESKTOPSTUDIO /nosql /disableexperiencemetrics /quiet
            }
            TestScript = {
                $result = Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName | Where-Object {$_.DisplayName -like "*Citrix XenDesktop 7.14.1*"}
                if($result -eq "Citrix XenDesktop 7.14.1"){
                    return $true
                }
                else{
                    return $false
                }
            }
            GetScript = {return @{Result = (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName | Where-Object {$_.DisplayName -like "*Citrix XenDesktop 7.14.1*"}).DisplayName}}
            #DependsOn = "[File]TempDir"
        }
    }
}
XenDesktop