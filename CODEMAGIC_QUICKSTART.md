# Codemagic Quick Start Guide

This guide helps you get started with basic builds on Codemagic without configuring signing certificates.

## Current Configuration

The `codemagic.yaml` has been simplified to:
- Build iOS app without code signing
- Build Android app with debug signing
- Email notifications only (no app store uploads)

## To Enable Full Release Builds

### 1. iOS Release Setup
1. In Codemagic, go to your app settings
2. Create variable group `ios_signing`:
   - Upload your iOS certificates and provisioning profiles
3. Create variable group `app_store_credentials`:
   - `APP_STORE_CONNECT_PRIVATE_KEY`: Your App Store Connect API key
   - `APP_STORE_CONNECT_KEY_IDENTIFIER`: API key ID
   - `APP_STORE_CONNECT_ISSUER_ID`: Issuer ID

### 2. Android Release Setup
1. Generate a release keystore:
   ```bash
   keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```
2. Create variable group `android_signing`:
   - `ANDROID_KEYSTORE`: Base64 encoded keystore
   - `ANDROID_KEYSTORE_PASSWORD`: Keystore password
   - `ANDROID_KEY_PASSWORD`: Key password
   - `ANDROID_KEY_ALIAS`: Key alias (usually "upload")
3. Create variable group `google_play_credentials`:
   - `GCLOUD_SERVICE_ACCOUNT_CREDENTIALS`: Google Play service account JSON

### 3. Update codemagic.yaml
Once you have the variable groups configured, update the codemagic.yaml to include:
- The `groups:` sections that were removed
- The publishing sections for App Store Connect and Google Play

## Current Build Triggers
- iOS: Push tags matching `ios-*`
- Android: Push tags matching `android-*`

## Build Artifacts
Even without signing, builds will produce:
- iOS: `.app` files (can be tested on simulator)
- Android: `.aab` files (can be converted to APK for testing)