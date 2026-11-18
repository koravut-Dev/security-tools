# dot-source: . D:\BANK\security-tools\scripts\env.ps1
$r = Split-Path $PSScriptRoot -Parent
$env:PATH = "$r\bin\trivy;$r\bin\gitleaks;$r\bin\osv-scanner;$env:PATH"
"trivy / gitleaks / osv-scanner พร้อมใช้ใน session นี้"
