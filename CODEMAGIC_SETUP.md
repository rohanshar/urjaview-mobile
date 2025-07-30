# Codemagic CI/CD Setup Guide

This guide explains how to set up Codemagic CI/CD for the UrjaView mobile app.

## Prerequisites

1. A Codemagic account (https://codemagic.io)
2. Access to Apple Developer Account for iOS
3. Access to Google Play Console for Android
4. Repository access on GitHub

## Configuration Files

- `codemagic.yaml` - Main CI/CD configuration file
- `android/app/build.gradle.kts` - Android build configuration
- `ios/Runner.xcodeproj/project.pbxproj` - iOS build configuration

## Environment Variables

### iOS Variables Group: `app_store_credentials`
- `APP_STORE_CONNECT_PRIVATE_KEY` - App Store Connect API private key
- `APP_STORE_CONNECT_KEY_IDENTIFIER` - App Store Connect API key ID
- `APP_STORE_CONNECT_ISSUER_ID` - App Store Connect API issuer ID

### iOS Variables Group: `ios_signing`
- Provisioning profiles and certificates (configured via Codemagic UI)

### Android Variables Group: `google_play_credentials`
- `GCLOUD_SERVICE_ACCOUNT_CREDENTIALS` - Google Play service account JSON

### Android Variables Group: `android_signing`
- `ANDROID_KEYSTORE` - Base64 encoded keystore file
- `ANDROID_KEYSTORE_PASSWORD` - Keystore password
- `ANDROID_KEY_PASSWORD` - Key password
- `ANDROID_KEY_ALIAS` - Key alias

## Setup Steps

### 1. Connect Repository
1. Log in to Codemagic
2. Add new application
3. Select GitHub as the repository provider
4. Choose the `dlms-bcs/dlms-cloud` repository
5. Select the Flutter app type

### 2. Configure iOS Signing
1. Go to Teams → Personal Team → Code signing identities
2. Upload your iOS distribution certificate
3. Upload provisioning profiles for the app
4. Create the `ios_signing` variable group with the certificate references

### 3. Configure Android Signing
1. Generate a keystore for release builds:
   ```bash
   keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```
2. Base64 encode the keystore:
   ```bash
   base64 -i upload-keystore.jks | tr -d '\n' | pbcopy
   ```
3. Add the encoded keystore and passwords to the `android_signing` variable group

### 4. Configure App Store Connect API
1. Go to App Store Connect → Users and Access → Keys
2. Generate a new API key with App Manager role
3. Download the .p8 private key file
4. Add the key details to the `app_store_credentials` variable group

### 5. Configure Google Play API
1. Go to Google Play Console → Setup → API access
2. Create a service account with release management permissions
3. Download the JSON key file
4. Add the JSON content to the `google_play_credentials` variable group

### 6. Set Up Triggers
The configuration uses tag-based triggers:
- iOS builds: Create tags with pattern `ios-*` (e.g., `ios-1.0.0`)
- Android builds: Create tags with pattern `android-*` (e.g., `android-1.0.0`)

Example:
```bash
# Trigger iOS build
git tag ios-1.0.0
git push origin ios-1.0.0

# Trigger Android build
git tag android-1.0.0
git push origin android-1.0.0
```

## Build Workflow

### iOS Workflow (`ios-workflow`)
1. Installs dependencies (`flutter pub get`, `pod install`)
2. Runs Flutter analyze
3. Builds iOS release
4. Signs the app with provisioning profiles
5. Creates IPA file
6. Uploads to TestFlight
7. Sends email notification

### Android Workflow (`android-workflow`)
1. Sets up signing configuration
2. Installs dependencies
3. Runs Flutter analyze
4. Builds app bundle with auto-incremented build number
5. Uploads to Google Play internal track
6. Sends email notification

## Local Testing

Before pushing to Codemagic, test builds locally:

### iOS
```bash
flutter build ios --release
```

### Android
```bash
# Create key.properties file for local signing
echo "storePassword=YOUR_PASSWORD
keyPassword=YOUR_PASSWORD
keyAlias=upload
storeFile=/path/to/upload-keystore.jks" > android/key.properties

flutter build appbundle --release
```

## Monitoring Builds

1. View build status at https://codemagic.io/apps
2. Check email notifications for build results
3. Monitor TestFlight for iOS builds
4. Check Google Play Console for Android builds

## Troubleshooting

### iOS Build Failures
- Verify provisioning profiles match the bundle ID
- Check certificate expiration dates
- Ensure Xcode version compatibility

### Android Build Failures
- Verify keystore configuration
- Check ProGuard rules if minification fails
- Ensure Google Play API permissions

### General Issues
- Check Flutter version compatibility
- Verify all dependencies are resolved
- Review build logs for specific errors

## Support

For Codemagic-specific issues:
- Documentation: https://docs.codemagic.io
- Support: support@codemagic.io

For app-specific issues:
- Contact: team@indotechworks.com