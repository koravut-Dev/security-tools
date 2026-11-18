# usage: .\zap-ajax.ps1 -Targets @{ 'iso-one'='https://iso-one.igenco.dev/' } [-Date 2026-11-16]
param([Parameter(Mandatory)][hashtable]$Targets,[string]$Date=(Get-Date -Format yyyy-MM-dd))
$r = Split-Path $PSScriptRoot -Parent
$jobs = foreach ($k in $Targets.Keys) {
  $out = "$r\results\$k\$Date\evidence\zap"; New-Item -ItemType Directory -Force $out | Out-Null
  $t = $Targets[$k].TrimEnd('/')
  Start-Job -Name $k -ArgumentList $out,$t -ScriptBlock {
    param($out,$t)
    (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ') | Set-Content "$out\started_utc.txt"
    docker run --rm -v "${out}:/zap/wrk:rw" ghcr.io/zaproxy/zaproxy:stable zap-baseline.py -t $t -j -m 3 -T 25 -r zap.html -w zap.md -x zap.xml -J zap.json -I *> "$out\scan.log"
    (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ') | Set-Content "$out\finished_utc.txt"
  }
}
$jobs | Wait-Job | Out-Null
"เสร็จ ZAP"
