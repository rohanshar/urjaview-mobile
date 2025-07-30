# iOS Release Commands

The iOS release has been prepared and tagged locally. To trigger the iOS build on Codemagic, run these commands:

## 1. Push the commits to main branch
```bash
git push origin main
```

## 2. Push the iOS release tag
```bash
git push origin ios-1.0.0
```

This will trigger the Codemagic iOS workflow which will:
1. Build the iOS app
2. Sign it with your provisioning profiles
3. Create an IPA file
4. Upload to TestFlight
5. Send email notification to team@indotechworks.com

## Monitoring the Build

1. Go to https://codemagic.io/apps
2. Find your app in the dashboard
3. You should see a new build triggered by the `ios-1.0.0` tag
4. Monitor the build progress and logs

## Next Steps

After the build succeeds:
1. Check TestFlight for the new build
2. Test the app on iOS devices
3. Submit for App Store review when ready

## Creating Future iOS Releases

For future releases, increment the version number:
```bash
# Update version in pubspec.yaml first (e.g., 1.0.1+2)
git add pubspec.yaml
git commit -m "chore: bump version to 1.0.1"
git tag -a ios-1.0.1 -m "iOS Release v1.0.1 - Bug fixes"
git push origin main
git push origin ios-1.0.1
```