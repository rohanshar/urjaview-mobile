import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/meter_model.dart';
import '../providers/meter_provider.dart';
import '../widgets/meter_overview_tab.dart';

class MeterDetailMobileScreen extends StatefulWidget {
  final String meterId;

  const MeterDetailMobileScreen({super.key, required this.meterId});

  @override
  State<MeterDetailMobileScreen> createState() =>
      _MeterDetailMobileScreenState();
}

class _MeterDetailMobileScreenState extends State<MeterDetailMobileScreen> {
  @override
  void initState() {
    super.initState();
    // Load meter details if needed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final meterProvider = context.read<MeterProvider>();
      if (meterProvider.meters.isEmpty) {
        meterProvider.loadMeters();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MeterProvider>(
      builder: (context, meterProvider, child) {
        final meter = _getMeter(meterProvider);

        if (meter == null) {
          return _buildErrorScreen();
        }

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              _buildSliverAppBar(meter),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    // Overview section (always visible)
                    MeterOverviewTab(meter: meter),
                    const SizedBox(height: 16),

                    // Action Cards
                    _buildActionSection(meter),
                    const SizedBox(height: 16),

                    // Quick Actions
                    _buildQuickActions(meter),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSliverAppBar(MeterModel meter) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: AppTheme.primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              meter.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    offset: Offset(0, 1),
                    blurRadius: 3,
                    color: Colors.black26,
                  ),
                ],
              ),
            ),
            Text(
              meter.serialNumber,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.normal,
                color: Colors.white70,
                shadows: [
                  Shadow(
                    offset: Offset(0, 1),
                    blurRadius: 2,
                    color: Colors.black26,
                  ),
                ],
              ),
            ),
          ],
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppTheme.primaryColor,
                AppTheme.primaryColor.withValues(alpha: 0.8),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.electric_meter,
                    size: 64,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                  const SizedBox(height: 12),
                  _buildStatusChip(meter),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white),
          onPressed: () {
            context.read<MeterProvider>().loadMeters();
          },
        ),
      ],
    );
  }

  Widget _buildStatusChip(MeterModel meter) {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (meter.status.toLowerCase()) {
      case 'active':
        backgroundColor = Colors.green;
        textColor = Colors.white;
        icon = Icons.check_circle;
        break;
      case 'inactive':
        backgroundColor = Colors.grey;
        textColor = Colors.white;
        icon = Icons.remove_circle_outline;
        break;
      case 'faulty':
        backgroundColor = Colors.red;
        textColor = Colors.white;
        icon = Icons.error_outline;
        break;
      default:
        backgroundColor = Colors.grey;
        textColor = Colors.white;
        icon = Icons.help_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 4),
          Text(
            meter.status.toUpperCase(),
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionSection(MeterModel meter) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Actions',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildActionGrid(meter),
        ],
      ),
    );
  }

  Widget _buildActionGrid(MeterModel meter) {
    final actions = [
      _ActionItem(
        icon: Icons.analytics,
        label: 'Real-time Data',
        color: AppTheme.primaryColor,
        onTap: () => _navigateToRealtime(meter),
      ),
      _ActionItem(
        icon: Icons.history,
        label: 'Historical Data',
        color: AppTheme.secondaryColor,
        onTap: () => _navigateToHistorical(meter),
      ),
      _ActionItem(
        icon: Icons.work_outline,
        label: 'Jobs',
        color: AppTheme.warningColor,
        onTap: () => _navigateToJobs(meter),
      ),
      _ActionItem(
        icon: Icons.schedule,
        label: 'Schedules',
        color: Colors.purple,
        onTap: () => _navigateToSchedules(meter),
      ),
      _ActionItem(
        icon: Icons.event,
        label: 'Events',
        color: Colors.orange,
        onTap: () => _navigateToEvents(meter),
      ),
      _ActionItem(
        icon: Icons.settings_applications,
        label: 'Config',
        color: Colors.teal,
        onTap: () => _navigateToConfig(meter),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return _buildActionCard(action);
      },
    );
  }

  Widget _buildActionCard(_ActionItem action) {
    return InkWell(
      onTap: action.onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: action.color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: action.color.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(action.icon, size: 32, color: action.color),
            const SizedBox(height: 8),
            Text(
              action.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: action.color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(MeterModel meter) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildQuickActionCard(
            icon: Icons.network_ping,
            title: 'Test Connection',
            subtitle: 'Ping meter and test DLMS connection',
            onTap: () => _navigateToConnectionTest(meter),
          ),
          const SizedBox(height: 12),
          _buildQuickActionCard(
            icon: Icons.download,
            title: 'Download Data',
            subtitle: 'Export meter data to various formats',
            onTap: () => _navigateToDataExport(meter),
          ),
          const SizedBox(height: 12),
          _buildQuickActionCard(
            icon: Icons.receipt_long,
            title: 'Billing Report',
            subtitle: 'View and generate billing reports',
            onTap: () => _navigateToBillingReport(meter),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppTheme.primaryColor.withValues(alpha: 0.2)),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppTheme.primaryColor),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  MeterModel? _getMeter(MeterProvider provider) {
    try {
      return provider.meters.firstWhere((m) => m.id == widget.meterId);
    } catch (_) {
      return null;
    }
  }

  Widget _buildErrorScreen() {
    return Scaffold(
      appBar: AppBar(title: const Text('Meter Not Found')),
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

  // Navigation methods
  void _navigateToRealtime(MeterModel meter) {
    context.go('/meters/${meter.id}/realtime');
  }

  void _navigateToHistorical(MeterModel meter) {
    // TODO: Implement historical data screen
    _showComingSoon('Historical Data');
  }

  void _navigateToJobs(MeterModel meter) {
    // TODO: Implement jobs screen
    _showComingSoon('Jobs');
  }

  void _navigateToSchedules(MeterModel meter) {
    // TODO: Implement schedules screen
    _showComingSoon('Schedules');
  }

  void _navigateToEvents(MeterModel meter) {
    context.go('/meters/${meter.id}/live');
  }

  void _navigateToConfig(MeterModel meter) {
    context.go('/meters/${meter.id}/config');
  }

  void _navigateToConnectionTest(MeterModel meter) {
    // Navigate to realtime screen which has connection test
    context.go('/meters/${meter.id}/realtime');
  }

  void _navigateToDataExport(MeterModel meter) {
    // TODO: Implement data export screen
    _showComingSoon('Data Export');
  }

  void _navigateToBillingReport(MeterModel meter) {
    // TODO: Implement billing report screen
    _showComingSoon('Billing Report');
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature - Coming Soon'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

class _ActionItem {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  _ActionItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}
