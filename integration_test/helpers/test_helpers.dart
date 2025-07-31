import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:urjaview_mobile/main.dart';
import 'package:urjaview_mobile/data/services/api_service.dart';
import 'package:urjaview_mobile/data/repositories/auth_repository.dart';
import 'package:urjaview_mobile/data/repositories/meter_repository.dart';
import 'package:urjaview_mobile/presentation/auth/providers/auth_provider.dart';
import 'package:urjaview_mobile/presentation/meters/providers/meter_provider.dart';
import 'package:urjaview_mobile/data/services/preferences_service.dart';

/// Common test helper functions
class TestHelpers {
  /// Pump and settle with timeout
  static Future<void> pumpAndSettleWithTimeout(
    WidgetTester tester, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    await tester.pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      timeout,
    );
  }

  /// Wait for a specific duration
  static Future<void> wait(Duration duration) async {
    await Future.delayed(duration);
  }

  /// Find widget by key and ensure it's visible
  static Future<void> ensureVisible(WidgetTester tester, Key key) async {
    final finder = find.byKey(key);
    await tester.ensureVisible(finder);
  }

  /// Clear app data (preferences)
  static Future<void> clearAppData() async {
    final prefs = await PreferencesService.getInstance();
    // Reset to defaults
    await prefs.setFirstTime(true);
    await prefs.setOnboardingCompleted(false);
  }

  /// Set first time user
  static Future<void> setFirstTimeUser(bool isFirstTime) async {
    final prefs = await PreferencesService.getInstance();
    await prefs.setFirstTime(isFirstTime);
    await prefs.setOnboardingCompleted(!isFirstTime);
  }

  /// Create test app with providers
  static Widget createTestApp({
    ApiService? apiService,
    AuthRepository? authRepository,
    MeterRepository? meterRepository,
  }) {
    // Use provided services or create defaults
    final api = apiService ?? ApiService();
    final authRepo = authRepository ?? AuthRepository(api);
    final meterRepo = meterRepository ?? MeterRepository(api);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(authRepo)),
        ChangeNotifierProvider(create: (_) => MeterProvider(meterRepo)),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return const MyApp();
        },
      ),
    );
  }

  /// Verify navigation to route
  static void expectRoute(String expectedRoute) {
    // This would need GoRouter's current location
    // For now, we'll verify by finding widgets unique to each route
  }

  /// Take screenshot for debugging
  static Future<void> takeScreenshot(
    WidgetTester tester,
    String name,
  ) async {
    // This is helpful for debugging failed tests
    // In CI, these could be saved as artifacts
    debugPrint('Screenshot would be taken here: $name');
  }
}

/// Widget matchers
class WidgetMatchers {
  /// Match text containing
  static Finder textContaining(String text) {
    return find.byWidgetPredicate(
      (widget) => widget is Text && 
        widget.data != null && 
        widget.data!.contains(text),
    );
  }

  /// Match button with text
  static Finder buttonWithText(String text) {
    return find.byWidgetPredicate(
      (widget) {
        if (widget is ElevatedButton) {
          final child = widget.child;
          return child is Text && child.data == text;
        } else if (widget is TextButton) {
          final child = widget.child;
          return child is Text && child.data == text;
        } else if (widget is OutlinedButton) {
          final child = widget.child;
          return child is Text && child.data == text;
        }
        return false;
      },
    );
  }

  /// Match text field with label
  static Finder textFieldWithLabel(String label) {
    return find.byWidgetPredicate(
      (widget) => widget is TextField &&
        widget.decoration != null &&
        widget.decoration!.labelText == label,
    );
  }

  /// Match loading indicator
  static Finder loadingIndicator() {
    return find.byType(CircularProgressIndicator);
  }
}

/// Test data
class TestData {
  static const validEmail = 'test@example.com';
  static const validPassword = 'Test@123456';
  static const invalidEmail = 'invalid-email';
  static const invalidPassword = '123';
  static const wrongPassword = 'WrongPassword123';
}

/// Extension to add 'or' method to Finder
extension FinderExtension on Finder {
  Finder or(Finder other) {
    return find.byWidgetPredicate(
      (widget) => 
        evaluate().any((element) => element.widget == widget) ||
        other.evaluate().any((element) => element.widget == widget),
    );
  }
}