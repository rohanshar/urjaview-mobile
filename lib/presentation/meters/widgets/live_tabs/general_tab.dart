import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/meter_model.dart';
import '../../providers/meter_provider.dart';

class GeneralTab extends StatefulWidget {
  final MeterModel meter;

  const GeneralTab({super.key, required this.meter});

  @override
  State<GeneralTab> createState() => _GeneralTabState();
}

class _GeneralTabState extends State<GeneralTab> {
  bool _isPinging = false;
  bool _isTesting = false;
  Map<String, dynamic>? _pingResult;
  Map<String, dynamic>? _testResult;
  String? _pingError;
  String? _testError;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Connection Tests Section
          _buildConnectionTestsCard(),
          const SizedBox(height: 16),

          // Results Section
          if (_pingResult != null || _pingError != null) _buildPingResultCard(),

          if (_testResult != null || _testError != null) _buildTestResultCard(),
        ],
      ),
    );
  }

  Widget _buildConnectionTestsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.network_check, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Connection Tests',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Ping Test
            _buildTestSection(
              title: 'Ping Test',
              description: 'Check if the meter is reachable on the network',
              icon: Icons.network_ping,
              isLoading: _isPinging,
              onPressed: _pingMeter,
              buttonLabel: 'Ping Meter',
            ),

            const SizedBox(height: 16),

            // Connection Test
            _buildTestSection(
              title: 'DLMS Connection Test',
              description: 'Test DLMS/COSEM connection and authentication',
              icon: Icons.cable,
              isLoading: _isTesting,
              onPressed: _testConnection,
              buttonLabel: 'Test Connection',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestSection({
    required String title,
    required String description,
    required IconData icon,
    required bool isLoading,
    required VoidCallback onPressed,
    required String buttonLabel,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: AppTheme.textSecondary),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: isLoading ? null : onPressed,
            icon:
                isLoading
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                    : Icon(icon),
            label: Text(isLoading ? 'Testing...' : buttonLabel),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPingResultCard() {
    final isSuccess = _pingError == null;

    return Card(
      color:
          isSuccess
              ? AppTheme.successColor.withValues(alpha: 0.1)
              : AppTheme.errorColor.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isSuccess ? Icons.check_circle : Icons.error,
                  color:
                      isSuccess ? AppTheme.successColor : AppTheme.errorColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Ping Result',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                        isSuccess ? AppTheme.successColor : AppTheme.errorColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (isSuccess && _pingResult != null) ...[
              _buildResultRow('Status', 'Success'),
              if (_pingResult!['response_time'] != null)
                _buildResultRow(
                  'Response Time',
                  '${_pingResult!['response_time']} ms',
                ),
              if (_pingResult!['ip_address'] != null)
                _buildResultRow('IP Address', _pingResult!['ip_address']),
            ] else
              Text(
                _pingError ?? 'Unknown error',
                style: TextStyle(color: AppTheme.errorColor),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestResultCard() {
    final isSuccess = _testError == null;

    return Card(
      color:
          isSuccess
              ? AppTheme.successColor.withValues(alpha: 0.1)
              : AppTheme.errorColor.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isSuccess ? Icons.check_circle : Icons.error,
                  color:
                      isSuccess ? AppTheme.successColor : AppTheme.errorColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Connection Test Result',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                        isSuccess ? AppTheme.successColor : AppTheme.errorColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (isSuccess && _testResult != null) ...[
              _buildResultRow('Status', 'Connected'),
              if (_testResult!['auth_level'] != null)
                _buildResultRow('Auth Level', _testResult!['auth_level']),
              if (_testResult!['client_address'] != null)
                _buildResultRow(
                  'Client Address',
                  _testResult!['client_address'].toString(),
                ),
              if (_testResult!['logical_name'] != null)
                _buildResultRow('Logical Name', _testResult!['logical_name']),
              if (_testResult!['physical_address'] != null)
                _buildResultRow(
                  'Physical Address',
                  _testResult!['physical_address'].toString(),
                ),
            ] else
              Text(
                _testError ?? 'Unknown error',
                style: TextStyle(color: AppTheme.errorColor),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Future<void> _pingMeter() async {
    setState(() {
      _isPinging = true;
      _pingError = null;
      _pingResult = null;
    });

    try {
      final provider = context.read<MeterProvider>();
      final result = await provider.pingMeter(widget.meter.id);

      setState(() {
        _pingResult = result;
        _isPinging = false;
      });
    } catch (e) {
      setState(() {
        _pingError = e.toString();
        _isPinging = false;
      });
    }
  }

  Future<void> _testConnection() async {
    setState(() {
      _isTesting = true;
      _testError = null;
      _testResult = null;
    });

    try {
      final provider = context.read<MeterProvider>();
      final result = await provider.testMeterConnection(widget.meter.id);

      setState(() {
        _testResult = result;
        _isTesting = false;
      });
    } catch (e) {
      setState(() {
        _testError = e.toString();
        _isTesting = false;
      });
    }
  }
}
