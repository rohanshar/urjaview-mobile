import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/app_theme.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final String currentRoute;
  final Function(String) onItemSelected;

  const NavigationDrawerWidget({
    super.key,
    required this.currentRoute,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 1200;
    
    return Container(
      width: isDesktop ? 240 : null,
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        border: Border(
          right: BorderSide(
            color: AppTheme.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Logo section
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                if (isDesktop) ...[
                  SvgPicture.asset(
                    'assets/images/urjaview-logo.svg',
                    height: 32,
                    colorFilter: ColorFilter.mode(
                      AppTheme.primaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'UrjaView',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      Text(
                        'by Indotech Meters',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  DrawerHeader(
                    decoration: const BoxDecoration(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/urjaview-logo.svg',
                          height: 48,
                          colorFilter: ColorFilter.mode(
                            AppTheme.primaryColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'UrjaView',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        Text(
                          'by Indotech Meters',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          Divider(color: AppTheme.dividerColor, height: 1),
          // Navigation items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildNavItem(
                  context,
                  icon: Icons.dashboard,
                  label: 'Dashboard',
                  route: '/dashboard',
                ),
                _buildNavItem(
                  context,
                  icon: Icons.electric_meter,
                  label: 'Meters',
                  route: '/meters',
                ),
                _buildNavItem(
                  context,
                  icon: Icons.business,
                  label: 'Companies',
                  route: '/companies',
                ),
                _buildNavItem(
                  context,
                  icon: Icons.people,
                  label: 'Users',
                  route: '/users',
                ),
                _buildNavItem(
                  context,
                  icon: Icons.analytics,
                  label: 'Data',
                  route: '/data',
                ),
                _buildNavItem(
                  context,
                  icon: Icons.schedule,
                  label: 'Schedules',
                  route: '/schedules',
                ),
                _buildNavItem(
                  context,
                  icon: Icons.work,
                  label: 'Jobs',
                  route: '/jobs',
                ),
                const SizedBox(height: 8),
                Divider(color: AppTheme.dividerColor, height: 1),
                const SizedBox(height: 8),
                _buildNavItem(
                  context,
                  icon: Icons.settings,
                  label: 'Settings',
                  route: '/settings',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
  }) {
    final isSelected = currentRoute == route;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () => onItemSelected(route),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primaryColor.withValues(alpha: 0.1) : null,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}