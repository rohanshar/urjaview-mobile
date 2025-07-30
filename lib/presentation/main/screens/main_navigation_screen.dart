import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/providers/auth_provider.dart';
import '../../dashboard/screens/dashboard_screen.dart';
import '../../meters/screens/meters_list_screen.dart';
import '../widgets/navigation_drawer.dart';

class MainNavigationScreen extends StatefulWidget {
  final String currentRoute;

  const MainNavigationScreen({super.key, required this.currentRoute});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String get _currentRoute => widget.currentRoute;

  String get _pageTitle {
    switch (_currentRoute) {
      case '/dashboard':
        return 'Dashboard';
      case '/meters':
        return 'Meters';
      case '/companies':
        return 'Companies';
      case '/users':
        return 'Users';
      case '/data':
        return 'Data';
      case '/schedules':
        return 'Schedules';
      case '/jobs':
        return 'Jobs';
      case '/settings':
        return 'Settings';
      default:
        return 'UrjaView';
    }
  }

  Widget get _currentScreen {
    switch (_currentRoute) {
      case '/dashboard':
        return const DashboardScreen();
      case '/meters':
        return const MetersListScreen();
      case '/companies':
        return _buildComingSoonScreen('Companies');
      case '/users':
        return _buildComingSoonScreen('Users');
      case '/data':
        return _buildComingSoonScreen('Data');
      case '/schedules':
        return _buildComingSoonScreen('Schedules');
      case '/jobs':
        return _buildComingSoonScreen('Jobs');
      case '/settings':
        return _buildComingSoonScreen('Settings');
      default:
        return const DashboardScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isDesktop = MediaQuery.of(context).size.width >= 1200;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppTheme.backgroundColor,
      appBar:
          isDesktop
              ? null
              : AppBar(
                title: Text(
                  _pageTitle,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                ),
                actions: [
                  PopupMenuButton<String>(
                    icon: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 16,
                      child: Text(
                        authProvider.user?.email
                                .substring(0, 1)
                                .toUpperCase() ??
                            'U',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    itemBuilder:
                        (context) => [
                          PopupMenuItem(
                            value: 'profile',
                            child: Row(
                              children: [
                                const Icon(Icons.person_outline),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      authProvider.user?.email ?? '',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      authProvider.user?.role ?? '',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const PopupMenuDivider(),
                          const PopupMenuItem(
                            value: 'logout',
                            child: Row(
                              children: [
                                Icon(Icons.logout, color: AppTheme.errorColor),
                                SizedBox(width: 12),
                                Text(
                                  'Logout',
                                  style: TextStyle(color: AppTheme.errorColor),
                                ),
                              ],
                            ),
                          ),
                        ],
                    onSelected: (value) {
                      if (value == 'logout') {
                        context.read<AuthProvider>().logout();
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ),
      drawer:
          isDesktop
              ? null
              : NavigationDrawerWidget(
                currentRoute: _currentRoute,
                onItemSelected: (route) {
                  Navigator.pop(context); // Close drawer
                  if (route != _currentRoute) {
                    context.go(route);
                  }
                },
              ),
      body: Row(
        children: [
          if (isDesktop)
            NavigationDrawerWidget(
              currentRoute: _currentRoute,
              onItemSelected: (route) {
                if (route != _currentRoute) {
                  context.go(route);
                }
              },
            ),
          Expanded(child: _currentScreen),
        ],
      ),
    );
  }

  Widget _buildComingSoonScreen(String feature) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction,
            size: 64,
            color: AppTheme.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            '$feature Coming Soon',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'This feature is under development',
            style: TextStyle(color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }
}
