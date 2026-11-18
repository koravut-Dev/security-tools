# usage: .\zap-baseline.ps1 -Target https://example.com [-Name iso-one]
param([Parameter(Mandatory)][string]$Target,[string]$Name='scan')
$out = Join-Path (Split-Path $PSScriptRoot -Parent) "reports\$Name-zap-$(Get-Date -Format yyyyMMdd-HHmmss)"
New-Item -ItemType Directory -Force $out | Out-Null
docker run --rm -v "${out}:/zap/wrk:rw" ghcr.io/zaproxy/zaproxy:stable zap-baseline.py -t $Target -r zap-report.html -J zap-report.json -I
"รายงาน: $out"
