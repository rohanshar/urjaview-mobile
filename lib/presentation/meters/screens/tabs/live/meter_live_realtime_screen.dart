import 'package:flutter/material.dart';
import '../../../../../data/models/meter_model.dart';
import '../../../widgets/live_tabs/realtime_tab_v2.dart';

class MeterLiveRealtimeScreen extends StatelessWidget {
  final MeterModel meter;

  const MeterLiveRealtimeScreen({
    super.key,
    required this.meter,
  });

  @override
  Widget build(BuildContext context) {
    return RealtimeTabV2(meter: meter);
  }
}