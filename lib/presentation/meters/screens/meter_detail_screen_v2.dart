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
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              meter.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'S/N: ${meter.serialNumber}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
        toolbarHeight: 72,
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
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
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
