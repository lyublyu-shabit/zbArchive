$HostId = "TestSec"
$Key = "02aa4e5e90b94c17fe5fa59d3228f5efe48d8c348712baff284189717e208828"
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
    "SERVERACTIVE=192.168.58.226",
    "SERVER=127.0.0.1",
    "HOSTNAME=ServerAlex",
    "HOSTMETADATA=OKS_",
    "TLSCONNECT=psk",
	"TLSPSKVALUE=02aa4e5e90b94c17fe5fa59d3228f5efe48d8c348712baff284189717e208828",
    "TLSACCEPT=psk",
    "ENABLEPATH=1",
    "TLSPSKIDENTITY=$HostId",
    "/l*v `"$Path\log.txt`""
) -Wait

wget $UserLink -OutFile "C:\Program Files\Zabbix Agent 2\zabbix_agent2.d\UserParam.conf"
Stop-Service 'Zabbix Agent 2'
Start-Service 'Zabbix Agent 2'
echo "HELLO"
Pause
}
catch
{
	echo $PSItem
}

