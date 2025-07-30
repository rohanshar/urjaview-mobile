import 'package:flutter/material.dart';
import '../../../../../data/models/meter_model.dart';
import '../../../widgets/live_tabs/billing_tab.dart';

class MeterLiveBillingScreen extends StatelessWidget {
  final MeterModel meter;

  const MeterLiveBillingScreen({super.key, required this.meter});

  @override
  Widget build(BuildContext context) {
    return BillingTab(meter: meter);
  }
}
