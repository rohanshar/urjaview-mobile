import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:urjaview_mobile/presentation/auth/screens/login_screen.dart';
import 'package:urjaview_mobile/presentation/auth/providers/auth_provider.dart';
import 'package:urjaview_mobile/data/repositories/auth_repository.dart';
import 'package:urjaview_mobile/data/services/api_service.dart';

void main() {
  testWidgets('Login screen displays correctly', (WidgetTester tester) async {
    // Create dependencies
    final apiService = ApiService();
    final authRepository = AuthRepository(apiService);

    // Build the login screen with necessary providers
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider(
          create: (_) => AuthProvider(authRepository),
          child: const LoginScreen(),
        ),
      ),
    );

    // Verify that the app name is displayed
    expect(find.text('UrjaView'), findsOneWidget);
    expect(find.text('Smart Meter Management'), findsOneWidget);

    // Verify that the email and password fields are present
    expect(find.byType(TextFormField), findsNWidgets(2));

    // Verify that the login button is present
    expect(find.text('Sign In'), findsOneWidget);

    // Verify demo credentials section
    expect(find.text('Demo Credentials'), findsOneWidget);
  });
}
