# usage: .\semgrep.ps1 -Path D:\iso-one [-Name iso-one]
param([Parameter(Mandatory)][string]$Path,[string]$Name='scan')
$out = Join-Path (Split-Path $PSScriptRoot -Parent) "reports"
docker run --rm -v "${Path}:/src:ro" -v "${out}:/out" semgrep/semgrep semgrep scan --config auto --json -o "/out/$Name-semgrep-$(Get-Date -Format yyyyMMdd).json" /src
