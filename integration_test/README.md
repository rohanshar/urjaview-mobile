# Integration Tests

This directory contains integration tests for the Urja View mobile application.

## Overview

Integration tests verify that different parts of the app work together correctly. These tests run on real devices or emulators and test complete user flows.

## Structure

```
integration_test/
├── helpers/              # Test utilities and helpers
│   ├── test_helpers.dart    # Common test helper functions
│   └── mock_services.dart   # Mock services for testing
├── splash_screen_test.dart  # Splash screen flow tests
├── login_screen_test.dart   # Login flow tests
└── README.md              # This file
```

## Running Tests

### Prerequisites

1. Ensure you have a device or emulator running:
   ```bash
   flutter devices
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

### Run All Tests

```bash
# Using the helper script
./scripts/run_integration_tests.sh

# Or directly with Flutter
flutter test integration_test/
```

### Run Specific Test

```bash
# Run splash screen tests only
flutter test integration_test/splash_screen_test.dart

# Run login tests only
flutter test integration_test/login_screen_test.dart
```

### Run with Driver (for CI/CD)

```bash
# Run tests with driver for screenshots and reporting
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/splash_screen_test.dart
```

## Test Coverage

### Splash Screen Tests
- ✅ Display of logo and app name
- ✅ Navigation to onboarding for first-time users
- ✅ Navigation to login for returning users
- ✅ Animation verification
- ✅ Error handling for preference service

### Login Screen Tests
- ✅ Display of all UI elements
- ✅ Email validation (empty, invalid format)
- ✅ Password validation (empty, too short)
- ✅ Password visibility toggle
- ✅ Loading state during login
- ✅ Form submission via keyboard
- ✅ Debug reset button functionality

## Writing New Tests

### Test Structure

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'helpers/test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Feature Tests', () {
    setUp(() async {
      // Setup before each test
      await TestHelpers.clearAppData();
    });

    testWidgets('test description', (tester) async {
      // Arrange
      await tester.pumpWidget(const MyApp());
      
      // Act
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      
      // Assert
      expect(find.text('Expected Text'), findsOneWidget);
    });
  });
}
```

### Best Practices

1. **Clear app data** before each test to ensure a clean state
2. **Use helpers** from `test_helpers.dart` for common operations
3. **Wait for animations** using `pumpAndSettle()` or custom timeouts
4. **Test user flows** not implementation details
5. **Use descriptive test names** that explain what is being tested
6. **Group related tests** for better organization

### Common Helpers

```dart
// Wait with timeout
await TestHelpers.pumpAndSettleWithTimeout(tester);

// Set user state
await TestHelpers.setFirstTimeUser(true);

// Clear all app data
await TestHelpers.clearAppData();

// Find widgets
WidgetMatchers.textContaining('text');
WidgetMatchers.buttonWithText('Sign In');
WidgetMatchers.loadingIndicator();
```

## Debugging Failed Tests

1. **Take screenshots** at failure points:
   ```dart
   await TestHelpers.takeScreenshot(tester, 'login_failed');
   ```

2. **Add debug prints**:
   ```dart
   debugPrint('Current route: ${GoRouter.of(context).location}');
   ```

3. **Use verbose mode**:
   ```bash
   flutter test integration_test/login_screen_test.dart -v
   ```

4. **Check element tree**:
   ```dart
   debugDumpApp();
   ```

## CI/CD Integration

These tests can be run in CI/CD pipelines. Add to your workflow:

```yaml
- name: Run integration tests
  run: flutter test integration_test/
```

For device farms or cloud testing:
- Tests are compatible with Firebase Test Lab
- Can be run on AWS Device Farm
- Support screenshot capture for visual verification

## Future Tests

Planned integration tests:
- [ ] Complete authentication flow with API
- [ ] Meter list and filtering
- [ ] Meter detail tabs navigation
- [ ] Real-time data updates
- [ ] Job scheduling flow
- [ ] Settings and preferences
- [ ] Network error handling
- [ ] Token refresh flow

## Troubleshooting

### Test Timeout
If tests timeout, increase the timeout in `pumpAndSettleWithTimeout`:
```dart
await TestHelpers.pumpAndSettleWithTimeout(
  tester,
  timeout: const Duration(seconds: 30),
);
```

### Element Not Found
Use `debugDumpApp()` to see the widget tree and verify the element exists.

### Navigation Issues
Ensure sufficient time for navigation transitions:
```dart
await tester.pump(const Duration(seconds: 3));
await tester.pumpAndSettle();
```