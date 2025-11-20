# iOS Apps

Place your iOS `.app` files in this directory for testing.

## File Format

iOS apps should be in `.app` format (application bundle).

## Example Files

```
apps/ios/
├── UICatalog.app/          # Your test app bundle
├── MyApp.app/              # Another test app
└── README.md               # This file
```

## Getting .app Files

### From Xcode Build:
1. Build your app in Xcode (Cmd + B)
2. Navigate to: `~/Library/Developer/Xcode/DerivedData/`
3. Find your app: `YourApp-xxx/Build/Products/Debug-iphonesimulator/YourApp.app`
4. Copy the entire `.app` bundle here

### From Archive:
1. In Xcode: Product → Archive
2. Right-click archive → Show in Finder
3. Right-click .xcarchive → Show Package Contents
4. Navigate to: Products/Applications/
5. Copy the .app bundle here

## Usage in Tests

The workflows will automatically install apps from this directory before running tests.

## Note

`.app` files are excluded from git by default due to their size.
If you need to include them in the repository, update `.gitignore`.

