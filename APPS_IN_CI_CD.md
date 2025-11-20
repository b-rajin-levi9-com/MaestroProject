# Apps in CI/CD: How It Works

## The Problem

GitHub Actions workflows can only access files that are in your git repository. If app files are in `.gitignore`, they won't be available in CI.

## Current Setup

**By default, app files are NOW INCLUDED in git** (`.gitignore` lines are commented out).

This means:
- ✅ Apps are committed to repository
- ✅ GitHub Actions can access them
- ✅ Workflows will install and test automatically
- ⚠️ Only works if apps are small enough (<100MB per file)

## Solutions for Large Apps

If your apps are too large to commit to git, use one of these alternatives:

---

### **Option 1: Commit to Git (Default - Simplest)**

**When to use:**
- App files are < 100MB each
- Simple setup, no extra steps needed

**Setup:**
```bash
# Apps are included by default now
# Just add and commit normally
git add apps/
git commit -m "Add test apps"
git push
```

**Pros:**
- ✅ Simplest solution
- ✅ No extra configuration
- ✅ Works out of the box

**Cons:**
- ❌ Only works for smaller apps
- ❌ Increases repository size

---

### **Option 2: Git LFS (Best for Large Files)**

**When to use:**
- App files are 100MB - 2GB
- Want to keep apps in repo but not bloat it
- GitHub plan supports LFS storage

**Setup:**
```bash
# Install Git LFS
brew install git-lfs
git lfs install

# Track app files with LFS
git lfs track "apps/ios/*.app/**"
git lfs track "apps/android/*.apk"

# Commit the .gitattributes file
git add .gitattributes
git commit -m "Configure Git LFS for app files"

# Now add your apps
git add apps/
git commit -m "Add test apps via LFS"
git push
```

**Update .gitignore:**
```bash
# Remove or comment out these lines to track with LFS:
# apps/ios/*.app
# apps/android/*.apk
```

**Pros:**
- ✅ Handles large files efficiently
- ✅ Apps stay in repo (easy access)
- ✅ Doesn't bloat git history
- ✅ Works with existing workflows

**Cons:**
- ❌ Requires LFS setup
- ❌ GitHub LFS has storage limits (1GB free, then paid)
- ❌ Extra cost if you exceed limits

**GitHub LFS Limits:**
- Free: 1GB storage, 1GB/month bandwidth
- Team: 50GB storage, 50GB/month bandwidth
- Enterprise: 100GB storage, 100GB/month bandwidth

---

### **Option 3: GitHub Releases (Recommended for Very Large Apps)**

**When to use:**
- App files are very large (> 2GB)
- Don't want to pay for LFS storage
- Apps change infrequently

**Setup:**

1. **Create a GitHub Release:**
   ```bash
   # Create a release (one-time setup)
   gh release create v1.0.0-apps --title "Test Apps" --notes "Apps for Maestro testing"
   ```

2. **Upload your apps:**
   ```bash
   # For iOS apps (zip them first)
   cd apps/ios
   zip -r UICatalog.app.zip UICatalog.app
   gh release upload v1.0.0-apps UICatalog.app.zip
   
   # For Android apps
   gh release upload v1.0.0-apps ../android/ApiDemos.apk
   ```

3. **Use the example workflow:**
   ```bash
   # Rename the example workflow
   mv .github/workflows/maestro-tests-with-releases.yml.example \
      .github/workflows/maestro-tests-with-releases.yml
   
   # Edit the workflow to set your release tag and app names
   # Then disable the regular workflow
   ```

4. **Update the workflow with your details:**
   ```yaml
   RELEASE_TAG="v1.0.0-apps"  # Your release tag
   APP_NAME="UICatalog.app"   # Your app name
   APK_NAME="ApiDemos.apk"    # Your APK name
   ```

5. **Keep apps in .gitignore:**
   ```bash
   # Uncomment these lines in .gitignore:
   apps/ios/*.app
   apps/android/*.apk
   ```

**Pros:**
- ✅ No size limits (2GB per file)
- ✅ No extra storage costs
- ✅ Apps separate from code history
- ✅ Easy to update (just re-upload to release)

**Cons:**
- ❌ Requires manual upload to release
- ❌ More complex workflow setup
- ❌ Need to update workflow when apps change

---

### **Option 4: Build Apps in CI**

**When to use:**
- You have access to app source code
- Want always up-to-date apps
- Complex but most automated

**Setup:**

Add build steps before running tests:

**For iOS:**
```yaml
- name: Build iOS app
  run: |
    cd /path/to/ios/project
    xcodebuild -project YourApp.xcodeproj \
      -scheme YourApp \
      -configuration Debug \
      -sdk iphonesimulator \
      -derivedDataPath ./build
    
    mkdir -p apps/ios
    cp -R build/Build/Products/Debug-iphonesimulator/YourApp.app apps/ios/
```

**For Android:**
```yaml
- name: Build Android app
  run: |
    cd /path/to/android/project
    ./gradlew assembleDebug
    
    mkdir -p apps/android
    cp app/build/outputs/apk/debug/app-debug.apk apps/android/
```

**Pros:**
- ✅ Always tests latest build
- ✅ No manual app management
- ✅ Catches build + test issues

**Cons:**
- ❌ Requires app source code in repo
- ❌ Slower CI runs (build time added)
- ❌ More complex setup

---

### **Option 5: External Storage (S3, GCS, etc.)**

**When to use:**
- Enterprise setup
- Apps stored in artifact repository
- Already using cloud storage

**Setup:**

Add download steps to workflow:

```yaml
- name: Download apps from S3
  run: |
    mkdir -p apps/ios apps/android
    
    # Download from S3 (requires AWS CLI and credentials)
    aws s3 cp s3://your-bucket/apps/UICatalog.app.zip apps/ios/
    aws s3 cp s3://your-bucket/apps/ApiDemos.apk apps/android/
    
    # Unzip iOS app
    cd apps/ios && unzip UICatalog.app.zip && rm UICatalog.app.zip
  env:
    AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
    AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
```

**Pros:**
- ✅ Unlimited storage
- ✅ Fast downloads (CDN)
- ✅ Fine-grained access control
- ✅ Fits enterprise workflows

**Cons:**
- ❌ Most complex setup
- ❌ Requires cloud storage account
- ❌ Need to manage credentials
- ❌ External dependency

---

## Quick Decision Guide

```
App Size < 100MB?
├─ YES → Use Option 1 (Commit to git) ✅ DEFAULT
└─ NO ↓

    Have GitHub Team/Enterprise?
    ├─ YES → Use Option 2 (Git LFS) ✅ RECOMMENDED
    └─ NO ↓
    
        Have app source code in repo?
        ├─ YES → Use Option 4 (Build in CI)
        └─ NO ↓
        
            App changes frequently?
            ├─ YES → Use Option 5 (External Storage)
            └─ NO → Use Option 3 (GitHub Releases) ✅ RECOMMENDED
```

## Recommendations by Use Case

### Small Projects / Demos
→ **Option 1: Commit to git** (already configured)

### Medium Projects
→ **Option 2: Git LFS** (best balance)

### Large Projects / Enterprise
→ **Option 3: GitHub Releases** (free) or **Option 5: Cloud Storage** (scalable)

### Active Development
→ **Option 4: Build in CI** (always current)

---

## Current Status

✅ **Your project is configured for Option 1** (commit to git)

- Apps are tracked in git (not excluded in `.gitignore`)
- Workflows will find and install them automatically
- This works great for apps < 100MB

**To switch to a different option:**
1. Follow the setup instructions for that option
2. Update `.gitignore` as needed
3. Update or replace workflow files

---

## Troubleshooting

### Apps not found in GitHub Actions

**Symptoms:**
```
⚠️ No .app files found in apps/ios/
```

**Solutions:**
1. Check if apps are in `.gitignore` (should be commented out)
2. Verify apps were committed: `git ls-files apps/`
3. Check file size: `ls -lh apps/ios/*.app`
4. If over 100MB, use Git LFS or Releases

### GitHub rejects large files

**Symptoms:**
```
remote: error: File is XX MB; this exceeds GitHub's file size limit of 100 MB
```

**Solutions:**
1. Use Git LFS (Option 2)
2. Use GitHub Releases (Option 3)
3. Build in CI (Option 4)

### Git LFS quota exceeded

**Symptoms:**
```
Error: Exceeded LFS bandwidth quota
```

**Solutions:**
1. Upgrade GitHub plan for more LFS quota
2. Switch to GitHub Releases (Option 3)
3. Use external storage (Option 5)

---

## Need Help?

- Check `apps/HOW_TO_ADD_APPS.md` for getting app files
- See `.github/workflows/maestro-tests-with-releases.yml.example` for release-based workflow
- Review GitHub's docs on [LFS](https://docs.github.com/repositories/working-with-files/managing-large-files)

