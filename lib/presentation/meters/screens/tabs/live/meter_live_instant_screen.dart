import 'package:flutter/material.dart';
import '../../../../../data/models/meter_model.dart';
import '../../../widgets/live_tabs/instant_tab_v2.dart';

class MeterLiveInstantScreen extends StatelessWidget {
  final MeterModel meter;

  const MeterLiveInstantScreen({super.key, required this.meter});

  @override
  Widget build(BuildContext context) {
    return InstantTabV2(meter: meter);
  }
}
