import 'package:flutter/material.dart';
import '../../../../data/models/meter_model.dart';
import '../../widgets/meter_jobs_tab.dart';

class MeterJobsScreen extends StatelessWidget {
  final MeterModel meter;

  const MeterJobsScreen({
    super.key,
    required this.meter,
  });

  @override
  Widget build(BuildContext context) {
    return MeterJobsTab(meter: meter);
  }
}