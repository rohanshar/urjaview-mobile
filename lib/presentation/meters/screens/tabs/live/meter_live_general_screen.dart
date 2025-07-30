import 'package:flutter/material.dart';
import '../../../../../data/models/meter_model.dart';
import '../../../widgets/live_tabs/general_tab.dart';

class MeterLiveGeneralScreen extends StatelessWidget {
  final MeterModel meter;

  const MeterLiveGeneralScreen({
    super.key,
    required this.meter,
  });

  @override
  Widget build(BuildContext context) {
    return GeneralTab(meter: meter);
  }
}