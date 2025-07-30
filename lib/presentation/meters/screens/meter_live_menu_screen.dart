import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/meter_model.dart';
import '../providers/meter_provider.dart';

class MeterLiveMenuScreen extends StatelessWidget {
  final String meterId;

  const MeterLiveMenuScreen({super.key, required this.meterId});

  @override
  Widget build(BuildContext context) {
    return Consumer<MeterProvider>(
      builder: (context, meterProvider, child) {
        final meter = _getMeter(meterProvider);

        if (meter == null) {
          return _buildErrorScreen(context);
        }

        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Live Data'),
                Text(
                  meter.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildMenuCard(
                context: context,
                icon: Icons.dashboard,
                title: 'General Information',
                subtitle: 'View meter details and status',
                color: AppTheme.primaryColor,
                onTap: () => _showComingSoon(context, 'General Information'),
              ),
              const SizedBox(height: 12),
              _buildMenuCard(
                context: context,
                icon: Icons.data_object,
                title: 'Objects',
                subtitle: 'Browse and read DLMS objects',
                color: Colors.blue,
                onTap: () => _showComingSoon(context, 'Objects'),
              ),
              const SizedBox(height: 12),
              _buildMenuCard(
                context: context,
                icon: Icons.speed,
                title: 'Instant Readings',
                subtitle: 'Live electrical measurements',
                color: AppTheme.secondaryColor,
                onTap: () => context.go('/meters/$meterId/instant'),
              ),
              const SizedBox(height: 12),
              _buildMenuCard(
                context: context,
                icon: Icons.notification_important,
                title: 'Events',
                subtitle: 'View meter events and alarms',
                color: Colors.orange,
                onTap: () => _showComingSoon(context, 'Events'),
              ),
              const SizedBox(height: 12),
              _buildMenuCard(
                context: context,
                icon: Icons.show_chart,
                title: 'Load Survey',
                subtitle: 'Energy consumption patterns',
                color: Colors.purple,
                onTap: () => _showComingSoon(context, 'Load Survey'),
              ),
              const SizedBox(height: 12),
              _buildMenuCard(
                context: context,
                icon: Icons.receipt,
                title: 'Billing',
                subtitle: 'Billing data and reports',
                color: Colors.green,
                onTap: () => _showComingSoon(context, 'Billing'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 28, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppTheme.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  MeterModel? _getMeter(MeterProvider provider) {
    try {
      return provider.meters.firstWhere((m) => m.id == meterId);
    } catch (_) {
      return null;
    }
  }

  Widget _buildErrorScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppTheme.errorColor),
            const SizedBox(height: 16),
            const Text('Meter not found', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature - Coming Soon'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
