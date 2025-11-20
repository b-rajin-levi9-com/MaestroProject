#!/bin/bash

# Quick Push to GitHub Script
# Run this after creating your repository on GitHub

set -e

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🚀 Pushing Maestro Project to GitHub"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Get GitHub username
read -p "Enter your GitHub username: " GITHUB_USERNAME

# Get repository name (default: maestro)
read -p "Enter repository name [maestro]: " REPO_NAME
REPO_NAME=${REPO_NAME:-maestro}

# Choose HTTPS or SSH
read -p "Use SSH (recommended) or HTTPS? [ssh/https]: " PROTOCOL
PROTOCOL=${PROTOCOL:-ssh}

echo ""
echo "📝 Configuration:"
echo "   Username: $GITHUB_USERNAME"
echo "   Repository: $REPO_NAME"
echo "   Protocol: $PROTOCOL"
echo ""
read -p "Is this correct? [y/N]: " CONFIRM

if [[ ! $CONFIRM =~ ^[Yy]$ ]]; then
    echo "❌ Cancelled"
    exit 1
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 1: Adding remote repository..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ "$PROTOCOL" = "ssh" ]; then
    REMOTE_URL="git@github.com:${GITHUB_USERNAME}/${REPO_NAME}.git"
else
    REMOTE_URL="https://github.com/${GITHUB_USERNAME}/${REPO_NAME}.git"
fi

git remote add origin "$REMOTE_URL"
echo "✅ Remote added: $REMOTE_URL"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 2: Staging all files..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

git add .
echo "✅ All files staged"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 3: Creating initial commit..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

git commit -m "Initial commit: Maestro test automation with CI/CD

- iOS and Android test flows
- GitHub Actions workflows
- Test apps included
- Organized project structure
- Complete documentation"

echo "✅ Initial commit created"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 4: Renaming branch to 'main'..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

git branch -M main
echo "✅ Branch renamed: master → main"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 5: Pushing to GitHub..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "This may take 1-2 minutes (uploading apps)..."

git push -u origin main

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ SUCCESS! Your project is now on GitHub!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🎉 Next steps:"
echo "   1. Go to: https://github.com/${GITHUB_USERNAME}/${REPO_NAME}"
echo "   2. Click 'Actions' tab to see tests running"
echo "   3. Update README badge with your username"
echo ""
echo "📊 GitHub Actions will automatically:"
echo "   • Install your apps"
echo "   • Run iOS tests (~20-25 min)"
echo "   • Run Android tests (~15-20 min)"
echo "   • Generate test reports"
echo ""

