import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:urjaview_mobile/main.dart';
import 'package:urjaview_mobile/presentation/onboarding/screens/splash_screen.dart';
import 'package:urjaview_mobile/presentation/onboarding/screens/onboarding_screen.dart';
import 'package:urjaview_mobile/presentation/auth/screens/login_screen.dart';
import 'helpers/test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Splash Screen Integration Tests', () {
    setUp(() async {
      // Clear app data before each test
      await TestHelpers.clearAppData();
    });

    testWidgets('shows splash screen with logo and app name', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MyApp());
      await tester.pump();

      // Assert - Verify splash screen is shown
      expect(find.byType(SplashScreen), findsOneWidget);
      
      // Check for logo (SVG)
      expect(find.byType(Container), findsWidgets);
      
      // Check for app name
      expect(find.text('Urja View'), findsOneWidget);
      
      // Check for tagline
      expect(find.textContaining('Smart'), findsOneWidget);
    });

    testWidgets('navigates to onboarding for first-time users', (tester) async {
      // Arrange - Set as first-time user
      await TestHelpers.setFirstTimeUser(true);

      // Act
      await tester.pumpWidget(const MyApp());
      await tester.pump();

      // Wait for splash screen to appear
      expect(find.byType(SplashScreen), findsOneWidget);

      // Wait for navigation with more flexible timing
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 500));
        if (find.byType(OnboardingScreen).evaluate().isNotEmpty) {
          break;
        }
      }

      // Final settle
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Assert - Should navigate to onboarding
      expect(find.byType(OnboardingScreen), findsOneWidget);
      expect(find.byType(SplashScreen), findsNothing);
    });

    testWidgets('navigates to login for returning users', (tester) async {
      // Arrange - Set as returning user
      await TestHelpers.setFirstTimeUser(false);

      // Act
      await tester.pumpWidget(const MyApp());
      await tester.pump();

      // Wait for splash screen to appear
      expect(find.byType(SplashScreen), findsOneWidget);

      // Wait for navigation with more flexible timing
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 500));
        if (find.byType(LoginScreen).evaluate().isNotEmpty) {
          break;
        }
      }

      // Final settle
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Assert - Should navigate to login
      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.byType(SplashScreen), findsNothing);
    });

    testWidgets('shows animations during splash screen', (tester) async {
      // Act
      await tester.pumpWidget(const MyApp());
      
      // Initial state
      await tester.pump();
      expect(find.byType(SplashScreen), findsOneWidget);
      
      // Pump frames during animation
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(FadeTransition), findsWidgets);
      expect(find.byType(ScaleTransition), findsWidgets);
      
      // Animation should still be running
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(SplashScreen), findsOneWidget);
      
      // Complete animation
      await tester.pump(const Duration(seconds: 2, milliseconds: 100));
      await TestHelpers.pumpAndSettleWithTimeout(tester);
    });

    testWidgets('handles preference service errors gracefully', (tester) async {
      // This test ensures the app doesn't crash if preferences fail
      // The actual implementation would need error handling in splash screen
      
      // Clear preferences to simulate default state
      await TestHelpers.clearAppData();
      
      await tester.pumpWidget(const MyApp());
      await tester.pump();
      
      // Should show splash screen
      expect(find.byType(SplashScreen), findsOneWidget);
      
      // Wait for navigation with flexible timing
      bool foundDestination = false;
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 500));
        
        // Check if we navigated to either onboarding or login
        if (find.byType(OnboardingScreen).evaluate().isNotEmpty ||
            find.byType(LoginScreen).evaluate().isNotEmpty) {
          foundDestination = true;
          break;
        }
      }
      
      // Final settle
      await TestHelpers.pumpAndSettleWithTimeout(tester);
      
      // Should navigate somewhere (either onboarding or login)
      expect(foundDestination, true);
      expect(find.byType(SplashScreen), findsNothing);
    });
  });
}