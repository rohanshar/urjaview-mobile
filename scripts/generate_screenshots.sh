#!/bin/bash

# Script to generate screenshots for App Store and Google Play

echo "🎯 Generating screenshots for App Store and Google Play..."

# Run flutter pub get to ensure dependencies are installed
echo "📦 Installing dependencies..."
flutter pub get

# Generate screenshots using golden tests
echo "📸 Generating screenshots..."
flutter test --update-goldens --tags=screenshots

# Check if screenshots were generated successfully
if [ $? -ne 0 ]; then
    echo "❌ Screenshot generation failed!"
    exit 1
fi

echo "✅ Screenshots generated successfully!"

# Create directories for organizing screenshots
echo "📁 Organizing screenshots..."

# iOS directories
mkdir -p ios/fastlane/screenshots/en-US
mkdir -p ios/fastlane/screenshots/fr-FR

# Android directories
mkdir -p android/fastlane/metadata/android/en-US/images/phoneScreenshots
mkdir -p android/fastlane/metadata/android/en-US/images/sevenInchScreenshots
mkdir -p android/fastlane/metadata/android/en-US/images/tenInchScreenshots
mkdir -p android/fastlane/metadata/android/fr-FR/images/phoneScreenshots
mkdir -p android/fastlane/metadata/android/fr-FR/images/sevenInchScreenshots
mkdir -p android/fastlane/metadata/android/fr-FR/images/tenInchScreenshots

# Copy iOS screenshots
echo "📱 Copying iOS screenshots..."
cp test/screenshots/goldens/en.iphone*.final.png ios/fastlane/screenshots/en-US/ 2>/dev/null || true
cp test/screenshots/goldens/en.ipad*.final.png ios/fastlane/screenshots/en-US/ 2>/dev/null || true
cp test/screenshots/goldens/fr.iphone*.final.png ios/fastlane/screenshots/fr-FR/ 2>/dev/null || true
cp test/screenshots/goldens/fr.ipad*.final.png ios/fastlane/screenshots/fr-FR/ 2>/dev/null || true

# Copy Android screenshots
echo "🤖 Copying Android screenshots..."
cp test/screenshots/goldens/en.android_smartphone.*.final.png android/fastlane/metadata/android/en-US/images/phoneScreenshots/ 2>/dev/null || true
cp test/screenshots/goldens/en.android_tablet_7.*.final.png android/fastlane/metadata/android/en-US/images/sevenInchScreenshots/ 2>/dev/null || true
cp test/screenshots/goldens/en.android_tablet_10.*.final.png android/fastlane/metadata/android/en-US/images/tenInchScreenshots/ 2>/dev/null || true
cp test/screenshots/goldens/fr.android_smartphone.*.final.png android/fastlane/metadata/android/fr-FR/images/phoneScreenshots/ 2>/dev/null || true
cp test/screenshots/goldens/fr.android_tablet_7.*.final.png android/fastlane/metadata/android/fr-FR/images/sevenInchScreenshots/ 2>/dev/null || true
cp test/screenshots/goldens/fr.android_tablet_10.*.final.png android/fastlane/metadata/android/fr-FR/images/tenInchScreenshots/ 2>/dev/null || true

echo "✨ Screenshot generation and organization complete!"
echo ""
echo "📍 Screenshots are organized in:"
echo "   - iOS: ios/fastlane/screenshots/"
echo "   - Android: android/fastlane/metadata/android/"
echo ""
echo "🚀 Ready for upload to App Store and Google Play!"