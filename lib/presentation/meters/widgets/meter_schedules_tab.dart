import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/meter_model.dart';

class MeterSchedulesTab extends StatelessWidget {
  final MeterModel meter;

  const MeterSchedulesTab({super.key, required this.meter});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.schedule,
            size: 64,
            color: AppTheme.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text('Schedules', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Manage automated tasks and schedules',
            style: TextStyle(color: AppTheme.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Schedule management coming soon'),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Create Schedule'),
          ),
        ],
      ),
    );
  }
}
