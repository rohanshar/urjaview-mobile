import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class MeterStatusChart extends StatelessWidget {
  final int activeCount;
  final int inactiveCount;
  final int faultyCount;

  const MeterStatusChart({
    super.key,
    required this.activeCount,
    required this.inactiveCount,
    required this.faultyCount,
  });

  @override
  Widget build(BuildContext context) {
    final total = activeCount + inactiveCount + faultyCount;
    
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
            'Meter Status Distribution',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Current status of all meters in the system',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          // Status list
          _buildStatusItem(
            context,
            'Active',
            activeCount,
            AppTheme.successColor,
          ),
          const SizedBox(height: 16),
          _buildStatusItem(
            context,
            'Inactive',
            inactiveCount,
            AppTheme.textSecondary,
          ),
          const SizedBox(height: 16),
          _buildStatusItem(
            context,
            'Faulty/Error',
            faultyCount,
            AppTheme.errorColor,
          ),
          if (total == 0) ...[
            const SizedBox(height: 32),
            Center(
              child: Text(
                'No meters in the system',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusItem(
    BuildContext context,
    String label,
    int count,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}