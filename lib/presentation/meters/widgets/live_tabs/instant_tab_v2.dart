import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/meter_model.dart';
import '../../providers/meter_provider.dart';
import 'components/instant_progress_indicator.dart';
import 'components/instant_data_section.dart';
import 'components/instant_success_message.dart';
import 'components/instant_obis_constants.dart';

class InstantTabV2 extends StatefulWidget {
  final MeterModel meter;

  const InstantTabV2({super.key, required this.meter});

  @override
  State<InstantTabV2> createState() => _InstantTabV2State();
}

class _InstantTabV2State extends State<InstantTabV2> {
  bool _isLoading = false;
  Map<String, dynamic>? _instantData;
  String? _error;
  DateTime? _lastUpdated;

  // Progress tracking
  String? _currentOperation;
  int _currentChunk = 0;
  int _totalChunks = 0;
  int _processedParameters = 0;
  int _totalParameters = 0;
  String? _currentParameter;

  // Success message tracking
  String? _successMessage;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Connection Test Actions
          _buildConnectionActions(),
          const SizedBox(height: 24),

          // Success Message Display
          if (_successMessage != null && !_isLoading)
            InstantSuccessMessage(
              message: _successMessage!,
              onDismiss: () {
                setState(() {
                  _successMessage = null;
                });
              },
            ),

          // Instant Data Display
          if (_isLoading)
            InstantProgressIndicator(
              currentOperation: _currentOperation,
              currentParameter: _currentParameter,
              currentChunk: _currentChunk,
              totalChunks: _totalChunks,
              processedParameters: _processedParameters,
              totalParameters: _totalParameters,
            )
          else if (_error != null)
            _buildErrorCard()
          else if (_instantData != null)
            _buildInstantDataDisplay()
          else
            _buildEmptyState(),
        ],
      ),
    );
  }

  Widget _buildConnectionActions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.bolt, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Instant Readings',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Fetch live electrical parameters from the meter',
              style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _fetchInstantData,
                icon:
                    _isLoading
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                        : const Icon(Icons.refresh),
                label: Text(
                  _isLoading ? 'Fetching Data...' : 'Fetch Instant Data',
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            if (_lastUpdated != null) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.schedule, size: 14, color: AppTheme.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    'Last updated: ${_formatTime(_lastUpdated!)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard() {
    return Card(
      color: AppTheme.errorColor.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: AppTheme.errorColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _error!,
                style: TextStyle(color: AppTheme.errorColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 48),
          Icon(
            Icons.electrical_services,
            size: 64,
            color: AppTheme.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No instant data available',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Click "Fetch Instant Data" to retrieve current values',
            style: TextStyle(color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildInstantDataDisplay() {
    if (_instantData == null || _instantData!['data'] == null) {
      return const SizedBox.shrink();
    }

    final data = _instantData!['data'] as Map<String, dynamic>;

    return Column(
      children: [
        // Metadata Card
        _buildMetadataCard(),
        const SizedBox(height: 16),

        // Data Sections
        InstantDataSection(
          title: 'Voltage',
          icon: Icons.electric_bolt,
          data: data,
          obisCodes: InstantObisConstants.voltageCodes,
          getParameterName: InstantObisConstants.getParameterName,
        ),
        const SizedBox(height: 16),

        InstantDataSection(
          title: 'Current',
          icon: Icons.show_chart,
          data: data,
          obisCodes: InstantObisConstants.currentCodes,
          getParameterName: InstantObisConstants.getParameterName,
        ),
        const SizedBox(height: 16),

        InstantDataSection(
          title: 'Power',
          icon: Icons.power,
          data: data,
          obisCodes: InstantObisConstants.activePowerCodes,
          getParameterName: InstantObisConstants.getParameterName,
        ),
        const SizedBox(height: 16),

        InstantDataSection(
          title: 'Power Factor',
          icon: Icons.analytics,
          data: data,
          obisCodes: InstantObisConstants.powerFactorCodes,
          getParameterName: InstantObisConstants.getParameterName,
        ),
        const SizedBox(height: 16),

        InstantDataSection(
          title: 'Frequency',
          icon: Icons.waves,
          data: data,
          obisCodes: InstantObisConstants.frequencyCodes,
          getParameterName: InstantObisConstants.getParameterName,
        ),
        const SizedBox(height: 16),

        InstantDataSection(
          title: 'Energy',
          icon: Icons.battery_charging_full,
          data: data,
          obisCodes: InstantObisConstants.energyCodes,
          getParameterName: InstantObisConstants.getParameterName,
        ),
        const SizedBox(height: 16),

        InstantDataSection(
          title: 'Reactive Power',
          icon: Icons.transform,
          data: data,
          obisCodes: InstantObisConstants.reactivePowerCodes,
          getParameterName: InstantObisConstants.getParameterName,
        ),
        const SizedBox(height: 16),

        InstantDataSection(
          title: 'Apparent Power',
          icon: Icons.electrical_services,
          data: data,
          obisCodes: InstantObisConstants.apparentPowerCodes,
          getParameterName: InstantObisConstants.getParameterName,
        ),
      ],
    );
  }

  Widget _buildMetadataCard() {
    final objectsRead = _instantData!['objectsRead'] ?? 0;
    final objectsRequested = _instantData!['objectsRequested'] ?? 0;
    final errors = _instantData!['errors'] as Map<String, dynamic>?;
    final duration = _instantData!['duration'] ?? 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMetadataItem(
                  'Objects Read',
                  '$objectsRead / $objectsRequested',
                  Icons.check_circle,
                  AppTheme.successColor,
                ),
                _buildMetadataItem(
                  'Errors',
                  '${errors?.length ?? 0}',
                  Icons.error_outline,
                  errors?.isNotEmpty == true
                      ? AppTheme.errorColor
                      : AppTheme.textSecondary,
                ),
                _buildMetadataItem(
                  'Duration',
                  '${(duration / 1000).toStringAsFixed(1)}s',
                  Icons.timer,
                  AppTheme.primaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
        ),
      ],
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _fetchInstantData() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _currentOperation = 'Fetching instant values...';
      _currentChunk = 0;
      _totalChunks = 1;
      _processedParameters = 0;
      _totalParameters = InstantObisConstants.allCodes.length;
      _currentParameter = null;
    });

    try {
      final meterProvider = context.read<MeterProvider>();
      
      // Use the new instant values API
      final result = await meterProvider.readInstantValues(widget.meter.id);
      
      // The API returns data in the format we expect
      final combinedData = {
        'data': result,
        'errors': <String, dynamic>{},
        'duration': 1000, // Default duration since API doesn't return it
        'objectsRequested': InstantObisConstants.allCodes.length,
        'objectsRead': result.length,
      };

      if (mounted) {
        setState(() {
          _instantData = combinedData;
          _lastUpdated = DateTime.now();
          _isLoading = false;
          _error = null;
          _currentOperation = null;
          _currentParameter = null;
          _processedParameters = _totalParameters;
          _successMessage =
              'Successfully fetched ${combinedData['objectsRead']} instant values';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to fetch instant data: ${e.toString()}';
          _isLoading = false;
          _currentOperation = null;
          _currentParameter = null;
        });
      }
    }
  }
}
