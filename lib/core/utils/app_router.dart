import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../presentation/auth/providers/auth_provider.dart';
import '../../presentation/auth/screens/login_screen.dart';
import '../../presentation/main/screens/main_navigation_screen.dart';
import '../../presentation/meters/screens/meter_detail_screen_v2.dart';

class AppRouter {
  static GoRouter router(BuildContext context) {
    return GoRouter(
      initialLocation: '/login',
      refreshListenable: context.read<AuthProvider>(),
      redirect: (context, state) {
        final authProvider = context.read<AuthProvider>();
        final isAuthenticated = authProvider.isAuthenticated;
        final isLoginRoute = state.matchedLocation == '/login';

        if (!isAuthenticated && !isLoginRoute) {
          return '/login';
        }

        if (isAuthenticated && isLoginRoute) {
          return '/dashboard';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        // Dashboard route
        GoRoute(
          path: '/dashboard',
          name: 'dashboard',
          builder: (context, state) => const MainNavigationScreen(currentRoute: '/dashboard'),
        ),
        // Meters route
        GoRoute(
          path: '/meters',
          name: 'meters',
          builder: (context, state) => const MainNavigationScreen(currentRoute: '/meters'),
          routes: [
            GoRoute(
              path: ':id',
              name: 'meter-detail',
              builder: (context, state) {
                final meterId = state.pathParameters['id']!;
                return MeterDetailScreenV2(meterId: meterId);
              },
            ),
          ],
        ),
        // Companies route
        GoRoute(
          path: '/companies',
          name: 'companies',
          builder: (context, state) => const MainNavigationScreen(currentRoute: '/companies'),
        ),
        // Users route
        GoRoute(
          path: '/users',
          name: 'users',
          builder: (context, state) => const MainNavigationScreen(currentRoute: '/users'),
        ),
        // Data route
        GoRoute(
          path: '/data',
          name: 'data',
          builder: (context, state) => const MainNavigationScreen(currentRoute: '/data'),
        ),
        // Schedules route
        GoRoute(
          path: '/schedules',
          name: 'schedules',
          builder: (context, state) => const MainNavigationScreen(currentRoute: '/schedules'),
        ),
        // Jobs route
        GoRoute(
          path: '/jobs',
          name: 'jobs',
          builder: (context, state) => const MainNavigationScreen(currentRoute: '/jobs'),
        ),
        // Settings route
        GoRoute(
          path: '/settings',
          name: 'settings',
          builder: (context, state) => const MainNavigationScreen(currentRoute: '/settings'),
        ),
      ],
      errorBuilder:
          (context, state) => Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Page not found',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.error?.toString() ?? 'Unknown error',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.go('/dashboard'),
                    child: const Text('Go to Dashboard'),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
