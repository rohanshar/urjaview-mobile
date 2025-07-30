import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/meter_model.dart';
import '../providers/meter_provider.dart';

class MeterOverviewTab extends StatefulWidget {
  final MeterModel meter;

  const MeterOverviewTab({super.key, required this.meter});

  @override
  State<MeterOverviewTab> createState() => _MeterOverviewTabState();
}

class _MeterOverviewTabState extends State<MeterOverviewTab> {
  bool _isLoadingStats = false;
  Map<String, dynamic>? _quickStats;

  @override
  void initState() {
    super.initState();
    _loadQuickStats();
  }

  Future<void> _loadQuickStats() async {
    if (!mounted) return;

    setState(() {
      _isLoadingStats = true;
    });

    try {
      final meterProvider = context.read<MeterProvider>();
      // Load some basic real-time data for quick stats
      final data = await meterProvider.readMeterObjects(widget.meter.id, [
        '1.0.32.7.0.255', // L1 Voltage
        '1.0.31.7.0.255', // L1 Current
        '1.0.1.7.0.255', // Active Power
        '1.0.1.8.0.255', // Import Energy
      ]);

      if (mounted) {
        setState(() {
          _quickStats = data;
          _isLoadingStats = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingStats = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadQuickStats,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            _buildStatusCard(widget.meter),
            const SizedBox(height: 16),

            // Quick Stats
            if (_isLoadingStats)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ),
              )
            else
              _buildQuickStats(),
            const SizedBox(height: 16),

            // Device Information
            _buildInfoCard(
              title: 'Device Information',
              icon: Icons.device_hub,
              children: [
                _buildInfoRow('Serial Number', widget.meter.serialNumber),
                _buildInfoRow('Name', widget.meter.name),
                _buildInfoRow('Status', widget.meter.status.toUpperCase()),
              ],
            ),
            const SizedBox(height: 16),

            // Connection Details
            _buildInfoCard(
              title: 'Connection Details',
              icon: Icons.wifi,
              children: [
                _buildInfoRow('IP Address', widget.meter.meterIp),
                _buildInfoRow('Port', widget.meter.port.toString()),
                _buildInfoRow('Protocol', 'DLMS/COSEM'),
                if (widget.meter.manufacturer != null)
                  _buildInfoRow('Manufacturer', widget.meter.manufacturer!),
              ],
            ),
            const SizedBox(height: 16),

            // Authentication Details
            if (widget.meter.authentication != null) ...[
              _buildInfoCard(
                title: 'Authentication',
                icon: Icons.security,
                children: [
                  _buildInfoRow('Auth Level', widget.meter.authLevel),
                  if (widget.meter.authentication!.hasHighAuth)
                    _buildInfoRow('Write Access', 'Enabled'),
                  if (widget.meter.authentication!.hasLowAuth)
                    _buildInfoRow('Read Access', 'Enabled'),
                  if (widget.meter.authentication!.hasNoneAuth)
                    _buildInfoRow('Public Access', 'Enabled'),
                ],
              ),
              const SizedBox(height: 16),
            ],

            // Recent Activity
            if (widget.meter.lastSyncTime != null) ...[
              _buildInfoCard(
                title: 'Recent Activity',
                icon: Icons.history,
                children: [
                  _buildInfoRow(
                    'Last Sync',
                    DateFormat(
                      'MMM d, y h:mm a',
                    ).format(DateTime.parse(widget.meter.lastSyncTime!)),
                  ),
                  if (widget.meter.lastSyncData != null &&
                      widget.meter.lastSyncData!['dataPoints'] != null)
                    _buildInfoRow(
                      'Data Points',
                      widget.meter.lastSyncData!['dataPoints'].toString(),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(MeterModel meter) {
    Color backgroundColor;
    Color textColor;
    IconData icon;
    String statusText;

    switch (meter.status.toLowerCase()) {
      case 'active':
        backgroundColor = AppTheme.successColor.withValues(alpha: 0.1);
        textColor = AppTheme.successColor;
        icon = Icons.check_circle;
        statusText = 'Active';
        break;
      case 'inactive':
        backgroundColor = AppTheme.textSecondary.withValues(alpha: 0.1);
        textColor = AppTheme.textSecondary;
        icon = Icons.remove_circle_outline;
        statusText = 'Inactive';
        break;
      case 'faulty':
        backgroundColor = AppTheme.errorColor.withValues(alpha: 0.1);
        textColor = AppTheme.errorColor;
        icon = Icons.error_outline;
        statusText = 'Faulty';
        break;
      default:
        backgroundColor = AppTheme.textSecondary.withValues(alpha: 0.1);
        textColor = AppTheme.textSecondary;
        icon = Icons.help_outline;
        statusText = meter.status.toUpperCase();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, size: 32, color: textColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    final hasData = _quickStats != null && _quickStats!['data'] != null;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          title: 'Voltage',
          value:
              hasData && _quickStats!['data']['1.0.32.7.0.255'] != null
                  ? _getScaledValue(_quickStats!['data']['1.0.32.7.0.255'])
                  : '--',
          unit: 'V',
          icon: Icons.electric_bolt,
          color: AppTheme.infoColor,
        ),
        _buildStatCard(
          title: 'Current',
          value:
              hasData && _quickStats!['data']['1.0.31.7.0.255'] != null
                  ? _getScaledValue(_quickStats!['data']['1.0.31.7.0.255'])
                  : '--',
          unit: 'A',
          icon: Icons.electrical_services,
          color: AppTheme.primaryColor,
        ),
        _buildStatCard(
          title: 'Power',
          value:
              hasData && _quickStats!['data']['1.0.1.7.0.255'] != null
                  ? _getScaledValue(_quickStats!['data']['1.0.1.7.0.255'])
                  : '--',
          unit: 'kW',
          icon: Icons.power,
          color: AppTheme.secondaryColor,
        ),
        _buildStatCard(
          title: 'Energy',
          value:
              hasData && _quickStats!['data']['1.0.1.8.0.255'] != null
                  ? _getScaledValue(_quickStats!['data']['1.0.1.8.0.255'])
                  : '--',
          unit: 'kWh',
          icon: Icons.battery_charging_full,
          color: AppTheme.warningColor,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String unit,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 4),
                Text(
                  title,
                  style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                ),
              ],
            ),
            const Spacer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  unit,
                  style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _getScaledValue(dynamic dataObj) {
    if (dataObj == null || dataObj['value'] == null) return '--';

    String value = dataObj['value'].toString();

    // Apply scaler if present
    if (dataObj['scaler'] != null) {
      try {
        double numValue = double.parse(value);
        int scaler = int.parse(dataObj['scaler'].toString());
        // Scaler is power of 10: -3 means multiply by 10^-3 (0.001)
        double scaledValue =
            numValue * (scaler == 0 ? 1 : pow(10, scaler).toDouble());
        value = scaledValue.toStringAsFixed(2);
      } catch (e) {
        // Keep original value if parsing fails
      }
    }

    return value;
  }
}
