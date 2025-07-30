import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/meter_model.dart';

class MeterJobsTab extends StatelessWidget {
  final MeterModel meter;

  const MeterJobsTab({super.key, required this.meter});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.work_history,
            size: 64,
            color: AppTheme.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text('Job History', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'View job execution history and status',
            style: TextStyle(color: AppTheme.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Job history coming soon')),
              );
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh Jobs'),
          ),
        ],
      ),
    );
  }
}
