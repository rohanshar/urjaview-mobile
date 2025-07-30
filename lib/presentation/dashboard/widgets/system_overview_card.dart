import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../meters/providers/meter_provider.dart';

class SystemOverviewCard extends StatelessWidget {
  const SystemOverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    final meterProvider = context.watch<MeterProvider>();
    final totalMeters = meterProvider.meters.length;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'System Overview',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Quick access to system features',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          // Overview items
          _buildOverviewItem(
            'Company',
            'Not assigned',
          ),
          const SizedBox(height: 20),
          _buildOverviewItem(
            'Total Meters',
            totalMeters.toString(),
          ),
          const SizedBox(height: 20),
          _buildOverviewItem(
            'Jobs Today',
            '0',
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}