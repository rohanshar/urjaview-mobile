import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/meter_model.dart';
import '../providers/meter_provider.dart';
import '../widgets/meter_overview_tab.dart';
import '../widgets/meter_data_tab.dart';
import '../widgets/meter_live_tab.dart';
import '../widgets/meter_jobs_tab.dart';
import '../widgets/meter_schedules_tab.dart';
import '../widgets/meter_settings_tab.dart';

class MeterDetailScreen extends StatefulWidget {
  final String meterId;

  const MeterDetailScreen({super.key, required this.meterId});

  @override
  State<MeterDetailScreen> createState() => _MeterDetailScreenState();
}

class _MeterDetailScreenState extends State<MeterDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MeterProvider>(
      builder: (context, meterProvider, child) {
        final meter = meterProvider.meters.firstWhere(
          (m) => m.id == widget.meterId,
          orElse:
              () => MeterModel(
                id: '',
                name: 'Unknown',
                serialNumber: '',
                meterIp: '',
                port: 0,
                status: 'unknown',
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              ),
        );

        if (meter.id.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Meter Not Found')),
            body: const Center(child: Text('Meter not found')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(meter.name),
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: AppTheme.primaryColor,
              unselectedLabelColor: AppTheme.textSecondary,
              indicatorColor: AppTheme.primaryColor,
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Data'),
                Tab(text: 'Live'),
                Tab(text: 'Jobs'),
                Tab(text: 'Schedules'),
                Tab(text: 'Settings'),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  meterProvider.loadMeters();
                },
              ),
            ],
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              MeterOverviewTab(meter: meter),
              MeterDataTab(meter: meter),
              MeterLiveTab(meter: meter),
              MeterJobsTab(meter: meter),
              MeterSchedulesTab(meter: meter),
              MeterSettingsTab(meter: meter),
            ],
          ),
        );
      },
    );
  }
}
