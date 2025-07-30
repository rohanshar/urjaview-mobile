import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_router.dart';
import 'data/services/api_service.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/meter_repository.dart';
import 'presentation/auth/providers/auth_provider.dart';
import 'presentation/meters/providers/meter_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize services
    final apiService = ApiService();
    final authRepository = AuthRepository(apiService);
    final meterRepository = MeterRepository(apiService);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(authRepository)),
        ChangeNotifierProvider(create: (_) => MeterProvider(meterRepository)),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp.router(
            title: 'UrjaView',
            theme: AppTheme.lightTheme,
            debugShowCheckedModeBanner: false,
            routerConfig: AppRouter.router(context),
          );
        },
      ),
    );
  }
}
