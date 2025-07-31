import 'package:flutter_test/flutter_test.dart';
import 'package:urjaview_mobile/presentation/auth/screens/login_screen.dart';
import 'package:urjaview_mobile/presentation/onboarding/screens/onboarding_screen.dart';
import 'package:urjaview_mobile/presentation/onboarding/screens/splash_screen.dart';

/// Helper functions for navigation in tests
class NavigationHelpers {
  /// Wait for navigation from splash screen to destination
  static Future<void> waitForSplashNavigation(
    WidgetTester tester, {
    Duration maxWait = const Duration(seconds: 5),
  }) async {
    // Only wait if we're actually on the splash screen
    if (find.byType(SplashScreen).evaluate().isEmpty) {
      return;
    }
    
    // Wait for navigation with flexible timing
    final stopwatch = Stopwatch()..start();
    bool navigated = false;
    
    while (stopwatch.elapsed < maxWait && !navigated) {
      await tester.pump(const Duration(milliseconds: 100));
      
      // Check if we've navigated away from splash
      if (find.byType(SplashScreen).evaluate().isEmpty) {
        navigated = true;
      }
    }
    
    // Give time for the new screen to settle
    await tester.pumpAndSettle();
  }
  
  /// Navigate directly to login screen (skip splash)
  static Future<void> navigateToLogin(WidgetTester tester) async {
    // Check if we're already on the login screen
    if (find.byType(LoginScreen).evaluate().isNotEmpty) {
      return;
    }
    
    // Check if we're on splash screen
    if (find.byType(SplashScreen).evaluate().isNotEmpty) {
      // Wait for navigation from splash
      await waitForSplashNavigation(tester);
    }
    
    // If we're on onboarding, we need to complete or skip it
    if (find.byType(OnboardingScreen).evaluate().isNotEmpty) {
      // Look for skip button
      final skipButton = find.text('Skip');
      if (skipButton.evaluate().isNotEmpty) {
        await tester.tap(skipButton);
        await tester.pumpAndSettle();
      }
    }
    
    // Wait a bit more if we're still not on login
    if (find.byType(LoginScreen).evaluate().isEmpty) {
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();
    }
    
    // Verify we're on login screen
    expect(find.byType(LoginScreen), findsOneWidget);
  }
  
  /// Wait for a specific widget type to appear
  static Future<bool> waitForWidget<T>(
    WidgetTester tester, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    final stopwatch = Stopwatch()..start();
    
    while (stopwatch.elapsed < timeout) {
      await tester.pump(const Duration(milliseconds: 100));
      
      if (find.byType(T).evaluate().isNotEmpty) {
        return true;
      }
    }
    
    return false;
  }
}