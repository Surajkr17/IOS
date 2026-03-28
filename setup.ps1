# HealthTrace Flutter - Windows Setup Script
# Run this script to install all dependencies and generate required code.
# Usage: .\setup.ps1

$ErrorActionPreference = "Stop"

Write-Host "=== HealthTrace Flutter Setup ===" -ForegroundColor Cyan

# Check Flutter is installed
if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: Flutter is not installed or not on PATH." -ForegroundColor Red
    Write-Host "Install Flutter from https://docs.flutter.dev/get-started/install" -ForegroundColor Yellow
    exit 1
}

Write-Host "`nFlutter version:" -ForegroundColor Green
flutter --version

# Install dependencies
Write-Host "`n[1/2] Installing dependencies (flutter pub get)..." -ForegroundColor Green
flutter pub get
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: flutter pub get failed." -ForegroundColor Red
    exit 1
}

# Code generation
Write-Host "`n[2/2] Running code generation (build_runner)..." -ForegroundColor Green
flutter pub run build_runner build --delete-conflicting-outputs
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: build_runner failed." -ForegroundColor Red
    exit 1
}

Write-Host "`n=== Setup complete! ===" -ForegroundColor Cyan
Write-Host "Run the app with:  flutter run" -ForegroundColor Yellow
