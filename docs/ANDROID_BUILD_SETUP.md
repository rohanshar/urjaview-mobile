# Android Build Setup Guide

This guide explains how to configure Android builds in Codemagic for the Urja View mobile app.

## Current Status

The Android build workflow is configured but requires the following setup in Codemagic:

1. **Google Play Service Account** (for publishing to Play Store)
2. **Android Signing Keystore** (for signing the APK/AAB)

Without these, the build will create unsigned APK/AAB files that cannot be published to Google Play.

## Setup Steps

### 1. Create Google Play Service Account

1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Create a new project or select existing project
3. Enable Google Play Android Developer API
4. Create a service account:
   - Go to IAM & Admin → Service Accounts
   - Click "Create Service Account"
   - Name: `urjaview-play-store-publisher`
   - Grant role: `Service Account User`
5. Create JSON key:
   - Click on the service account
   - Go to Keys tab → Add Key → Create new key
   - Choose JSON format
   - Download the JSON file
6. In Google Play Console:
   - Go to Settings → API access
   - Link the Google Cloud project
   - Grant access to the service account with "Release manager" permissions

### 2. Configure Codemagic Environment Variables

1. Go to [Codemagic](https://codemagic.io/app/6889ea6e98fd14e47f40dd2a/settings)
2. Add environment variable:
   - Name: `GCLOUD_SERVICE_ACCOUNT_CREDENTIALS`
   - Value: Paste the entire JSON content from the service account key file
   - Make sure to mark it as "Secure"

### 3. Create Android Keystore

If you don't have a keystore yet:

```bash
keytool -genkey -v -keystore urjaview-release.keystore \
  -alias urjaview -keyalg RSA -keysize 2048 -validity 10000
```

**IMPORTANT**: Save the keystore password and key password securely!

### 4. Configure Android Signing in Codemagic

1. In Codemagic, go to Environment variables
2. Create an environment group called `androidStoreKey` with:
   - `CM_KEYSTORE`: Base64 encoded keystore file
     ```bash
     base64 -i urjaview-release.keystore | pbcopy
     ```
   - `CM_KEYSTORE_PASSWORD`: Your keystore password
   - `CM_KEY_ALIAS`: `urjaview` (or your alias)
   - `CM_KEY_PASSWORD`: Your key password

### 5. Enable Publishing in codemagic.yaml

Once the above steps are complete, update `codemagic.yaml`:

1. Uncomment the `android_signing` section
2. Uncomment the `publishing` section

## Building Without Publishing

The current configuration will:
- Build the Android App Bundle (.aab file)
- Save it as an artifact in Codemagic
- You can download and manually upload to Google Play

## Troubleshooting

### "Provided Google Play service account credentials could not be used"
- Ensure the JSON is valid (validate at jsonlint.com)
- Check that the entire JSON content is pasted, including `{` and `}`
- Verify the service account has proper permissions in Google Play Console

### "androidStoreKey environment group not found"
- Create the environment group in Codemagic settings
- Ensure all required variables are set (CM_KEYSTORE, etc.)

### Build succeeds but can't install APK
- The APK is unsigned and can only be installed with developer mode enabled
- For testing, use `flutter build apk --debug` locally