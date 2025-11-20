# Maestro Quick Start Guide

## 🚀 Quick Commands

### Run All iOS Tests
```bash
./scripts/test-ios.sh
```

### Run All Android Tests
```bash
./scripts/test-android.sh
```

### Run a Single Test

**iOS:**
```bash
maestro test flows/ios/ios_search_test.yaml --format=JUNIT --output=reports/ios/test-results.xml
```

**Android:**
```bash
maestro test flows/android/first_flow_android.yaml --format=JUNIT --output=reports/android/test-results.xml
```

## 📁 Project Structure

```
maestro/
├── flows/
│   ├── ios/              # iOS test flows (.yaml)
│   └── android/          # Android test flows (.yaml)
├── reports/
│   ├── ios/              # iOS test reports (.xml)
│   └── android/          # Android test reports (.xml)
└── scripts/
    ├── test-ios.sh       # iOS test runner
    └── test-android.sh   # Android test runner
```

## 🛠️ Common Tasks

### Adding a New iOS Test
1. Create a new `.yaml` file in `flows/ios/`
2. Run: `./scripts/test-ios.sh` to test it

### Adding a New Android Test
1. Create a new `.yaml` file in `flows/android/`
2. Run: `./scripts/test-android.sh` to test it

## 🐛 Troubleshooting

### Tests Hanging?
```bash
# Kill stale Maestro processes
pkill -9 -f "maestro"

# Then retry your test
```

### No Simulator/Emulator Running?
```bash
# iOS - Check running simulators
xcrun simctl list devices | grep Booted

# iOS - Boot a specific simulator
xcrun simctl boot <device-id>

# Android - Check running emulators
adb devices
```

### Driver Timeout?
```bash
# Increase timeout before running test
export MAESTRO_DRIVER_STARTUP_TIMEOUT=120000
```

## 📊 Viewing Reports

Reports are saved as JUnit XML in the `reports/` directory with timestamps:
- iOS: `reports/ios/test-results-YYYYMMDD_HHMMSS.xml`
- Android: `reports/android/test-results-YYYYMMDD_HHMMSS.xml`

## 💡 Tips

1. Always make scripts executable: `chmod +x scripts/*.sh`
2. Kill stale processes if tests hang: `pkill -9 -f "maestro"`
3. Use `--format=JUNIT` for CI/CD integration
4. Keep test flows organized by platform
5. Name tests descriptively (e.g., `login_test.yaml`, `checkout_flow.yaml`)

