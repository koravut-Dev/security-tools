# usage: .\scan-one.ps1 -Name iso-one [-Url https://...]   (repo ใน targets\repos\<Name>)
param([Parameter(Mandatory)][string]$Name,[string]$Url)
$r = Split-Path $PSScriptRoot -Parent
. "$r\scripts\env.ps1" | Out-Null
$p = "$r\targets\repos\$Name"; $o = "$r\reports\$Name-$(Get-Date -Format yyyyMMdd-HHmmss)"
New-Item -ItemType Directory -Force $o | Out-Null
trivy fs --scanners vuln --severity HIGH,CRITICAL --skip-dirs node_modules --skip-dirs .next --skip-dirs vendor --format json -o "$o\trivy.json" $p 2>"$o\trivy.err"
trivy fs --scanners vuln --severity HIGH,CRITICAL --skip-dirs node_modules --skip-dirs .next --skip-dirs vendor -o "$o\trivy.txt" $p 2>$null
gitleaks dir $p --no-banner --redact -r "$o\gitleaks-dir.json" -f json --exit-code 0 2>"$o\gitleaks-dir.log"
if (Test-Path "$p\.git") { gitleaks git $p --no-banner --redact -r "$o\gitleaks-history.json" -f json --exit-code 0 2>"$o\gitleaks-history.log" }
osv-scanner scan source -r --format json --output-file "$o\osv.json" $p 2>"$o\osv.err"
docker run --rm -v "${p}:/src:ro" -v "${o}:/out" semgrep/semgrep semgrep scan --config p/default --metrics off --exclude node_modules --exclude .next --json -o /out/semgrep.json /src 2>"$o\semgrep.err"
if ($Url) { & "$r\scripts\zap-baseline.ps1" -Target $Url -Name $Name }
"เสร็จ $Name"
