#!/usr/bin/env bash
# HealthTrace Flutter - Mac/Linux Setup Script
# Run this script to install all dependencies and generate required code.
# Usage: bash setup.sh   (or: chmod +x setup.sh && ./setup.sh)

set -e

echo "=== HealthTrace Flutter Setup ==="

# Check Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "ERROR: Flutter is not installed or not on PATH."
    echo "Install Flutter from https://docs.flutter.dev/get-started/install"
    exit 1
fi

echo ""
echo "Flutter version:"
flutter --version

# Install dependencies
echo ""
echo "[1/2] Installing dependencies (flutter pub get)..."
flutter pub get

# Code generation
echo ""
echo "[2/2] Running code generation (build_runner)..."
flutter pub run build_runner build --delete-conflicting-outputs

echo ""
echo "=== Setup complete! ==="
echo "Run the app with:  flutter run"
