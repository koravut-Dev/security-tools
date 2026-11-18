# usage: .\run-all.ps1   (เธชเนเธเธเธ—เธธเธ repo เนเธ targets\repos เนเธฅเธฐ URL เนเธ targets\urls\urls.txt)
$r = Split-Path $PSScriptRoot -Parent
. "$r\scripts\env.ps1" | Out-Null
$ts = Get-Date -Format yyyyMMdd-HHmmss
$skip = 'node_modules,.next,dist,build,.git,coverage,.dart_tool,vendor'
foreach ($d in Get-ChildItem "$r\targets\repos" -Directory) {
  $n = $d.Name; $p = $d.FullName; $o = "$r\reports\$n-$ts"; New-Item -ItemType Directory -Force $o | Out-Null
  "== $n =="
  trivy fs --scanners vuln --severity HIGH,CRITICAL --skip-dirs node_modules --skip-dirs .next --skip-dirs vendor --format json -o "$o\trivy.json" $p 2>"$o\trivy.err"
  trivy fs --scanners vuln --severity HIGH,CRITICAL --skip-dirs node_modules --skip-dirs .next --skip-dirs vendor -o "$o\trivy.txt" $p 2>$null
  gitleaks dir $p --no-banner --redact -r "$o\gitleaks-dir.json" -f json --exit-code 0 2>"$o\gitleaks-dir.log"
  if (Test-Path "$p\.git") { gitleaks git $p --no-banner --redact -r "$o\gitleaks-history.json" -f json --exit-code 0 2>"$o\gitleaks-history.log" }
  osv-scanner scan source -r --format json --output-file "$o\osv.json" $p 2>"$o\osv.err"
  docker run --rm -v "${p}:/src:ro" -v "${o}:/out" semgrep/semgrep semgrep scan --config p/default --metrics off --exclude node_modules --exclude .next --json -o /out/semgrep.json /src 2>"$o\semgrep.err"
}
foreach ($l in Get-Content "$r\targets\urls\urls.txt" | Where-Object { $_ -and $_ -notmatch '^\s*#' }) {
  $parts = $l -split '\s+',2; & "$r\scripts\zap-baseline.ps1" -Target $parts[1].Trim() -Name $parts[0]
}
"เน€เธชเธฃเนเธ $(Get-Date)"

