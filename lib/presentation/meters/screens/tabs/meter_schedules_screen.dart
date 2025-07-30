import 'package:flutter/material.dart';
import '../../../../data/models/meter_model.dart';
import '../../widgets/meter_schedules_tab.dart';

class MeterSchedulesScreen extends StatelessWidget {
  final MeterModel meter;

  const MeterSchedulesScreen({super.key, required this.meter});

  @override
  Widget build(BuildContext context) {
    return MeterSchedulesTab(meter: meter);
  }
}
