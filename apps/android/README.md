# Android Apps

Place your Android `.apk` files in this directory for testing.

## File Format

Android apps should be in `.apk` format.

## Example Files

```
apps/android/
├── ApiDemos.apk           # Your test app
├── MyApp-debug.apk        # Debug build
├── MyApp-release.apk      # Release build
└── README.md              # This file
```

## Getting .apk Files

### From Android Studio Build:
1. Build your app: Build → Build Bundle(s) / APK(s) → Build APK(s)
2. Click "locate" in the build notification
3. Copy the `.apk` file here

### From Command Line:
```bash
./gradlew assembleDebug
# APK location: app/build/outputs/apk/debug/app-debug.apk
```

## Common APK Locations

- Debug: `app/build/outputs/apk/debug/app-debug.apk`
- Release: `app/build/outputs/apk/release/app-release.apk`

## Usage in Tests

The workflows will automatically install APKs from this directory before running tests.

## Note

`.apk` files are excluded from git by default due to their size.
If you need to include them in the repository, update `.gitignore`.

