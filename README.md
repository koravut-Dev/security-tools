# เครื่องมือสแกนความปลอดภัย

| เครื่องมือ | ชนิด | ที่อยู่ / วิธีรัน |
|---|---|---|
| OWASP ZAP stable | DAST | Docker image `ghcr.io/zaproxy/zaproxy:stable` → `scripts\zap-baseline.ps1` |
| Semgrep | SAST | Docker image `semgrep/semgrep` → `scripts\semgrep.ps1` |
| Trivy 0.76.2 | SCA | `bin\trivy\trivy.exe` |
| gitleaks 8.30.1 | secret | `bin\gitleaks\gitleaks.exe` |
| osv-scanner 2.7.1 | SCA | `bin\osv-scanner\osv-scanner.exe` |
| pnpm audit | SCA | มากับ pnpm (`pnpm audit`) |

เริ่มใช้: `. D:\BANK\security-tools\scripts\env.ps1` แล้วเรียก `trivy`, `gitleaks`, `osv-scanner` ได้เลย
ผลลัพธ์เก็บใน `reports\`; ไฟล์ติดตั้งดั้งเดิมอยู่ `_downloads\`

## วางเป้าหมายสแกน
- repo: `targets\repos\<ชื่อ>\`
- URL: `targets\urls\urls.txt`

