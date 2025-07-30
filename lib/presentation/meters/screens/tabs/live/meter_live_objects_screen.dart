import 'package:flutter/material.dart';
import '../../../../../data/models/meter_model.dart';
import '../../../widgets/live_tabs/objects_tab.dart';

class MeterLiveObjectsScreen extends StatelessWidget {
  final MeterModel meter;

  const MeterLiveObjectsScreen({
    super.key,
    required this.meter,
  });

  @override
  Widget build(BuildContext context) {
    return ObjectsTab(meter: meter);
  }
}