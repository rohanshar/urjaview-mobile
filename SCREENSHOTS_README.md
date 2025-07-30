# Screenshot Generation Guide

This guide explains how to generate and upload screenshots for the UrjaView app to both App Store Connect and Google Play Store.

## Overview

The app uses golden testing with the `golden_toolkit` package to automatically generate screenshots in multiple device sizes and languages. Screenshots are then organized and uploaded using Fastlane.

## Setup

### Prerequisites

1. Install Fastlane (if not already installed):
   ```bash
   sudo gem install fastlane
   ```

2. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```

## Generating Screenshots

### Local Generation

To generate screenshots locally:

```bash
./scripts/generate_screenshots.sh
```

This will:
1. Run golden tests to generate screenshots
2. Organize screenshots into appropriate Fastlane directories
3. Prepare them for upload to stores

### Screenshot Sizes

The following device sizes are generated:

**iOS:**
- iPhone 8 Plus (5.5") - 1242 x 2208
- iPhone Xs Max (6.5") - 1242 x 2688
- iPad Pro 2nd gen (12.9") - 2048 x 2732
- iPad Pro 6th gen (12.9") - 2048 x 2732

**Android:**
- Phone - 1107 x 1968
- 7" Tablet - 1206 x 2144
- 10" Tablet - 1449 x 2576

### Languages

Screenshots are generated in:
- English (en-US)
- French (fr-FR)

## Uploading Screenshots

### App Store Connect

1. Set up App Store Connect API key:
   ```json
   {
     "key_id": "YOUR_KEY_ID",
     "issuer_id": "YOUR_ISSUER_ID",
     "key": "-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----"
   }
   ```
   Save as `ios/app_store_connect.json`

2. Upload screenshots:
   ```bash
   cd ios
   bundle install
   bundle exec fastlane upload_screenshots
   ```

### Google Play Store

1. Set up Google Play service account:
   - Create service account in Google Cloud Console
   - Download JSON key
   - Save as `android/google-play-store.json`

2. Upload screenshots:
   ```bash
   cd android
   bundle install
   bundle exec fastlane upload_screenshots
   ```

## CI/CD Integration

Screenshots are automatically generated and uploaded during the release process in Codemagic:

1. **iOS releases** (tags: `ios-*`): Screenshots are generated and uploaded to App Store Connect
2. **Android releases** (tags: `android-*`): Screenshots are generated and uploaded to Google Play

### Environment Variables

Set these in Codemagic:
- `APP_STORE_CONNECT_API_KEY`: JSON content for App Store Connect API
- `GCLOUD_SERVICE_ACCOUNT_CREDENTIALS`: JSON content for Google Play service account

## Customizing Screenshots

### Adding New Screens

1. Edit `test/screenshots/generate_screenshots_test.dart`
2. Add new test cases for your screens
3. Update the decoration text and styling as needed

### Changing Device Frames

Edit the `getDecoratedScreen` function in `test/screenshots/screenshot_utils.dart` to customize:
- Background colors
- Text styling
- Device frames
- Shadow effects

### Adding Languages

1. Add locale to the `locales` array in test file
2. Create metadata directories:
   - iOS: `ios/fastlane/metadata/[lang-CODE]/`
   - Android: `android/fastlane/metadata/android/[lang-CODE]/`
3. Add translated metadata files

## Troubleshooting

### Screenshots not generating
- Run `flutter test --update-goldens --tags=screenshots` directly
- Check for test failures
- Ensure all dependencies are installed

### Upload failures
- Verify API credentials are correct
- Check that app exists in stores
- Ensure correct bundle ID is configured

### Screenshot quality issues
- Verify device pixel ratios are correct
- Check that fonts are loading properly
- Ensure mock data looks realistic

## Best Practices

1. **Review screenshots** before uploading to stores
2. **Use realistic data** in mock providers
3. **Test on actual devices** to verify appearance
4. **Keep metadata updated** in Fastlane directories
5. **Version control** screenshot tests for consistency