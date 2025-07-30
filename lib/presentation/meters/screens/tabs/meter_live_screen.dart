import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/meter_model.dart';
import '../../navigation/meter_navigation_controller.dart';
import 'live/meter_live_general_screen.dart';
import 'live/meter_live_objects_screen.dart';
import 'live/meter_live_instant_screen.dart';
import 'live/meter_live_events_screen.dart';
import 'live/meter_live_load_survey_screen.dart';
import 'live/meter_live_billing_screen.dart';

class MeterLiveScreen extends StatefulWidget {
  final MeterModel meter;

  const MeterLiveScreen({super.key, required this.meter});

  @override
  State<MeterLiveScreen> createState() => _MeterLiveScreenState();
}

class _MeterLiveScreenState extends State<MeterLiveScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);

    // Sync with navigation controller
    final navController = context.read<MeterNavigationController>();
    _tabController.index = navController.selectedLiveSubTabIndex;

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        navController.setLiveSubTabIndex(_tabController.index);
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
    return Column(
      children: [
        Container(
          color: Theme.of(context).appBarTheme.backgroundColor,
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: AppTheme.primaryColor,
            unselectedLabelColor: AppTheme.textSecondary,
            indicatorColor: AppTheme.primaryColor,
            tabs: const [
              Tab(text: 'General'),
              Tab(text: 'Objects'),
              Tab(text: 'Instant'),
              Tab(text: 'Events'),
              Tab(text: 'Load Survey'),
              Tab(text: 'Billing'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              MeterLiveGeneralScreen(meter: widget.meter),
              MeterLiveObjectsScreen(meter: widget.meter),
              MeterLiveInstantScreen(meter: widget.meter),
              MeterLiveEventsScreen(meter: widget.meter),
              MeterLiveLoadSurveyScreen(meter: widget.meter),
              MeterLiveBillingScreen(meter: widget.meter),
            ],
          ),
        ),
      ],
    );
  }
}
