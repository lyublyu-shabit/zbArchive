$Path = "C:\Program Files\zabbix"
$ZabbixName="zabbix.msi"
$LogFile=$HOME+"\log.txt"
$UserLink="https://raw.githubusercontent.com/lyublyu-shabit/zbArchive/a5d79c7228d7351145f89ff380eedf9cb92fbb5c/userParam.conf"
$ZabbixLink="https://raw.githubusercontent.com/lyublyu-shabit/zbArchive/main/zabbix.msi"

mkdir $Path



try 
{
    wget $ZabbixLink -OutFile $Path\$ZabbixName
    Start-Sleep -second 5
    Start-Process msiexec -ArgumentList @(
    "/i `"$Path\$ZabbixName`"",
    "/qn",
    "SERVERACTIVE=77.73.67.35",
    "SERVER=127.0.0.1",
    "HOSTMETADATA=OKS_",
    "TLSCONNECT=psk",
    "TLSPSKVALUE=87b895a7956add9f1a9f508ff47b5cd2fb7d09281346cdb110a8f4ceeafe138d",
    "TLSACCEPT=psk",
    "ENABLEPATH=1",
    "TLSPSKIDENTITY=VeryStongUserSecurity",
    "/l*v `"$Path\log.txt`""
) -Wait

wget $UserLink -OutFile "C:\Program Files\Zabbix Agent 2\zabbix_agent2.d\UserParam.conf"

echo "Restarting Zabbix agent2, please wait"
Start-Sleep -second 7

Stop-Service 'Zabbix Agent 2'
Start-Service 'Zabbix Agent 2'
echo "HELLO"
Pause
}
catch
{
	echo $PSItem
}

