import 'package:flutter/material.dart';
import '../../../../data/models/meter_model.dart';
import '../../widgets/meter_settings_tab.dart';

class MeterSettingsScreen extends StatelessWidget {
  final MeterModel meter;

  const MeterSettingsScreen({super.key, required this.meter});

  @override
  Widget build(BuildContext context) {
    return MeterSettingsTab(meter: meter);
  }
}
