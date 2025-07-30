import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/meter_model.dart';
import '../providers/meter_provider.dart';
import '../widgets/meter_config_tab.dart';

class MeterConfigMenuScreen extends StatelessWidget {
  final String meterId;

  const MeterConfigMenuScreen({
    super.key,
    required this.meterId,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<MeterProvider>(
      builder: (context, meterProvider, child) {
        final meter = _getMeter(meterProvider);

        if (meter == null) {
          return _buildErrorScreen(context);
        }

        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Configuration'),
                Text(
                  meter.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          body: MeterConfigTab(meter: meter),
        );
      },
    );
  }

  MeterModel? _getMeter(MeterProvider provider) {
    try {
      return provider.meters.firstWhere((m) => m.id == meterId);
    } catch (_) {
      return null;
    }
  }

  Widget _buildErrorScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppTheme.errorColor,
            ),
            const SizedBox(height: 16),
            const Text(
              'Meter not found',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}