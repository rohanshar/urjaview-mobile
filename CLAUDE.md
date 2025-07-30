# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

UrjaView Mobile is a Flutter-based mobile application for managing DLMS smart meters. It connects to the DLMS Cloud backend API and provides features for meter management, real-time data monitoring, and job scheduling.

## Dependencies & Environment

- Flutter SDK: ^3.7.0
- Dart SDK: Compatible with Flutter version
- Key packages:
  - `dio: ^5.4.0` - HTTP client with interceptors
  - `provider: ^6.1.1` - State management
  - `go_router: ^13.0.1` - Navigation with deep linking
  - `flutter_secure_storage: ^9.0.0` - Secure token storage
  - `jwt_decoder: ^2.0.1` - JWT token handling
  - `intl: ^0.19.0` - Internationalization and date formatting
  - `google_fonts: ^6.2.1` - Typography
  - `flutter_svg: ^2.0.9` - SVG rendering
  - `loading_animation_widget: ^1.2.0+4` - Loading indicators

## Key Commands

### Development
```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Run on specific device
flutter run -d <device_id>

# List available devices
flutter devices

# Quick development script (checks devices, gets dependencies, and runs)
./run_app.sh

# Hot reload (while app is running)
r

# Hot restart (while app is running)
R

# Clean build artifacts
flutter clean

# Quit running app
q
```

### Debugging
```bash
# Run in debug mode (default)
flutter run

# Run in profile mode (optimized but with some debugging)
flutter run --profile

# Run in release mode (fully optimized)
flutter run --release

# Run with verbose logging
flutter run -v

# Attach to running app
flutter attach

# Open DevTools
flutter pub global activate devtools
flutter pub global run devtools
```

### Testing
```bash
# Run all tests
flutter test

# Run a specific test file
flutter test test/widget_test.dart

# Run a single test by name pattern
flutter test --name "test name pattern"

# Run tests with coverage
flutter test --coverage

# Run tests in watch mode
flutter test --reporter expanded

# Run tests with verbose output
flutter test -v

# Run tests with specific seed (for reproducible random values)
flutter test --test-randomize-ordering-seed=12345

# Generate coverage report and view it
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html  # macOS
```

### Linting & Analysis
```bash
# Analyze code for issues
flutter analyze

# Format code
dart format .

# Fix formatting issues
dart format . --fix

# Check formatting without changing files
dart format --set-exit-if-changed --output=none .

# Check for dependency issues
flutter pub deps

# Upgrade dependencies
flutter pub upgrade

# Upgrade dependencies to latest major versions
flutter pub upgrade --major-versions

# Run pre-commit checks (custom script that runs analyze, format check, and tests)
./scripts/pre_commit_analysis.sh
```

### Building
```bash
# Build APK for Android
flutter build apk --release

# Build iOS app
flutter build ios --release

# Build for specific architecture
flutter build apk --split-per-abi

# Build debug APK
flutter build apk --debug

# Build app bundle for Play Store
flutter build appbundle
```

## Architecture

The application follows a clean architecture pattern with clear separation of concerns:

### Core Structure
- **lib/core/**: Shared utilities, constants, themes, and widgets
  - `constants/app_constants.dart`: API configuration and app-wide constants
  - `theme/`: Material 3 theme configuration
  - `utils/app_router.dart`: GoRouter navigation configuration
  - `widgets/`: Reusable UI components

### Data Layer
- **lib/data/**: Data models, repositories, and API services
  - `models/`: Data models (User, Meter, etc.)
  - `repositories/`: Repository pattern implementations
  - `services/api_service.dart`: Dio-based HTTP client with JWT authentication

### Presentation Layer
- **lib/presentation/**: UI screens and state management
  - Uses Provider for state management
  - Each feature module has its own directory (auth, meters, etc.)
  - Each module contains: screens/, providers/, widgets/

### Meter Module Architecture
The meter module is the most complex and follows a scalable pattern documented in `presentation/meters/README_ARCHITECTURE.md`:
- Main detail screen (`meter_detail_screen_v2.dart`) with tab navigation
- Each tab is a separate screen in `screens/tabs/` for lazy loading
- Live tab has sub-tabs in `screens/tabs/live/`
- Navigation state managed by `MeterNavigationController` (ChangeNotifier)
- Tabs: Overview, Data, Live (with 6 sub-tabs), Jobs, Schedules, Settings

Key meter screens:
- `meter_detail_mobile_screen.dart` - Mobile-optimized container
- `meter_detail_screen_v2.dart` - Main tabbed interface
- `meter_live_menu_screen.dart` - Live data navigation menu
- `meter_config_menu_screen.dart` - Configuration menu
- `meter_clock_config_screen.dart` - Clock configuration UI

## State Management

The app uses Provider for state management with the following key providers:
- **AuthProvider**: Manages authentication state, token refresh, and user data
- **MeterProvider**: Handles meter CRUD operations and data fetching

## API Integration

Base URL: `https://o4yw7npcx6.execute-api.ap-south-1.amazonaws.com/dev` (updated in app_constants.dart)

The API service (`lib/data/services/api_service.dart`) includes:
- Automatic JWT token injection via interceptors
- Token refresh on 401 responses with automatic retry
- Request/response logging in debug mode
- Timeout handling (30 seconds default)
- TokenManager for automatic token refresh before expiry
- Enhanced error handling for nested API error responses

### Authentication Requirements
**IMPORTANT**: All meter-specific endpoints require JWT authentication headers. The backend expects Bearer tokens for all meter operations including ping, test connection, and object reading.

Key API endpoints:
- `POST /auth/signin` - User authentication
- `POST /auth/refresh` - Token refresh
- `GET /meters` - List all meters (requires auth)
- `GET /meters/:id` - Get meter details (requires auth)
- `POST /meters/:id/ping` - Ping meter connectivity (requires auth)
- `POST /meters/:id/test-connection` - Test meter connection (requires auth)
- `POST /meters/:id/read-objects` - Read OBIS objects (requires auth)
- `GET /meters/:id/read-clock` - Read meter clock (requires auth)
- `POST /meters/:id/set-clock` - Set meter clock (requires auth)
- `POST /meters/:id/discover-objects` - Discover available OBIS objects (requires auth)

### Meter ID Format
Meters use IDs in the format: `MTR-{timestamp}-{random}` (e.g., `MTR-1753776501278-ybyo42h9d`). Always use meter IDs from the meters list API response.

## Navigation

Uses GoRouter for declarative navigation with:
- Deep linking support
- Authentication guards
- Nested navigation for tabs

Key routes:
- `/login`: Authentication screen
- `/meters`: Meters list
- `/meters/:id`: Meter detail with tabs
- `/meters/:id/realtime`: Real-time meter data
- `/meters/:id/live`: Live data menu
- `/meters/:id/config`: Configuration menu
- `/meters/:id/config/clock`: Clock configuration

## Development Guidelines

### Adding New Features
1. Follow the existing module structure (screens/, providers/, widgets/)
2. Create models in `data/models/`
3. Add repository methods in `data/repositories/`
4. Create providers for state management
5. Use the existing theme and design system

### Working with Tabs
To add a new tab to meter details:
1. Create screen in `presentation/meters/screens/tabs/`
2. Create widget in `presentation/meters/widgets/`
3. Update `meter_detail_screen_v2.dart` TabBar and TabBarView
4. Update navigation controller if needed

### API Calls
All API calls should go through repositories:
1. Define methods in repository classes
2. Use ApiService for HTTP requests
3. Handle errors appropriately
4. Update provider state

## Common Patterns

### Error Handling
- API errors are caught in repositories
- Providers expose error states
- UI shows appropriate error messages

### Loading States
- Providers manage loading flags
- UI shows loading indicators
- Pull-to-refresh on list screens

### Authentication Flow
- JWT tokens stored in secure storage
- Automatic token refresh on expiry
- Redirect to login on authentication failure

## Testing Approach

- Widget tests for UI components
- Unit tests for providers and repositories
- Integration tests for critical flows
- Use the existing test structure in `test/`

## Key Files

### Configuration
- `lib/core/constants/app_constants.dart`: API URLs, timeouts, storage keys
- `lib/core/utils/app_router.dart`: All app routes and navigation guards
- `lib/core/theme/app_theme.dart`: Material 3 theme configuration

### Authentication & API
- `lib/data/services/api_service.dart`: Dio HTTP client with interceptors
- `lib/presentation/auth/providers/auth_provider.dart`: Authentication state
- `lib/data/repositories/auth_repository.dart`: Authentication logic

### Meter Management
- `lib/presentation/meters/screens/meter_detail_screen_v2.dart`: Main meter detail screen
- `lib/presentation/meters/providers/meter_provider.dart`: Meter state management
- `lib/data/repositories/meter_repository.dart`: Meter CRUD operations

## Test Credentials

For development testing:
- Email: `test@example.com`
- Password: `Test@123456`

## Code Quality Tools

### Pre-commit Analysis Script
The project includes a comprehensive pre-commit analysis script at `scripts/pre_commit_analysis.sh` that checks:
1. Flutter analyze for static analysis errors
2. Code formatting compliance
3. Test execution
4. TODO/FIXME comments tracking
5. Print statements (suggests using debugPrint instead)
6. Ensures pubspec.lock is tracked in git

### Linting Configuration
- Uses `flutter_lints: ^5.0.0` package
- Configuration in `analysis_options.yaml`
- Follows Flutter's recommended lint rules

## Platform-Specific Notes

### iOS Build Requirements
- Xcode 15+ required
- Minimum iOS deployment target: 12.0 (set in iOS project)
- CocoaPods must be installed (`sudo gem install cocoapods`)
- Run `cd ios && pod install` after adding new Flutter plugins
- App display name: "Urjaview Mobile" (configured in Info.plist)
- Supports iPhone and iPad orientations

### Android Build Requirements
- Kotlin-based project structure
- Gradle with Kotlin DSL (`build.gradle.kts`)
- Minimum SDK version: Uses Flutter default (flutter.minSdkVersion)
- Target SDK version: Uses Flutter default (flutter.targetSdkVersion)
- Uses AndroidX libraries
- Java compatibility: VERSION_11
- Package name: `com.indotech.urjaview`

## Release & CI/CD

### Bundle Identifiers
- iOS: `com.indotech.urjaview`
- Android: `com.indotech.urjaview`

### CI/CD with Codemagic
The project is configured for automated builds using Codemagic:
- Configuration file: `codemagic.yaml`
- iOS builds triggered by tags: `ios-*` (e.g., `ios-1.0.0`)
- Android builds triggered by tags: `android-*` (e.g., `android-1.0.0`)

#### iOS Build Setup Requirements
1. **App ID Registration**: Register `com.indotech.urjaview` in Apple Developer Portal → Identifiers
2. **Provisioning Profile**: Create "UrjaViewAppStoreProfile" in Apple Developer Portal → Profiles
   - Select App Store distribution type
   - Select the App ID: `com.indotech.urjaview`
   - Select appropriate distribution certificate (check expiry dates)
3. **Codemagic Configuration**:
   - Fetch the provisioning profile in Codemagic UI
   - Integration name must be exact: "AppStoreAPIAccessKey" (case-sensitive)
   - Certificate: "codemagicSigningCertificate"
4. **Xcode Project Settings**:
   - Team ID: B7ZBWF8ZM2 (must match provisioning profile)
   - Bundle ID: `com.indotech.urjaview`
5. **Working Configuration**:
   ```yaml
   integrations:
     app_store_connect: AppStoreAPIAccessKey
   ios_signing:
     provisioning_profiles:
       - profile: "UrjaViewAppStoreProfile"
     certificates:
       - certificate: "codemagicSigningCertificate"
   ```

#### Known Issues & Solutions
- **Webhook auto-trigger not working**: Manual trigger required via Codemagic UI
- **"No matching profiles found" error**: Ensure provisioning profile is created in Apple Developer Portal and fetched in Codemagic
- **Integration not found error**: Integration name is case-sensitive, must be "AppStoreAPIAccessKey"
- **Type errors not caught by flutter analyze**: Use pre-push hooks (`./scripts/pre_push_check.sh`) to catch compile-time errors

### Android Release Signing
- Configured in `android/app/build.gradle.kts`
- Requires `key.properties` file (not tracked in git)
- ProGuard rules in `android/app/proguard-rules.pro`

### iOS Release Signing
- Bundle ID: `com.indotech.urjaview`
- Requires provisioning profiles and certificates
- Configured via Codemagic UI

## Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| Build fails after flutter pub get | Run `flutter clean` then `flutter pub get` |
| API connection errors | Verify API URL in `app_constants.dart` |
| Token expiry issues | Check token refresh logic in `auth_provider.dart` |
| Navigation not working | Ensure route is defined in `app_router.dart` |
| iOS build fails | Run `cd ios && pod install` |
| Android Gradle sync issues | Check `android/local.properties` for SDK path |
| Meter API returns 401/403 errors | Ensure user is logged in and token is not expired. All meter endpoints require authentication |
| Wrong meter ID format | Use meter IDs from the meters list API, not hardcoded test IDs |
| Session expired errors | Check debug logs for "No token available" messages, ensure TokenManager has valid token |
| Release build crashes | Check ProGuard rules, ensure all models are kept |
| Codemagic iOS build fails | Verify provisioning profile exists, App ID is registered, and integration name is correct |
| Flutter analyze passes but iOS build fails | Run `./scripts/pre_push_check.sh` to catch compile-time type errors |

## Assets & Resources

### Images
- Located in `assets/images/`
- Includes:
  - `indotech-logo.svg` - Company logo
  - `urjaview-logo.svg` - App logo
- SVG files are rendered using `flutter_svg` package

### Fonts
- Uses Google Fonts package for dynamic font loading
- No custom fonts bundled with the app

## Development Tools

### Quick Development Script
A helper script `run_app.sh` is available for quick development:
```bash
./run_app.sh  # Checks devices, gets dependencies, and runs the app
```

### Project Files
- `pubspec.yaml` - Flutter project configuration and dependencies
- `analysis_options.yaml` - Dart analyzer configuration
- `devtools_options.yaml` - Flutter DevTools settings
- `.flutter-plugins` - Auto-generated plugin registry
- `.flutter-plugins-dependencies` - Auto-generated plugin dependencies