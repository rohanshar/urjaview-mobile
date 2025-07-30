import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/meter_model.dart';
import '../providers/meter_provider.dart';
import '../navigation/meter_navigation_controller.dart';
import 'tabs/meter_overview_screen.dart';
import 'tabs/meter_data_screen.dart';
import 'tabs/meter_live_screen.dart';
import 'tabs/meter_config_screen.dart';
import 'tabs/meter_jobs_screen.dart';
import 'tabs/meter_schedules_screen.dart';
import 'tabs/meter_settings_screen.dart';

class MeterDetailScreenV2 extends StatefulWidget {
  final String meterId;

  const MeterDetailScreenV2({super.key, required this.meterId});

  @override
  State<MeterDetailScreenV2> createState() => _MeterDetailScreenV2State();
}

class _MeterDetailScreenV2State extends State<MeterDetailScreenV2>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  MeterNavigationController? _navigationController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);

    // Load meter details if needed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final meterProvider = context.read<MeterProvider>();
      if (meterProvider.meters.isEmpty) {
        meterProvider.loadMeters();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _navigationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MeterProvider>(
      builder: (context, meterProvider, child) {
        final meter = _getMeter(meterProvider);

        if (meter == null) {
          return _buildErrorScreen();
        }

        // Initialize navigation controller if not already done
        _navigationController ??= MeterNavigationController(meter: meter);

        return ChangeNotifierProvider.value(
          value: _navigationController!,
          child: _buildMeterDetailScreen(meter, meterProvider),
        );
      },
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

  Widget _buildMeterDetailScreen(MeterModel meter, MeterProvider provider) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(meter.name),
            Text(
              meter.serialNumber,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Consumer<MeterNavigationController>(
            builder: (context, navController, child) {
              // Sync tab controller with navigation controller
              if (_tabController.index != navController.selectedTabIndex) {
                _tabController.animateTo(navController.selectedTabIndex);
              }

              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  border: Border(
                    bottom: BorderSide(color: AppTheme.dividerColor, width: 1),
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: AppTheme.primaryColor,
                  unselectedLabelColor: AppTheme.textSecondary,
                  indicatorColor: AppTheme.primaryColor,
                  indicatorWeight: 3,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 20),
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  onTap: (index) => navController.setTabIndex(index),
                  tabs: const [
                    Tab(text: 'Overview'),
                    Tab(text: 'Data'),
                    Tab(text: 'Live'),
                    Tab(text: 'Config'),
                    Tab(text: 'Jobs'),
                    Tab(text: 'Schedules'),
                    Tab(text: 'Settings'),
                  ],
                ),
              );
            },
          ),
        ),
        actions: [
          // Sync Now button
          TextButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sync functionality coming soon'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(Icons.sync, size: 20),
            label: const Text('Sync Now'),
            style: TextButton.styleFrom(foregroundColor: AppTheme.primaryColor),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          MeterOverviewScreen(meter: meter),
          MeterDataScreen(meter: meter),
          MeterLiveScreen(meter: meter),
          MeterConfigScreen(meter: meter),
          MeterJobsScreen(meter: meter),
          MeterSchedulesScreen(meter: meter),
          MeterSettingsScreen(meter: meter),
        ],
      ),
    );
  }
}
