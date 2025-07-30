# Codemagic Build Monitoring Tools

This directory contains scripts to monitor and manage Codemagic CI/CD builds for the UrjaView mobile app.

## Available Tools

### 1. `monitor_builds.sh` - Basic Shell Script
A simple bash script for basic build operations and monitoring.

### 2. `codemagic_monitor.py` - Advanced Python Monitor
A feature-rich Python script with real-time monitoring and rich terminal UI.

## Setup

### 1. Install Codemagic CLI Tools
```bash
pipx install codemagic-cli-tools
```

### 2. Configure API Credentials
Run the setup command to configure your credentials:
```bash
./scripts/monitor_builds.sh setup
```

You'll need:
- **App ID**: Found in your Codemagic app URL: `https://codemagic.io/app/{APP_ID}`
- **API Token**: Get from: Teams > Personal Account > Integrations > Codemagic API > Show
  - Or navigate to https://codemagic.io/teams and find your token under Integrations
  - Note: This token is constant and doesn't change

### 3. Source Environment Variables
```bash
source .env.local
```

Or add to your shell profile:
```bash
echo 'source /path/to/project/.env.local' >> ~/.zshrc
```

## Using monitor_builds.sh

### List Recent Builds
```bash
./scripts/monitor_builds.sh list
```

### Check Build Status
```bash
./scripts/monitor_builds.sh status <BUILD_ID>
```

### Download Build Logs
```bash
./scripts/monitor_builds.sh logs <BUILD_ID>
```

### List Build Artifacts
```bash
./scripts/monitor_builds.sh artifacts <BUILD_ID>
```

### Download Build Artifacts
```bash
./scripts/monitor_builds.sh download <BUILD_ID>
```

### Trigger New Builds
```bash
# Trigger iOS build with auto-incremented version
./scripts/monitor_builds.sh trigger-ios

# Trigger Android build with auto-incremented version
./scripts/monitor_builds.sh trigger-android
```

## Using codemagic_monitor.py

### List Recent Builds with Rich UI
```bash
./scripts/codemagic_monitor.py list
./scripts/codemagic_monitor.py list -n 20  # Show 20 builds
```

### Monitor Build in Real-Time
```bash
./scripts/codemagic_monitor.py monitor <BUILD_ID>
```
This shows live updates of build status with a rich terminal UI.

### Watch for New Builds
```bash
./scripts/codemagic_monitor.py watch
./scripts/codemagic_monitor.py watch -i 60  # Check every 60 seconds
```
This continuously monitors for new builds and alerts when detected.

### Get Detailed Build Information
```bash
./scripts/codemagic_monitor.py details <BUILD_ID>
```

## Example Workflows

### 1. Release iOS Version
```bash
# Check recent builds
./scripts/monitor_builds.sh list

# Trigger new iOS build
./scripts/monitor_builds.sh trigger-ios

# Monitor the build in real-time
./scripts/codemagic_monitor.py watch
```

### 2. Debug Failed Build
```bash
# Get build status
./scripts/monitor_builds.sh status <BUILD_ID>

# Download logs
./scripts/monitor_builds.sh logs <BUILD_ID>

# View logs
less build-<BUILD_ID>-logs.txt
```

### 3. Download Release Artifacts
```bash
# List available artifacts
./scripts/monitor_builds.sh artifacts <BUILD_ID>

# Download all artifacts
./scripts/monitor_builds.sh download <BUILD_ID>

# Artifacts will be in artifacts-<BUILD_ID>/ directory
```

## Using Codemagic CLI Tools Directly

### App Store Connect Operations
```bash
# List iOS builds
app-store-connect list-builds

# Upload to TestFlight
app-store-connect publish \
  --path /path/to/app.ipa \
  --key-id $APP_STORE_KEY_ID \
  --issuer-id $APP_STORE_ISSUER_ID \
  --private-key $APP_STORE_PRIVATE_KEY
```

### Google Play Operations
```bash
# List Android tracks
google-play list-tracks

# Upload to internal track
google-play publish \
  --path /path/to/app.aab \
  --track internal \
  --credentials $GCLOUD_SERVICE_ACCOUNT_CREDENTIALS
```

### Keychain Operations (macOS)
```bash
# Initialize keychain
keychain initialize

# Add certificates
keychain add-certificate --certificate /path/to/cert.p12
```

## Environment Variables

Create a `.env.local` file with:
```bash
# Codemagic API
CODEMAGIC_APP_ID=your_app_id
CODEMAGIC_API_TOKEN=your_api_token

# Optional: App Store Connect
APP_STORE_KEY_ID=your_key_id
APP_STORE_ISSUER_ID=your_issuer_id
APP_STORE_PRIVATE_KEY_PATH=/path/to/AuthKey.p8

# Optional: Google Play
GCLOUD_SERVICE_ACCOUNT_CREDENTIALS=/path/to/service-account.json
```

## Troubleshooting

### API Token Issues
- Ensure token has proper permissions
- Check token hasn't expired
- Verify team access

### Build Not Found
- Verify build ID is correct
- Check if build is from the correct app
- Ensure you have access to the build

### Connection Errors
- Check internet connectivity
- Verify Codemagic API is accessible
- Check firewall/proxy settings

## Advanced Usage

### Custom Scripts with API
```python
import os
import requests

# Use the monitor class
from codemagic_monitor import CodemagicMonitor

monitor = CodemagicMonitor()
builds = monitor.get_builds(limit=5)

for build in builds:
    print(f"{build['status']}: {build['id']}")
```

### Webhook Integration
Set up webhooks in Codemagic to notify external services:
1. Go to App Settings → Webhooks
2. Add webhook URL
3. Select events to trigger

### Slack Notifications
Configure Slack integration in Codemagic:
1. Go to Team Settings → Integrations
2. Add Slack workspace
3. Configure notification preferences

## Best Practices

1. **Version Tags**: Use semantic versioning for tags
   - iOS: `ios-1.0.0`, `ios-1.0.1`
   - Android: `android-1.0.0`, `android-1.0.1`

2. **Build Monitoring**: Use `watch` mode during releases

3. **Artifact Management**: Download and archive important builds

4. **Log Analysis**: Keep logs for failed builds for debugging

5. **Security**: Never commit API tokens to git

## Support

For issues with:
- Scripts: Contact the development team
- Codemagic: support@codemagic.io
- API: https://docs.codemagic.io/rest-api/