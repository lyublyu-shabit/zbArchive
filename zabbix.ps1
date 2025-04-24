$path = "C:\Program Files\zabbix"
$zabbixName="zabbix.msi"
# Download links
$hardwareLink="https://raw.github.com/lyublyu-shabit/zbArchive/main/OpenHardwareMonitorLib.dll"
$userLink="https://raw.githubusercontent.com/lyublyu-shabit/zbArchive/main/userParam.conf"
$zabbixLink="https://raw.githubusercontent.com/lyublyu-shabit/zbArchive/main/zabbix.msi"
$updateLink="https://raw.githubusercontent.com/lyublyu-shabit/zbArchive/main/zbUpdate.ps1"

# Host Metadata

$metadata="SR_"
# Server Active

$serverActive="77.73.67.35"
# Security

$identity="VeryStongUserSecurity"
$key="87b895a7956add9f1a9f508ff47b5cd2fb7d09281346cdb110a8f4ceeafe138d"
#


if (Test-Path $Path -eq $false) {
    mkdir $path
}

try 
{
    wget $ZabbixLink -OutFile $Path\$ZabbixName
    Start-Sleep 7
    Start-Process msiexec -ArgumentList @(
    "/i `"$Path\$ZabbixName`"",
    "/qn",
    "SERVERACTIVE=$serverActive",
    "SERVER=127.0.0.1",
    "HOSTMETADATA=$metadata",
    "TLSCONNECT=psk",
    "TLSPSKVALUE=$key",
    "TLSACCEPT=psk",
    "ENABLEPATH=1",
    "TLSPSKIDENTITY=$identity"
) -Wait

wget $hardwareLink -OutFile "C:\Program Files\Zabbix Agent 2\zabbix_agent2.d\OpenHardwareMonitorLib.dll"
wget $UserLink -OutFile "C:\Program Files\Zabbix Agent 2\zabbix_agent2.d\UserParam.conf"
wget $updateLink -OutFile "C:\Program Files\Zabbix Agent 2\zbUpdate.ps1"

Start-Sleep -second 7

if ((Get-Service 'Zabbix Agent 2').Status | findstr.exe "Running"){
    Restart-Service 'Zabbix Agent 2'
}

#task create
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File `"C:\Program Files\Zabbix Agent 2\zbUpdate.ps1`""
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Hours 2)
# Регистрируем задачу
Register-ScheduledTask -TaskName "zbUpdate" -Action $action -Trigger $trigger -RunLevel Highest

Pause

}
catch
{
	Write-Output $PSItem
}
