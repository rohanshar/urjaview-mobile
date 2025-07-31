import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:urjaview_mobile/presentation/auth/screens/login_screen.dart';
import 'package:urjaview_mobile/presentation/dashboard/screens/dashboard_screen.dart';
import 'package:urjaview_mobile/presentation/meters/screens/meters_list_screen.dart';
import 'package:urjaview_mobile/presentation/auth/providers/auth_provider.dart';
import 'package:urjaview_mobile/data/repositories/auth_repository.dart';
import 'package:urjaview_mobile/data/services/api_service.dart';
import 'screenshot_utils.dart';
import 'test_theme.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
    final dir = Directory('test/screenshots/simple');
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
  });

  group('Real Screenshots', () {
    testGoldens('Login Screen', (tester) async {
      // Create a simple app with just the login screen
      await tester.pumpWidgetBuilder(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: TestAppTheme.lightTheme,
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => AuthProvider(AuthRepository(ApiService())),
              ),
            ],
            child: const LoginScreen(),
          ),
        ),
        surfaceSize: const Size(414, 896), // iPhone size
      );

      await screenMatchesGolden(tester, 'simple/login');
    });

    testGoldens('Dashboard Screen', (tester) async {
      final mockAuthProvider = MockAuthProvider();

      await tester.pumpWidgetBuilder(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: TestAppTheme.lightTheme,
          home: MultiProvider(
            providers: [ChangeNotifierProvider.value(value: mockAuthProvider)],
            child: const DashboardScreen(),
          ),
        ),
        surfaceSize: const Size(414, 896),
      );

      await screenMatchesGolden(tester, 'simple/dashboard');
    });

    testGoldens('Meters List Screen', (tester) async {
      final mockAuthProvider = MockAuthProvider();
      final mockMeterProvider = MockMeterProvider();

      // Create router with mocked providers
      final router = GoRouter(
        initialLocation: '/meters',
        routes: [
          GoRoute(
            path: '/meters',
            builder: (context, state) => const MetersListScreen(),
          ),
          GoRoute(
            path: '/meters/:id',
            builder:
                (context, state) =>
                    const Scaffold(body: Center(child: Text('Meter Detail'))),
          ),
        ],
      );

      await tester.pumpWidgetBuilder(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: mockAuthProvider),
            ChangeNotifierProvider.value(value: mockMeterProvider),
          ],
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: TestAppTheme.lightTheme,
            routerConfig: router,
          ),
        ),
        surfaceSize: const Size(414, 896),
      );

      // Wait for any animations
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      await screenMatchesGolden(tester, 'simple/meters');
    });
  });
}
