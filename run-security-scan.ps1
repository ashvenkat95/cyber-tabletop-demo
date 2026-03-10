# DevSecOps Local Security Scan Script
# Run Snyk (dependency scan) and GitLeaks (secret detection) locally

Write-Host "=== DevSecOps Security Scan ===" -ForegroundColor Cyan
Write-Host ""

# Snyk dependency scan
Write-Host "[1/2] Running Snyk (Dependency Vulnerabilities)..." -ForegroundColor Yellow
if ($env:SNYK_TOKEN) {
    Push-Location backend
    npx snyk test
    $snykExit = $LASTEXITCODE
    Pop-Location
} else {
    Write-Host "  SNYK_TOKEN not set. Get one from https://app.snyk.io then:" -ForegroundColor Red
    Write-Host '  $env:SNYK_TOKEN = "your-snyk-token"' -ForegroundColor Gray
    $snykExit = 1
}
Write-Host ""

# GitLeaks scan
Write-Host "[2/2] Running GitLeaks (Secret Detection)..." -ForegroundColor Yellow
$gitleaksCmd = Get-Command gitleaks -ErrorAction SilentlyContinue
if ($gitleaksCmd) {
    gitleaks detect --no-git
} else {
    docker run --rm -v "${PWD}:/repo" zricethezav/gitleaks:v8.18.0 detect --source=/repo --no-git
}
$gitleaksExit = $LASTEXITCODE
Write-Host ""

if ($snykExit -eq 0 -and $gitleaksExit -eq 0) {
    Write-Host "=== All scans PASSED ===" -ForegroundColor Green
} else {
    Write-Host "=== Scans detected issues (see above) ===" -ForegroundColor Red
}
