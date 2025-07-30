import 'package:flutter/material.dart';
import '../../../../../data/models/meter_model.dart';
import '../../../widgets/live_tabs/events_tab.dart';

class MeterLiveEventsScreen extends StatelessWidget {
  final MeterModel meter;

  const MeterLiveEventsScreen({super.key, required this.meter});

  @override
  Widget build(BuildContext context) {
    return EventsTab(meter: meter);
  }
}
