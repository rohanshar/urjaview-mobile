import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/meter_model.dart';
import 'live_tabs/general_tab.dart';
import 'live_tabs/objects_tab.dart';
import 'live_tabs/realtime_tab_v2.dart';
import 'live_tabs/events_tab.dart';
import 'live_tabs/load_survey_tab.dart';
import 'live_tabs/billing_tab.dart';

class MeterLiveTab extends StatefulWidget {
  final MeterModel meter;

  const MeterLiveTab({super.key, required this.meter});

  @override
  State<MeterLiveTab> createState() => _MeterLiveTabState();
}

class _MeterLiveTabState extends State<MeterLiveTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
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
          color: AppTheme.backgroundColor,
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: AppTheme.primaryColor,
            unselectedLabelColor: AppTheme.textSecondary,
            indicatorColor: AppTheme.primaryColor,
            tabs: const [
              Tab(text: 'General'),
              Tab(text: 'Objects'),
              Tab(text: 'Real Time'),
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
              GeneralTab(meter: widget.meter),
              ObjectsTab(meter: widget.meter),
              RealtimeTabV2(meter: widget.meter),
              EventsTab(meter: widget.meter),
              LoadSurveyTab(meter: widget.meter),
              BillingTab(meter: widget.meter),
            ],
          ),
        ),
      ],
    );
  }
}
