# How to Add Test Apps

## Quick Start

### iOS Apps
```bash
# Copy your .app file to the ios folder
cp /path/to/YourApp.app apps/ios/

# Or drag and drop the .app bundle into apps/ios/ folder
```

### Android Apps
```bash
# Copy your .apk file to the android folder
cp /path/to/YourApp.apk apps/android/

# Or drag and drop the .apk file into apps/android/ folder
```

## Getting iOS .app Files

### Method 1: From Xcode Build
1. Open your iOS project in Xcode
2. Select a simulator as target (not a real device)
3. Build the app: **Product → Build** (or Cmd + B)
4. Navigate to Xcode's DerivedData folder:
   ```bash
   open ~/Library/Developer/Xcode/DerivedData/
   ```
5. Find your app folder: `YourAppName-xxx/Build/Products/Debug-iphonesimulator/`
6. Copy the entire `.app` bundle to `apps/ios/`

### Method 2: Using xcodebuild
```bash
# Build for simulator
xcodebuild -project YourApp.xcodeproj \
  -scheme YourApp \
  -configuration Debug \
  -sdk iphonesimulator \
  -derivedDataPath ./build

# The .app will be in: build/Build/Products/Debug-iphonesimulator/
cp -R build/Build/Products/Debug-iphonesimulator/YourApp.app apps/ios/
```

### Method 3: From Archive
1. In Xcode: **Product → Archive**
2. When complete, right-click on the archive → **Show in Finder**
3. Right-click the `.xcarchive` file → **Show Package Contents**
4. Navigate to: `Products/Applications/`
5. Copy the `.app` bundle to `apps/ios/`

## Getting Android .apk Files

### Method 1: From Android Studio
1. Open your Android project in Android Studio
2. Build APK: **Build → Build Bundle(s) / APK(s) → Build APK(s)**
3. When complete, click **locate** in the notification
4. Copy the `.apk` file to `apps/android/`

### Method 2: Using Gradle
```bash
# Debug build
./gradlew assembleDebug

# The APK will be at: app/build/outputs/apk/debug/app-debug.apk
cp app/build/outputs/apk/debug/app-debug.apk apps/android/

# Release build
./gradlew assembleRelease
cp app/build/outputs/apk/release/app-release.apk apps/android/
```

### Method 3: Download from Build Artifacts
If your app is built elsewhere (CI/CD, another team):
1. Download the `.apk` file
2. Copy to `apps/android/`

## File Naming Recommendations

### iOS
- Use descriptive names: `UICatalog.app`, `MyApp.app`
- Keep the `.app` extension
- The `.app` is actually a folder (bundle) - copy the whole thing

### Android
- Use descriptive names: `ApiDemos.apk`, `MyApp-debug.apk`
- Include build type if helpful: `MyApp-debug.apk`, `MyApp-release.apk`
- Keep the `.apk` extension

## Verification

### Check iOS App
```bash
# List apps in the folder
ls -la apps/ios/

# Check if it's a valid app bundle
ls apps/ios/YourApp.app/

# You should see Info.plist and other app files
```

### Check Android App
```bash
# List apps in the folder
ls -la apps/android/

# Check APK info (if aapt is installed)
aapt dump badging apps/android/YourApp.apk | grep package
```

## Testing Locally

After adding your apps:

### iOS
```bash
# Boot a simulator
xcrun simctl boot "iPhone 16 Pro"

# Install the app
xcrun simctl install booted apps/ios/YourApp.app

# Run tests
./scripts/test-ios.sh
```

### Android
```bash
# Start emulator (or use Android Studio)
emulator @Your_AVD_Name

# Install the app
adb install -r apps/android/YourApp.apk

# Run tests
./scripts/test-android.sh
```

## CI/CD (GitHub Actions)

Once you've added your apps to the folders:

1. **Commit and Push:**
   ```bash
   git add apps/
   git commit -m "Add test apps"
   git push origin main
   ```

2. **Apps are auto-installed:**
   - GitHub Actions workflows automatically detect all apps
   - iOS: All `.app` files in `apps/ios/` are installed
   - Android: All `.apk` files in `apps/android/` are installed

3. **View logs:**
   - Check GitHub Actions logs to see app installation
   - Look for "Installing YourApp.app..." messages

## Troubleshooting

### iOS: "Could not find app"
- ✅ Make sure you copied the entire `.app` bundle (it's a folder)
- ✅ Verify the app is built for simulator (not device)
- ✅ Check the bundle identifier matches your test flow's `appId`

### Android: "Installation failed"
- ✅ Make sure the `.apk` is a valid Android app
- ✅ Check if the package name matches your test flow's `appId`
- ✅ Try uninstalling old version first: `adb uninstall com.your.app`

### App not found in CI
- ✅ Check if app files are in `.gitignore` (they are by default)
- ✅ If apps are large, consider storing in GitHub Releases
- ✅ Download apps in CI workflow before running tests

## Git Large Files (Optional)

If you want to commit large app files to git:

### Option 1: Remove from .gitignore
Edit `.gitignore` and remove these lines:
```
apps/ios/*.app
apps/android/*.apk
```

### Option 2: Use Git LFS
```bash
# Install Git LFS
brew install git-lfs
git lfs install

# Track large files
git lfs track "apps/ios/*.app"
git lfs track "apps/android/*.apk"

# Commit .gitattributes
git add .gitattributes
git commit -m "Track app files with Git LFS"
```

## Alternative: External Storage

For very large apps, consider:

1. **GitHub Releases:** Upload apps as release assets
2. **Cloud Storage:** Store in S3, Google Cloud Storage, etc.
3. **Artifact Registry:** Use GitHub Packages or similar
4. **Build in CI:** Build apps as part of the CI pipeline

Then update workflows to download apps before testing.

---

**Need help?** Check the README files in each folder:
- `apps/ios/README.md`
- `apps/android/README.md`

