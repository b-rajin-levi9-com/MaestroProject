# CI/CD Quick Guide

## 🔄 Workflow Triggers

### Automatic (maestro-tests.yml)
```bash
# Triggers automatically on:
git push origin main          # Push to main
git push origin develop       # Push to develop
# Create PR to main/develop   # Pull requests
```

### Manual (maestro-manual.yml)
1. Go to GitHub → Actions tab
2. Select "Manual Maestro Tests"
3. Click "Run workflow"
4. Choose options:
   - Platform: `ios`, `android`, or `both`
   - Test file: (optional) e.g., `ios_search_test.yaml`
5. Click "Run workflow"

## 📊 Viewing Results

### In GitHub Actions
1. Go to **Actions** tab
2. Click on a workflow run
3. View jobs: `ios-tests`, `android-tests`, `test-summary`
4. Click job to see detailed logs
5. Download artifacts from "Artifacts" section

### Test Reports
- **Location:** Artifacts section at bottom of workflow run
- **Format:** JUnit XML
- **Retention:**
  - Automatic tests: 30 days
  - Manual tests: 7 days

### Test Summary
- Auto-generated at bottom of workflow run
- Shows pass/fail for each platform
- Links to detailed results

## 🛠️ Common Customizations

### Change Target Branches
Edit `.github/workflows/maestro-tests.yml`:
```yaml
on:
  push:
    branches: [ main, develop, staging ]  # Add your branches
  pull_request:
    branches: [ main ]
```

### Change iOS Simulator
Edit `.github/workflows/maestro-tests.yml`:
```yaml
- name: Boot iOS Simulator
  run: |
    # Change device name here
    DEVICE_ID=$(xcrun simctl list devices available | grep "iPhone 15 Pro" | ...)
```

### Change Android Emulator
Edit `.github/workflows/maestro-tests.yml`:
```yaml
- name: Run Android tests
  uses: reactivecircus/android-emulator-runner@v2
  with:
    api-level: 34              # Change API level
    target: google_apis
    arch: x86_64
    profile: pixel_8           # Change device profile
```

### Install Test Apps
Add before running tests:

**iOS:**
```yaml
- name: Install iOS app
  run: |
    # Download or copy your .app
    xcrun simctl install $DEVICE_ID path/to/YourApp.app
```

**Android:**
```yaml
- name: Install Android app
  run: |
    # Download or copy your .apk
    adb wait-for-device
    adb install path/to/YourApp.apk
```

### Run Only on File Changes
Add path filters:
```yaml
on:
  push:
    branches: [ main ]
    paths:
      - 'flows/**'              # Only run when flows change
      - '.github/workflows/**'  # Or when workflows change
```

### Skip CI for Specific Commits
Include `[skip ci]` in commit message:
```bash
git commit -m "Update docs [skip ci]"
```

## 🔧 Troubleshooting

### Workflow Not Running
- ✅ Check if Actions are enabled in repo settings
- ✅ Verify workflow file syntax (YAML indentation)
- ✅ Check trigger conditions (branch names, paths)

### iOS Tests Failing
```yaml
# Increase timeout
timeout-minutes: 45  # Default is 30

# Check simulator availability
- name: List available simulators
  run: xcrun simctl list devices available

# Increase driver timeout (already configured)
MAESTRO_DRIVER_STARTUP_TIMEOUT=120000
```

### Android Tests Failing
```yaml
# Increase timeout
timeout-minutes: 45

# Check AVD cache
- name: Clear AVD cache
  run: |
    rm -rf ~/.android/avd/*
```

### Tests Passing Locally But Failing in CI
- ✅ Check app is installed in workflow
- ✅ Verify simulator/emulator configuration matches
- ✅ Check for hardcoded paths
- ✅ Review logs for specific errors

## 💰 GitHub Actions Costs

### Free Tier (per month)
- Private repos: 2,000 minutes/month
- Public repos: Unlimited

### Runner Costs
- **macOS:** 10x multiplier (iOS tests ~20 min = 200 minutes)
- **Ubuntu:** 1x multiplier (Android tests ~15 min = 15 minutes)
- **Full run:** ~215 equivalent minutes per run

### Cost Optimization
1. **Use manual workflow** for development
2. **Run full suite** only on `main` branch
3. **Add path filters** to run only when needed
4. **Cache dependencies** (AVD cache already configured)
5. **Run specific tests** using manual workflow

Example: Run only on main
```yaml
on:
  push:
    branches: [ main ]  # Remove develop
  pull_request:
    branches: [ main ]
```

## 📝 Adding Notifications

### Slack Notifications
Add to end of jobs:
```yaml
- name: Slack Notification
  if: always()
  uses: 8398a7/action-slack@v3
  with:
    status: ${{ job.status }}
    text: 'Maestro ${{ job.status }}'
    webhook_url: ${{ secrets.SLACK_WEBHOOK }}
```

Then add webhook in GitHub Settings → Secrets → Actions:
- Name: `SLACK_WEBHOOK`
- Value: Your Slack webhook URL

### Email Notifications
GitHub automatically sends emails on workflow failures if enabled in your notification settings.

## 🔐 Secrets Management

If your tests need API keys or credentials:

1. Go to GitHub repo → Settings → Secrets and variables → Actions
2. Click "New repository secret"
3. Add secrets (e.g., `API_KEY`, `TEST_PASSWORD`)
4. Use in workflow:
   ```yaml
   - name: Run tests with secrets
     env:
       API_KEY: ${{ secrets.API_KEY }}
     run: maestro test flows/ios/ --env API_KEY=$API_KEY
   ```

## 📈 Monitoring

### View Historical Data
1. Go to Actions tab
2. Click "Maestro UI Tests" workflow
3. View all runs with status
4. Check trends over time

### Weekly Summary Email
GitHub can send weekly summary of Actions:
- Settings → Notifications → Actions
- Enable "Send notifications for failed workflows"

## 🎯 Best Practices

1. ✅ **Test locally first** with scripts before committing
2. ✅ **Use manual workflow** during development
3. ✅ **Add descriptive commit messages** for easy debugging
4. ✅ **Review logs** if tests fail in CI
5. ✅ **Keep workflows updated** with latest action versions
6. ✅ **Monitor costs** especially with iOS tests
7. ✅ **Use path filters** to reduce unnecessary runs
8. ✅ **Cache dependencies** (AVD already cached)
9. ✅ **Document changes** to workflows
10. ✅ **Test workflow changes** on feature branch first

## 🆘 Getting Help

- **GitHub Actions Docs:** https://docs.github.com/actions
- **Maestro Docs:** https://maestro.mobile.dev
- **Workflow Logs:** Check detailed logs in Actions tab
- **Community:** Maestro Discord, GitHub Discussions

