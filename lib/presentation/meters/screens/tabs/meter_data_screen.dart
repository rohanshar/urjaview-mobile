import 'package:flutter/material.dart';
import '../../../../data/models/meter_model.dart';
import '../../widgets/meter_data_tab.dart';

class MeterDataScreen extends StatelessWidget {
  final MeterModel meter;

  const MeterDataScreen({super.key, required this.meter});

  @override
  Widget build(BuildContext context) {
    return MeterDataTab(meter: meter);
  }
}
