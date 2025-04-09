$HostId = "TestSec"
$Key = "02aa4e5e90b94c17fe5fa59d3228f5efe48d8c348712baff284189717e208828"
$Path = "C:\Program Files\zabbix"
$ZabbixName="zabbix.msi"
$LogFile=$HOME+"\log.txt"
$UserLink="https://clck.ru/3L6wWb"
$ZabbixLink="https://clck.ru/3LA5Mv"

mkdir $Path
wget $ZabbixLink -OutFile $Path\$ZabbixName

echo $key > "$Path\zabbix.txt"
Start-Sleep -second 5
Start-Process msiexec -ArgumentList @(
    "/i `"$Path\$ZabbixName`"",
    "/qn",
    "SERVERACTIVE=192.168.58.226",
    "SERVER=127.0.0.1",
    "HOSTNAME=ServerAlex",
    "HOSTMETADATA=OKS_",
    "TLSCONNECT=psk",
    "TLSACCEPT=psk",
    "ENABLEPATH=1",
    "TLSPSKIDENTITY=$HostId",
    "TLSPSKFILE=`"$Path\zabbix.txt`"",
    "/l*v `"$Path\log.txt`""
) -Wait

wget $UserLink -OutFile "C:\Program Files\Zabbix Agent 2\zabbix_agent2.d\UserParam.conf"
Stop-Service 'Zabbix Agent 2'
Start-Service 'Zabbix Agent 2'
echo "HELLO"
Pause
