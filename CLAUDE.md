# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Urja View Mobile is a Flutter-based mobile application for managing DLMS smart meters. It connects to the DLMS Cloud backend API and provides features for meter management, real-time data monitoring, and job scheduling.

## Dependencies & Environment

- Flutter SDK: ^3.7.0
- Dart SDK: Compatible with Flutter version
- Key packages:
  - `dio: ^5.4.0` - HTTP client with interceptors
  - `provider: ^6.1.1` - State management
  - `go_router: ^13.0.1` - Navigation with deep linking
  - `flutter_secure_storage: ^9.0.0` - Secure token storage
  - `jwt_decoder: ^2.0.1` - JWT token handling
  - `intl: any` - Internationalization and date formatting
  - `flutter_svg: ^2.0.9` - SVG rendering
  - `loading_animation_widget: ^1.2.0+4` - Loading indicators
  - `shared_preferences: ^2.2.2` - Local storage for app preferences
  - `flutter_localizations: sdk: flutter` - Localization support

## Dev Dependencies
- `flutter_lints: ^5.0.0` - Linting rules
- `golden_toolkit: ^0.15.0` - Screenshot testing
- `integration_test: sdk: flutter` - Integration testing
- `mockito: ^5.4.4` - Mocking for tests
- `build_runner: ^2.4.9` - Code generation

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

# Debug specific meter operations
flutter run --dart-define=DEBUG_METER_OPS=true
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

# Run screenshot tests (golden tests)
flutter test test/screenshots/

# Update golden files
flutter test --update-goldens test/screenshots/
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

# Run pre-push checks to catch compile-time errors
./scripts/pre_push_check.sh

# Install git hooks (recommended for new developers)
./scripts/install-hooks.sh
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

# Generate screenshots for app stores
./scripts/generate_screenshots.sh
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
  - `services/token_manager.dart`: Automatic token refresh management
  - `services/preferences_service.dart`: Local preferences storage

### Presentation Layer
- **lib/presentation/**: UI screens and state management
  - Uses Provider for state management
  - Each feature module has its own directory (auth, meters, onboarding, etc.)
  - Each module contains: screens/, providers/, widgets/

### Onboarding Module
- **lib/presentation/onboarding/**: First-time user experience
  - `screens/splash_screen.dart`: Animated splash screen
  - `screens/onboarding_screen.dart`: Multi-page onboarding flow
  - `models/onboarding_page_model.dart`: Data model for onboarding pages
  - `widgets/`: Reusable onboarding components

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
- `meter_instant_screen.dart` - Instant values display

Live sub-tabs structure:
- General (`meter_live_general_screen.dart`) - Basic meter info
- Objects (`meter_live_objects_screen.dart`) - OBIS object discovery
- Instant (`meter_live_instant_screen.dart`) - Real-time electrical values
- Events (`meter_live_events_screen.dart`) - Event logs
- Load Survey (`meter_live_load_survey_screen.dart`) - Load profile data
- Billing (`meter_live_billing_screen.dart`) - Billing information

## State Management

The app uses Provider for state management with the following key providers:
- **AuthProvider**: Manages authentication state, token refresh, and user data
- **MeterProvider**: Handles meter CRUD operations and data fetching

### Provider Pattern Example
```dart
// Creating a new provider
class MyFeatureProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  Future<void> doSomething() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      // Call repository method
      await repository.performAction();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

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
- `POST /meters/:id/read-instant-values` - Read instant electrical values (requires auth)

### API Error Response Format
The backend returns errors in this format:
```json
{
  "error": {
    "message": "Human-readable error message",
    "code": "ERROR_CODE",
    "details": { /* optional additional data */ }
  }
}
```

### Meter ID Format
Meters use IDs in the format: `MTR-{timestamp}-{random}` (e.g., `MTR-1753776501278-ybyo42h9d`). Always use meter IDs from the meters list API response.

### Repository Pattern Example
```dart
// Creating a new repository
class MyFeatureRepository {
  final ApiService _apiService;
  
  MyFeatureRepository(this._apiService);
  
  Future<MyModel> fetchData(String id) async {
    try {
      final response = await _apiService.get('/endpoint/$id');
      return MyModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  Exception _handleError(dynamic error) {
    if (error is DioException) {
      // Handle specific error cases
      final errorData = error.response?.data;
      if (errorData != null && errorData['error'] != null) {
        return Exception(errorData['error']['message']);
      }
    }
    return Exception('An unexpected error occurred');
  }
}
```

## Navigation

Uses GoRouter for declarative navigation with:
- Deep linking support
- Authentication guards
- Nested navigation for tabs
- Splash screen with first-time detection

Key routes:
- `/`: Splash screen (initial route)
- `/onboarding`: Onboarding flow for first-time users
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

### Git Hooks
The project includes git hooks for code quality:
- **Pre-commit**: Runs flutter analyze and format checks
- **Pre-push**: Catches compile-time errors that analyze might miss

Install hooks with: `./scripts/install-hooks.sh`

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
- TokenManager handles refresh 5 minutes before expiry

### First-Time User Flow
- Splash screen checks if user is first-time
- Onboarding screens for new users
- Preferences saved using SharedPreferences
- Skip option available during onboarding

## Testing Approach

- Widget tests for UI components
- Unit tests for providers and repositories
- Integration tests for critical flows
- Use the existing test structure in `test/`
- Golden tests for screenshot testing

### Unit & Widget Testing
```bash
# Run all unit and widget tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run with coverage
flutter test --coverage
```

### Integration Testing
```bash
# Run all integration tests
flutter test integration_test/
# Or use the helper script
./scripts/run_integration_tests.sh

# Run specific integration test
flutter test integration_test/splash_screen_test.dart
flutter test integration_test/login_screen_test.dart

# Run with driver (for CI/CD)
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/splash_screen_test.dart

# Available integration tests:
# - Splash screen navigation flow (logo display, first-time/returning user routing)
# - Login screen validation (email/password validation, form submission)
# - See integration_test/README.md for full test coverage details
```

### Screenshot Testing
```bash
# Run screenshot tests
flutter test test/screenshots/

# Update golden files when UI changes
flutter test --update-goldens test/screenshots/

# Generate app store screenshots
./scripts/generate_screenshots.sh
```

## Test Credentials

For development and testing:
- **Email**: `test@example.com`
- **Password**: `Test@123456`
- **Backend**: Points to dev environment at `https://o4yw7npcx6.execute-api.ap-south-1.amazonaws.com/dev`

## Code Quality Tools

### Pre-commit Analysis Script
The project includes a comprehensive pre-commit analysis script at `scripts/pre_commit_analysis.sh` that checks:
1. Flutter analyze for static analysis errors
2. Code formatting compliance
3. Test execution
4. TODO/FIXME comments tracking
5. Print statements (suggests using debugPrint instead)
6. Ensures pubspec.lock is tracked in git

### Pre-push Check Script
Use `scripts/pre_push_check.sh` to catch compile-time type errors that flutter analyze might miss.

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
- App display name: "Urja View" (configured in Info.plist)
- Supports iPhone and iPad orientations

### Android Build Requirements
- Kotlin-based project structure
- Gradle with Kotlin DSL (`build.gradle.kts`)
- Minimum SDK version: Uses Flutter default (flutter.minSdkVersion)
- Target SDK version: Uses Flutter default (flutter.targetSdkVersion)
- Uses AndroidX libraries
- Java compatibility: VERSION_11
- Package name: `com.indotech.urjaview`
- ProGuard rules in `android/app/proguard-rules.pro`

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

### Build Monitoring
- `scripts/monitor_builds.sh` - Monitor Codemagic build status
- `scripts/watch_build.sh` - Watch specific build progress
- `scripts/codemagic_monitor.py` - Python script for detailed monitoring

### Flutter Deployment Engineer
For automated deployments, use the flutter-deployment-engineer agent which handles:
- Pre-deployment validation (flutter analyze, formatting checks)
- Git tagging and version management
- Codemagic build triggering and monitoring
- Error resolution and retry logic
- Complete deployment lifecycle management

## Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| Build fails after flutter pub get | Run `flutter clean` then `flutter pub get` |
| API connection errors | Verify API URL in `app_constants.dart` |
| Token expiry issues | Check token refresh logic in `auth_provider.dart` and TokenManager |
| Navigation not working | Ensure route is defined in `app_router.dart` |
| iOS build fails | Run `cd ios && pod install` |
| Android Gradle sync issues | Check `android/local.properties` for SDK path |
| Meter API returns 401/403 errors | Ensure user is logged in and token is not expired. All meter endpoints require authentication |
| Wrong meter ID format | Use meter IDs from the meters list API, not hardcoded test IDs |
| Session expired errors | Check debug logs for "No token available" messages, ensure TokenManager has valid token |
| Release build crashes | Check ProGuard rules, ensure all models are kept |
| Codemagic iOS build fails | Verify provisioning profile exists, App ID is registered, and integration name is correct |
| Flutter analyze passes but iOS build fails | Run `./scripts/pre_push_check.sh` to catch compile-time type errors |
| First-time user flow issues | Check SharedPreferences keys in `preferences_service.dart` |
| Onboarding not showing | Clear app data to reset first-time flag |
| Git hooks not running | Install hooks with `./scripts/install-hooks.sh` |
| Screenshot tests failing | Update golden files with `flutter test --update-goldens` |

## Assets & Resources

### Images
- Located in `assets/images/`
- Includes:
  - `indotech-logo.svg` - Company logo
  - `urjaview-logo.svg` - App logo
  - `onboarding_1.svg` to `onboarding_4.svg` - Onboarding illustrations (placeholders)
- SVG files are rendered using `flutter_svg` package

### Fonts
- Uses system fonts (San Francisco on iOS, Roboto on Android)
- No custom fonts bundled with the app

## Development Tools

### Quick Development Script
A helper script `run_app.sh` is available for quick development:
```bash
./run_app.sh  # Checks devices, gets dependencies, and runs the app
```

This script:
1. Navigates to the project directory
2. Checks for connected devices (`flutter devices`)
3. Gets dependencies (`flutter pub get`)
4. Runs the app (`flutter run`)

### Build Monitoring Scripts
- `scripts/monitor_builds.sh` - Monitor Codemagic build status
- `scripts/watch_build.sh` - Watch specific build progress
- `scripts/codemagic_monitor.py` - Python script for detailed monitoring

### Project Files
- `pubspec.yaml` - Flutter project configuration and dependencies
- `analysis_options.yaml` - Dart analyzer configuration
- `devtools_options.yaml` - Flutter DevTools settings
- `.flutter-plugins` - Auto-generated plugin registry
- `.flutter-plugins-dependencies` - Auto-generated plugin dependencies
- `codemagic.yaml` - CI/CD configuration

## Debugging Tips

### Common Debug Commands
```bash
# View device logs
flutter logs

# Clear app data (Android)
adb shell pm clear com.indotech.urjaview

# Clear app data (iOS Simulator)
xcrun simctl uninstall booted com.indotech.urjaview

# Check for memory leaks
flutter run --profile
# Then use DevTools Memory tab

# Debug network requests
# Set DEBUG_METER_OPS=true in ApiService to log all requests
```

### Debug Flags in Code
- `kDebugMode` - Flutter's debug mode flag
- `AppConstants.isDebugMode` - App-specific debug flag
- Use `debugPrint()` instead of `print()` for debug output

### Performance Debugging
```bash
# Run performance overlay
flutter run --profile --dart-define=SHOW_PERFORMANCE_OVERLAY=true

# Check widget rebuild count
flutter run --profile --track-widget-creation
```