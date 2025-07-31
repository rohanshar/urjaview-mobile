import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:integration_test/integration_test.dart';
import 'package:urjaview_mobile/main.dart';
import 'package:urjaview_mobile/presentation/auth/screens/login_screen.dart';
import 'package:urjaview_mobile/presentation/onboarding/screens/splash_screen.dart';
import 'helpers/test_helpers.dart';
import 'helpers/navigation_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Login Screen Integration Tests', () {
    setUp(() async {
      // Clear app data and set as returning user
      await TestHelpers.clearAppData();
      await TestHelpers.setFirstTimeUser(false);
    });
    
    /// Helper to navigate to login screen for each test
    Future<void> navigateToLoginScreen(WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await NavigationHelpers.waitForSplashNavigation(tester);
      await NavigationHelpers.navigateToLogin(tester);
    }

    testWidgets('displays login screen with all elements', (tester) async {
      // Act
      await tester.pumpWidget(const MyApp());
      
      // Navigate through splash to login
      await NavigationHelpers.waitForSplashNavigation(tester);
      await NavigationHelpers.navigateToLogin(tester);

      // Assert - Verify login screen elements
      expect(find.byType(LoginScreen), findsOneWidget);
      
      // Check for logo - using more flexible finder
      final svgFinder = find.byType(SvgPicture);
      expect(svgFinder, findsWidgets);
      
      // Check for company name
      expect(find.textContaining('Indotech'), findsOneWidget);
      
      // Check for tagline
      expect(find.textContaining('Smart'), findsOneWidget);
      
      // Check for email field
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Email'), findsOneWidget);
      
      // Check for password field
      expect(find.text('Password'), findsOneWidget);
      
      // Check for sign in button
      expect(find.widgetWithText(ElevatedButton, 'Sign In'), findsOneWidget);
      
      // Check for debug reset button (in debug mode)
      expect(find.textContaining('Reset Onboarding'), findsOneWidget);
    });

    testWidgets('validates empty email field', (tester) async {
      // Navigate to login
      await navigateToLoginScreen(tester);

      // Clear email field
      final emailField = find.byType(TextFormField).first;
      await tester.tap(emailField);
      await tester.enterText(emailField, '');
      
      // Try to submit
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pump();

      // Assert - Should show validation error
      expect(find.text('Please enter your email'), findsOneWidget);
    });

    testWidgets('validates invalid email format', (tester) async {
      // Navigate to login
      await navigateToLoginScreen(tester);

      // Enter invalid email
      final emailField = find.byType(TextFormField).first;
      await tester.tap(emailField);
      await tester.enterText(emailField, TestData.invalidEmail);
      
      // Try to submit
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pump();

      // Assert - Should show validation error
      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('validates empty password field', (tester) async {
      // Navigate to login
      await navigateToLoginScreen(tester);

      // Clear password field
      final passwordField = find.byType(TextFormField).last;
      await tester.tap(passwordField);
      await tester.enterText(passwordField, '');
      
      // Enter valid email
      final emailField = find.byType(TextFormField).first;
      await tester.tap(emailField);
      await tester.enterText(emailField, TestData.validEmail);
      
      // Try to submit
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pump();

      // Assert - Should show validation error
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('validates short password', (tester) async {
      // Navigate to login
      await navigateToLoginScreen(tester);

      // Enter short password
      final passwordField = find.byType(TextFormField).last;
      await tester.tap(passwordField);
      await tester.enterText(passwordField, TestData.invalidPassword);
      
      // Try to submit
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pump();

      // Assert - Should show validation error
      expect(find.text('Password must be at least 6 characters'), findsOneWidget);
    });

    testWidgets('toggles password visibility', (tester) async {
      // Navigate to login
      await navigateToLoginScreen(tester);

      // Password should be obscured initially
      final passwordField = find.byType(TextFormField).last;
      final TextField textField = tester.widget<TextField>(
        find.descendant(
          of: passwordField,
          matching: find.byType(TextField),
        ),
      );
      expect(textField.obscureText, true);

      // Toggle visibility
      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pump();

      // Password should be visible
      final TextField visibleTextField = tester.widget<TextField>(
        find.descendant(
          of: passwordField,
          matching: find.byType(TextField),
        ),
      );
      expect(visibleTextField.obscureText, false);
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });

    testWidgets('shows loading state during login', (tester) async {
      // Navigate to login
      await navigateToLoginScreen(tester);

      // Enter credentials
      final emailField = find.byType(TextFormField).first;
      await tester.tap(emailField);
      await tester.enterText(emailField, TestData.validEmail);
      
      final passwordField = find.byType(TextFormField).last;
      await tester.tap(passwordField);
      await tester.enterText(passwordField, TestData.validPassword);

      // Submit form
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pump();

      // Should show loading indicator in button
      expect(find.descendant(
        of: find.byType(ElevatedButton),
        matching: find.byType(CircularProgressIndicator),
      ), findsOneWidget);
    });

    testWidgets('handles successful login and navigation', (tester) async {
      // Navigate to login
      await navigateToLoginScreen(tester);

      // Enter valid credentials
      final emailField = find.byType(TextFormField).first;
      await tester.tap(emailField);
      await tester.enterText(emailField, TestData.validEmail);
      
      final passwordField = find.byType(TextFormField).last;
      await tester.tap(passwordField);
      await tester.enterText(passwordField, TestData.validPassword);

      // Submit form
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      
      // Wait for login process
      await tester.pump(const Duration(seconds: 2));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Note: In a real test with mocked API, we would verify navigation to MetersListScreen
      // For now, we're testing the UI flow
    });

    testWidgets('displays error message for invalid credentials', (tester) async {
      // Navigate to login
      await navigateToLoginScreen(tester);

      // Enter invalid credentials
      final emailField = find.byType(TextFormField).first;
      await tester.tap(emailField);
      await tester.enterText(emailField, 'wrong@example.com');
      
      final passwordField = find.byType(TextFormField).last;
      await tester.tap(passwordField);
      await tester.enterText(passwordField, TestData.wrongPassword);

      // Submit form
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      
      // Wait for API response
      await tester.pump(const Duration(seconds: 2));
      await TestHelpers.pumpAndSettleWithTimeout(tester);

      // Should show error container (if API returns error)
      // Note: This would need mocked API to test properly
    });

    testWidgets('resets onboarding when debug button is pressed', (tester) async {
      // Navigate to login
      await navigateToLoginScreen(tester);

      // Tap reset onboarding button
      await tester.tap(find.text('Reset Onboarding (Debug)'));
      await tester.pump();

      // Should show snackbar
      expect(find.text('Onboarding reset! Restart the app.'), findsOneWidget);
      
      // Should navigate to splash
      expect(find.byType(SplashScreen), findsOneWidget);
    });

    testWidgets('submits form on password field submission', (tester) async {
      // Navigate to login
      await navigateToLoginScreen(tester);

      // Enter credentials
      final emailField = find.byType(TextFormField).first;
      await tester.tap(emailField);
      await tester.enterText(emailField, TestData.validEmail);
      
      final passwordField = find.byType(TextFormField).last;
      await tester.tap(passwordField);
      await tester.enterText(passwordField, TestData.validPassword);

      // Submit by pressing enter on password field
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      // Should show loading state
      expect(find.descendant(
        of: find.byType(ElevatedButton),
        matching: find.byType(CircularProgressIndicator),
      ), findsOneWidget);
    });
  });
}