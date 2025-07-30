import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/meter_model.dart';
import '../../providers/meter_provider.dart';
import 'components/realtime_progress_indicator.dart';
import 'components/realtime_data_section.dart';
import 'components/realtime_success_message.dart';
import 'components/realtime_obis_constants.dart';

class RealtimeTabV2 extends StatefulWidget {
  final MeterModel meter;

  const RealtimeTabV2({
    super.key,
    required this.meter,
  });

  @override
  State<RealtimeTabV2> createState() => _RealtimeTabV2State();
}

class _RealtimeTabV2State extends State<RealtimeTabV2> {
  bool _isLoading = false;
  Map<String, dynamic>? _realtimeData;
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
            RealtimeSuccessMessage(
              message: _successMessage!,
              onDismiss: () {
                setState(() {
                  _successMessage = null;
                });
              },
            ),
          
          // Real-time Data Display
          if (_isLoading)
            RealtimeProgressIndicator(
              currentOperation: _currentOperation,
              currentParameter: _currentParameter,
              currentChunk: _currentChunk,
              totalChunks: _totalChunks,
              processedParameters: _processedParameters,
              totalParameters: _totalParameters,
            )
          else if (_error != null)
            _buildErrorCard()
          else if (_realtimeData != null)
            _buildRealtimeDataDisplay()
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
                  'Real-time Data',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Fetch live electrical parameters from the meter',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _fetchRealtimeData,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.refresh),
                label: Text(_isLoading ? 'Fetching Data...' : 'Fetch Real-time Data'),
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
                  Icon(
                    Icons.schedule,
                    size: 14,
                    color: AppTheme.textSecondary,
                  ),
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
            Icon(
              Icons.error_outline,
              color: AppTheme.errorColor,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _error!,
                style: TextStyle(
                  color: AppTheme.errorColor,
                ),
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
            'No real-time data available',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Click "Fetch Real-time Data" to retrieve current values',
            style: TextStyle(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRealtimeDataDisplay() {
    if (_realtimeData == null || _realtimeData!['data'] == null) {
      return const SizedBox.shrink();
    }

    final data = _realtimeData!['data'] as Map<String, dynamic>;

    return Column(
      children: [
        // Metadata Card
        _buildMetadataCard(),
        const SizedBox(height: 16),
        
        // Data Sections
        RealtimeDataSection(
          title: 'Voltage',
          icon: Icons.electric_bolt,
          data: data,
          obisCodes: RealtimeObisConstants.voltageCodes,
          getParameterName: RealtimeObisConstants.getParameterName,
        ),
        const SizedBox(height: 16),
        
        RealtimeDataSection(
          title: 'Current',
          icon: Icons.show_chart,
          data: data,
          obisCodes: RealtimeObisConstants.currentCodes,
          getParameterName: RealtimeObisConstants.getParameterName,
        ),
        const SizedBox(height: 16),
        
        RealtimeDataSection(
          title: 'Power',
          icon: Icons.power,
          data: data,
          obisCodes: RealtimeObisConstants.activePowerCodes,
          getParameterName: RealtimeObisConstants.getParameterName,
        ),
        const SizedBox(height: 16),
        
        RealtimeDataSection(
          title: 'Power Factor',
          icon: Icons.analytics,
          data: data,
          obisCodes: RealtimeObisConstants.powerFactorCodes,
          getParameterName: RealtimeObisConstants.getParameterName,
        ),
        const SizedBox(height: 16),
        
        RealtimeDataSection(
          title: 'Frequency',
          icon: Icons.waves,
          data: data,
          obisCodes: RealtimeObisConstants.frequencyCodes,
          getParameterName: RealtimeObisConstants.getParameterName,
        ),
        const SizedBox(height: 16),
        
        RealtimeDataSection(
          title: 'Energy',
          icon: Icons.battery_charging_full,
          data: data,
          obisCodes: RealtimeObisConstants.energyCodes,
          getParameterName: RealtimeObisConstants.getParameterName,
        ),
        const SizedBox(height: 16),
        
        RealtimeDataSection(
          title: 'Reactive Power',
          icon: Icons.transform,
          data: data,
          obisCodes: RealtimeObisConstants.reactivePowerCodes,
          getParameterName: RealtimeObisConstants.getParameterName,
        ),
        const SizedBox(height: 16),
        
        RealtimeDataSection(
          title: 'Apparent Power',
          icon: Icons.electrical_services,
          data: data,
          obisCodes: RealtimeObisConstants.apparentPowerCodes,
          getParameterName: RealtimeObisConstants.getParameterName,
        ),
      ],
    );
  }

  Widget _buildMetadataCard() {
    final objectsRead = _realtimeData!['objectsRead'] ?? 0;
    final objectsRequested = _realtimeData!['objectsRequested'] ?? 0;
    final errors = _realtimeData!['errors'] as Map<String, dynamic>?;
    final duration = _realtimeData!['duration'] ?? 0;

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
                  errors?.isNotEmpty == true ? AppTheme.errorColor : AppTheme.textSecondary,
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

  Widget _buildMetadataItem(String label, String value, IconData icon, Color color) {
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
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
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

  Future<void> _fetchRealtimeData() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _currentOperation = 'Preparing to fetch data...';
      _currentChunk = 0;
      _totalChunks = 0;
      _processedParameters = 0;
      _totalParameters = RealtimeObisConstants.allCodes.length;
      _currentParameter = null;
    });

    try {
      final meterProvider = context.read<MeterProvider>();
      
      // Create chunks (4 OBIS codes per chunk)
      const chunkSize = 4;
      final chunks = <List<String>>[];
      
      for (var i = 0; i < RealtimeObisConstants.allCodes.length; i += chunkSize) {
        final end = (i + chunkSize < RealtimeObisConstants.allCodes.length)
            ? i + chunkSize
            : RealtimeObisConstants.allCodes.length;
        chunks.add(RealtimeObisConstants.allCodes.sublist(i, end));
      }
      
      setState(() {
        _totalChunks = chunks.length;
      });
      
      // Combined result
      final combinedData = {
        'data': <String, dynamic>{},
        'errors': <String, dynamic>{},
        'duration': 0,
        'objectsRequested': RealtimeObisConstants.allCodes.length,
        'objectsRead': 0,
      };
      
      // Process chunks sequentially
      for (var i = 0; i < chunks.length; i++) {
        final chunk = chunks[i];
        setState(() {
          _currentChunk = i + 1;
          _currentOperation = 'Reading chunk ${i + 1} of ${chunks.length}';
        });
        
        // Update current parameter being read
        for (final obisCode in chunk) {
          final parameterName = RealtimeObisConstants.getParameterName(obisCode);
          if (mounted) {
            setState(() {
              _currentParameter = parameterName;
            });
          }
          
          // Small delay to show parameter name
          await Future.delayed(const Duration(milliseconds: 50));
        }
        
        final result = await meterProvider.readMeterObjects(widget.meter.id, chunk);
        
        // Combine data
        if (result['data'] != null) {
          (combinedData['data'] as Map<String, dynamic>).addAll(result['data']);
        }
        
        // Combine errors
        if (result['errors'] != null) {
          (combinedData['errors'] as Map<String, dynamic>).addAll(result['errors']);
        }
        
        // Add duration
        combinedData['duration'] = (combinedData['duration'] as int) + (result['duration'] ?? 0);
        
        // Update objects read count
        combinedData['objectsRead'] = (combinedData['data'] as Map<String, dynamic>).length;
        
        // Update processed parameters count
        setState(() {
          _processedParameters += chunk.length;
        });
      }
      
      if (mounted) {
        setState(() {
          _realtimeData = combinedData;
          _lastUpdated = DateTime.now();
          _isLoading = false;
          _error = null;
          _currentOperation = null;
          _currentParameter = null;
          _successMessage = 'Successfully fetched ${combinedData['objectsRead']} of ${combinedData['objectsRequested']} parameters in ${((combinedData['duration'] as int) / 1000).toStringAsFixed(1)}s';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to fetch real-time data: ${e.toString()}';
          _isLoading = false;
          _currentOperation = null;
          _currentParameter = null;
        });
      }
    }
  }
}