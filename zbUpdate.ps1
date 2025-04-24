$confLink="https://raw.githubusercontent.com/lyublyu-shabit/zbArchive/main/userParam.conf"

function agentRestart ([int]$maxAttempts) {
    $attempt=1
    while ($attempt -le $maxAttempts) {

        Restart-Service -Name '*Zabbix*'

        if ((Get-Service -Name '*Zabbix*').Status | findstr "Running"){
            break
        }
        else {
            $attempt++
        }
        
    }   
}


if (Test-Path "C:\Program Files\Zabbix Agent 2\zabbix_agent2.d\UserParam.conf"){

    $fileA=Get-Content -Path "C:\Program Files\Zabbix Agent 2\zabbix_agent2.d\UserParam.conf"
    $fileB=(Invoke-WebRequest -Uri $confLink)

    if (Compare-Object $fileA ($fileB -replace '\r?\n\z' -split '\r?\n')){

        wget $confLink -OutFile "C:\Program Files\Zabbix Agent 2\zabbix_agent2.d\UserParam.conf"
        agentRestart 3 
    }
}
else {
    wget $confLink -OutFile "C:\Program Files\Zabbix Agent 2\zabbix_agent2.d\UserParam.conf"
    agentRestart 3 
}

if ((Get-Service -Name '*Zabbix*').Status | findstr 'Stopped') {
    agentRestart 3
} 
