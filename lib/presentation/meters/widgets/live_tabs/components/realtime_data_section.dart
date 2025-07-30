import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class RealtimeDataSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Map<String, dynamic> data;
  final List<String> obisCodes;
  final String Function(String) getParameterName;

  const RealtimeDataSection({
    super.key,
    required this.title,
    required this.icon,
    required this.data,
    required this.obisCodes,
    required this.getParameterName,
  });

  @override
  Widget build(BuildContext context) {
    final sectionData = _getSectionData();

    if (sectionData.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppTheme.primaryColor, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...sectionData.map(
              (item) =>
                  _buildDataRow(context, item.label, item.value, item.unit),
            ),
          ],
        ),
      ),
    );
  }

  List<_DataItem> _getSectionData() {
    final List<_DataItem> sectionData = [];

    for (final obisCode in obisCodes) {
      if (data.containsKey(obisCode)) {
        final value = data[obisCode];
        if (value != null && value is Map) {
          final displayValue = value['value']?.toString() ?? 'N/A';
          final unit = value['unit']?.toString() ?? '';
          sectionData.add(
            _DataItem(getParameterName(obisCode), displayValue, unit),
          );
        }
      }
    }

    return sectionData;
  }

  Widget _buildDataRow(
    BuildContext context,
    String label,
    String value,
    String unit,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 4),
                Text(
                  unit,
                  style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _DataItem {
  final String label;
  final String value;
  final String unit;

  _DataItem(this.label, this.value, this.unit);
}
