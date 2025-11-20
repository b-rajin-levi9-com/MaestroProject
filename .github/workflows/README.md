# GitHub Actions Workflows

This directory contains GitHub Actions workflows for automated Maestro testing.

## Workflows

### 1. maestro-tests.yml (Automated CI)

**Triggers:**
- Push to `main` or `develop` branches
- Pull requests to `main` or `develop` branches
- Manual dispatch from GitHub UI

**Jobs:**

#### iOS Tests
- **Runner:** `macos-14` (Apple Silicon)
- **Timeout:** 30 minutes
- **Steps:**
  1. Checkout code
  2. List and boot iOS simulator
  3. Install Maestro CLI
  4. Run all iOS tests from `flows/ios/`
  5. Upload test reports as artifacts
  6. Publish test results to PR

#### Android Tests
- **Runner:** `ubuntu-latest`
- **Timeout:** 30 minutes
- **Steps:**
  1. Checkout code
  2. Enable KVM for emulator
  3. Setup JDK 17
  4. Install Maestro CLI
  5. Cache AVD for faster runs
  6. Start Android emulator
  7. Run all Android tests from `flows/android/`
  8. Upload test reports as artifacts
  9. Publish test results to PR

#### Test Summary
- **Runner:** `ubuntu-latest`
- **Depends on:** ios-tests, android-tests
- **Steps:**
  1. Download all test artifacts
  2. Generate summary report
  3. Add summary to GitHub Actions UI

### 2. maestro-manual.yml (Manual Testing)

**Triggers:**
- Manual dispatch only (workflow_dispatch)

**Inputs:**
- `platform`: Choose iOS, Android, or both
- `test_file`: (Optional) Specify a single test file

**Jobs:**

#### iOS Manual Test
- Runs only if platform is `ios` or `both`
- Same setup as automated iOS tests
- Can run specific test file if provided

#### Android Manual Test
- Runs only if platform is `android` or `both`
- Same setup as automated Android tests
- Can run specific test file if provided

## Configuration

### Environment Variables

**iOS Tests:**
- `MAESTRO_DRIVER_STARTUP_TIMEOUT=120000` - Increases driver timeout to 120 seconds

**Android Tests:**
- Uses default Maestro configuration

### Caching

**AVD Cache:**
- Caches Android Virtual Device to speed up subsequent runs
- Cache key: `avd-30`
- Reduces setup time from ~10 minutes to ~2 minutes

### Artifacts

**Automatic Tests:**
- Retention: 30 days
- Names:
  - `ios-test-reports`
  - `android-test-reports`

**Manual Tests:**
- Retention: 7 days
- Names:
  - `ios-manual-test-reports`
  - `android-manual-test-reports`

## Customization

### Changing iOS Simulator

Edit the simulator selection in the workflow:

```yaml
- name: Boot iOS Simulator
  run: |
    # Change "iPhone 16 Pro" to your desired simulator
    DEVICE_ID=$(xcrun simctl list devices available | grep "iPhone 15 Pro" | ...)
```

### Changing Android Emulator

Edit the emulator configuration:

```yaml
- name: Run Android tests
  uses: reactivecircus/android-emulator-runner@v2
  with:
    api-level: 33  # Change API level
    target: google_apis  # Or google_atd, default, etc.
    arch: x86_64  # Or arm64-v8a
    profile: pixel_7  # Change device profile
```

### Adding Test Apps

For iOS tests, you may need to:
1. Include the `.app` file in your repository, or
2. Add a step to download/build the app before running tests

Example:
```yaml
- name: Install test app
  run: |
    xcrun simctl install $DEVICE_ID path/to/YourApp.app
```

For Android tests:
```yaml
- name: Install test app
  run: |
    adb install path/to/YourApp.apk
```

### Changing Branches

Edit the trigger branches:

```yaml
on:
  push:
    branches: [ main, develop, feature/* ]  # Add your branches
  pull_request:
    branches: [ main, develop ]
```

### Adding Slack/Email Notifications

Add a notification step at the end of jobs:

```yaml
- name: Notify Slack
  if: always()
  uses: 8398a7/action-slack@v3
  with:
    status: ${{ job.status }}
    text: 'Maestro tests completed'
    webhook_url: ${{ secrets.SLACK_WEBHOOK }}
```

## Troubleshooting

### iOS Tests Failing

1. **Simulator timeout:** Increase timeout in workflow
2. **App not found:** Add app installation step
3. **Driver timeout:** Already configured with `MAESTRO_DRIVER_STARTUP_TIMEOUT`

### Android Tests Failing

1. **Emulator timeout:** Increase `timeout-minutes` in workflow
2. **KVM issues:** GitHub runners support KVM, but check logs
3. **App not found:** Add APK installation step

### Slow Runs

1. **AVD cache:** Ensure cache is working (check logs)
2. **Parallel jobs:** iOS and Android run in parallel
3. **Reduce tests:** Use manual workflow to test specific files

## Cost Optimization

### GitHub Actions Minutes

- **macOS runners:** Count as 10x Linux minutes
- **Ubuntu runners:** Count as 1x minutes

**Estimated costs per run:**
- iOS tests: ~20-30 macOS minutes (200-300 Linux equivalent)
- Android tests: ~15-20 Linux minutes

**Free tier:** 2,000 minutes/month for free accounts

### Optimization Tips

1. Use manual workflow for development
2. Run full suite only on `main` branch
3. Skip CI with `[skip ci]` in commit message
4. Cache AVD and dependencies
5. Run tests only on changed files (add path filters)

Example path filter:
```yaml
on:
  push:
    branches: [ main ]
    paths:
      - 'flows/ios/**'
      - 'flows/android/**'
      - '.github/workflows/**'
```

