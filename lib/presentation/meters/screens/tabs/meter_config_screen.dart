import 'package:flutter/material.dart';
import '../../../../data/models/meter_model.dart';
import '../../widgets/meter_config_tab.dart';

class MeterConfigScreen extends StatelessWidget {
  final MeterModel meter;

  const MeterConfigScreen({super.key, required this.meter});

  @override
  Widget build(BuildContext context) {
    return MeterConfigTab(meter: meter);
  }
}
