import 'package:flutter/material.dart';
import '../../../../data/models/meter_model.dart';
import '../../widgets/meter_overview_tab.dart';

class MeterOverviewScreen extends StatelessWidget {
  final MeterModel meter;

  const MeterOverviewScreen({super.key, required this.meter});

  @override
  Widget build(BuildContext context) {
    return MeterOverviewTab(meter: meter);
  }
}
