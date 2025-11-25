// Central configuration for app IDs across platforms
// This file is used by universal test flows via runScript command

if (maestro.platform === 'android') {
    output.appIdUnderTest = "io.appium.android.apis";
  } else {
    output.appIdUnderTest = "com.example.apple-samplecode.UICatalog";
  }

