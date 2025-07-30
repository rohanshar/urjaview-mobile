import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/providers/auth_provider.dart';
import '../../meters/providers/meter_provider.dart';
import '../widgets/metric_card.dart';
import '../widgets/recent_jobs_card.dart';
import '../widgets/meter_status_chart.dart';
import '../widgets/system_overview_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Load dashboard data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MeterProvider>().loadMeters();
      // TODO: Load jobs data when provider is available
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final meterProvider = context.watch<MeterProvider>();

    // Calculate metrics
    final totalMeters = meterProvider.meters.length;
    final activeMeters =
        meterProvider.meters
            .where((m) => m.status.toLowerCase() == 'active')
            .length;
    final faultyMeters =
        meterProvider.meters
            .where((m) => m.status.toLowerCase() == 'faulty')
            .length;
    final inactiveMeters = totalMeters - activeMeters - faultyMeters;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<MeterProvider>().loadMeters();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dashboard',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Welcome back, ${authProvider.user?.email ?? 'User'}',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Metrics Row
              Row(
                children: [
                  Expanded(
                    child: MetricCard(
                      title: 'Total Meters',
                      value: totalMeters.toString(),
                      subtitle: '$activeMeters active, $faultyMeters faulty',
                      icon: Icons.electric_meter_outlined,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: MetricCard(
                      title: 'Active Meters',
                      value: activeMeters.toString(),
                      subtitle:
                          totalMeters > 0
                              ? '${((activeMeters / totalMeters) * 100).toStringAsFixed(0)}% of total'
                              : '0% of total',
                      icon: Icons.power,
                      color: AppTheme.successColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: MetricCard(
                      title: 'Total Jobs',
                      value: '0', // TODO: Get from jobs provider
                      subtitle: '0 completed',
                      icon: Icons.work_outline,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: MetricCard(
                      title: 'User Role',
                      value: authProvider.user?.role ?? 'User',
                      subtitle: 'Company: N/A',
                      icon: Icons.person_outline,
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Recent Jobs Section
              const RecentJobsCard(),
              const SizedBox(height: 24),

              // Charts Row
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth >= 800) {
                    // Desktop layout
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: MeterStatusChart(
                            activeCount: activeMeters,
                            inactiveCount: inactiveMeters,
                            faultyCount: faultyMeters,
                          ),
                        ),
                        const SizedBox(width: 24),
                        const Expanded(child: SystemOverviewCard()),
                      ],
                    );
                  } else {
                    // Mobile layout
                    return Column(
                      children: [
                        MeterStatusChart(
                          activeCount: activeMeters,
                          inactiveCount: inactiveMeters,
                          faultyCount: faultyMeters,
                        ),
                        const SizedBox(height: 24),
                        const SystemOverviewCard(),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
