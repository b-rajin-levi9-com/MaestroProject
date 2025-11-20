# Maestro Test Suite

[![Maestro UI Tests](https://github.com/YOUR_USERNAME/YOUR_REPO/actions/workflows/maestro-tests.yml/badge.svg)](https://github.com/YOUR_USERNAME/YOUR_REPO/actions/workflows/maestro-tests.yml)

This repository contains automated UI tests for iOS and Android applications using Maestro.

> **Note:** Replace `YOUR_USERNAME/YOUR_REPO` in the badge URL above with your actual GitHub username and repository name.

## Project Structure

```
maestro/
├── flows/
│   ├── ios/              # iOS test flows
│   │   ├── ios_first_flow.yaml
│   │   ├── ios_search_test.yaml
│   │   └── ios_text_fields_test.yaml
│   └── android/          # Android test flows
│       └── android_first_flow.yaml
├── apps/
│   ├── ios/              # iOS .app files (place your apps here)
│   └── android/          # Android .apk files (place your APKs here)
├── reports/
│   ├── ios/              # iOS test reports
│   └── android/          # Android test reports
├── scripts/              # Helper scripts
│   ├── test-ios.sh       # Run all iOS tests
│   └── test-android.sh   # Run all Android tests
└── README.md
```

## Prerequisites

- Maestro CLI installed (`brew tap mobile-dev-inc/tap && brew install maestro`)
- iOS Simulator (for iOS tests)
- Android Emulator (for Android tests)

## Setting Up Test Apps

### iOS Apps
1. Place your iOS `.app` files in the `apps/ios/` directory
2. See `apps/ios/README.md` for instructions on getting .app files

### Android Apps
1. Place your Android `.apk` files in the `apps/android/` directory
2. See `apps/android/README.md` for instructions on getting .apk files

**Important - Apps in Git:**
- App files are **INCLUDED in git by default** (< 100MB works fine)
- For larger apps (> 100MB), see `APPS_IN_CI_CD.md` for alternatives:
  - Git LFS (recommended for 100MB - 2GB)
  - GitHub Releases (free for very large apps)
  - Build in CI pipeline
  - External storage (S3, GCS, etc.)

## Running Tests

### iOS Tests

Run all iOS tests:
```bash
./scripts/test-ios.sh
```

Or run a specific iOS test:
```bash
maestro test flows/ios/ios_search_test.yaml --format=JUNIT --output=reports/ios/test-results.xml
```

### Android Tests

Run all Android tests:
```bash
./scripts/test-android.sh
```

Or run a specific Android test:
```bash
maestro test flows/android/first_flow_android.yaml --format=JUNIT --output=reports/android/test-results.xml
```

## Test Descriptions

### iOS Tests

- **ios_first_flow.yaml**: Tests UICatalog app navigation through Stack Views, Steppers, and Alert Views
- **ios_search_test.yaml**: Tests search functionality - navigates to Search > Default, enters "First Search" and validates the text
- **ios_text_fields_test.yaml**: Tests text input functionality - navigates to Text Fields, enters "First text" in the first field, "Second text" in the second field, and validates both are displayed correctly

### Android Tests

- **android_first_flow.yaml**: Tests API Demos app - navigates to Graphics > AlphaBitmap

## Troubleshooting

If tests hang or fail to start:

1. Kill stale Maestro processes:
   ```bash
   pkill -9 -f "maestro"
   ```

2. If iOS driver times out, increase the timeout:
   ```bash
   export MAESTRO_DRIVER_STARTUP_TIMEOUT=120000
   ```

3. Verify your simulator/emulator is running:
   ```bash
   # iOS
   xcrun simctl list devices | grep Booted
   
   # Android
   adb devices
   ```

## CI/CD Integration

### GitHub Actions

This project includes automated GitHub Actions workflows:

#### Automatic Tests (on push/PR)
**File:** `.github/workflows/maestro-tests.yml`

Automatically runs on:
- Push to `main` or `develop` branches
- Pull requests to `main` or `develop` branches

Features:
- ✅ Runs iOS tests on macOS runner
- ✅ Runs Android tests on Ubuntu with emulator
- ✅ Generates JUnit XML reports
- ✅ Uploads test artifacts
- ✅ Publishes test results summary

#### Manual Tests (on-demand)
**File:** `.github/workflows/maestro-manual.yml`

Manually trigger from GitHub UI with options:
- Choose platform: iOS, Android, or both
- Optionally specify a single test file to run

**To run manually:**
1. Go to Actions tab in GitHub
2. Select "Manual Maestro Tests"
3. Click "Run workflow"
4. Choose platform and optional test file
5. Click "Run workflow" button

### Setting up CI/CD

1. Add your test apps to `apps/ios/` and `apps/android/` directories
2. Push your code to GitHub (apps are auto-installed before tests run)
3. Workflows will automatically run on push/PR
4. View results in the Actions tab
5. Download test reports from artifacts

**App Installation:** Workflows automatically install all apps from:
- `apps/ios/*.app` for iOS tests
- `apps/android/*.apk` for Android tests

## Reports

Test reports are automatically saved in the `reports/` directory:
- iOS reports: `reports/ios/`
- Android reports: `reports/android/`

Reports are generated in JUnit XML format for easy integration with CI/CD systems.

In GitHub Actions, reports are available as downloadable artifacts for 30 days (7 days for manual tests).

