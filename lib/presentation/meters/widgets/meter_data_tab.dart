import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/meter_model.dart';

class MeterDataTab extends StatelessWidget {
  final MeterModel meter;

  const MeterDataTab({super.key, required this.meter});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.table_chart,
            size: 64,
            color: AppTheme.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Historical Data',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'View historical meter readings and trends',
            style: TextStyle(color: AppTheme.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Historical data view coming soon'),
                ),
              );
            },
            icon: const Icon(Icons.download),
            label: const Text('Export Data'),
          ),
        ],
      ),
    );
  }
}
