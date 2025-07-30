import 'package:flutter/material.dart';
import '../../../../../data/models/meter_model.dart';
import '../../../widgets/live_tabs/load_survey_tab.dart';

class MeterLiveLoadSurveyScreen extends StatelessWidget {
  final MeterModel meter;

  const MeterLiveLoadSurveyScreen({
    super.key,
    required this.meter,
  });

  @override
  Widget build(BuildContext context) {
    return LoadSurveyTab(meter: meter);
  }
}