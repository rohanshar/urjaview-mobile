import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/meter_model.dart';
import '../providers/meter_provider.dart';

class MeterClockConfigScreen extends StatefulWidget {
  final String meterId;

  const MeterClockConfigScreen({
    super.key,
    required this.meterId,
  });

  @override
  State<MeterClockConfigScreen> createState() => _MeterClockConfigScreenState();
}

class _MeterClockConfigScreenState extends State<MeterClockConfigScreen> {
  bool _isReadingClock = false;
  bool _isSettingClock = false;
  String? _currentMeterTime;
  DateTime? _lastReadTime;
  String? _error;
  bool _useCurrentTime = true;
  DateTime _selectedDateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final meterProvider = context.watch<MeterProvider>();
    final meter = meterProvider.meters.firstWhere(
      (m) => m.id == widget.meterId,
      orElse: () => MeterModel(
        id: '',
        name: 'Unknown',
        serialNumber: '',
        meterIp: '',
        port: 0,
        status: 'unknown',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    if (meter.id.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Clock Configuration')),
        body: const Center(child: Text('Meter not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Clock Configuration'),
            Text(
              meter.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Clock Status
            _buildClockStatusCard(meter),
            const SizedBox(height: 20),

            // Read Clock Button
            _buildReadClockSection(),
            const SizedBox(height: 20),

            // Set Clock Section
            if (meter.canWrite) _buildSetClockSection(meter),
            
            // Info message for read-only meters
            if (!meter.canWrite) _buildReadOnlyMessage(),
          ],
        ),
      ),
    );
  }

  Widget _buildClockStatusCard(MeterModel meter) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.access_time, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                const Text(
                  'Meter Clock Status',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            if (_currentMeterTime != null) ...[
              _buildStatusRow('Meter Time', _currentMeterTime!),
              if (_lastReadTime != null)
                _buildStatusRow(
                  'Last Read',
                  DateFormat('MMM d, y h:mm:ss a').format(_lastReadTime!),
                ),
              const SizedBox(height: 8),
              _buildStatusRow(
                'System Time',
                DateFormat('MM/dd/yy HH:mm:ss').format(DateTime.now()),
              ),
            ] else ...[
              Text(
                'No clock data available',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Click "Read Clock" to fetch current meter time',
                style: TextStyle(fontSize: 14),
              ),
            ],
            
            if (_error != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.errorColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, 
                         color: AppTheme.errorColor, 
                         size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _error!,
                        style: TextStyle(
                          color: AppTheme.errorColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadClockSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Read Clock',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Fetch the current time from the meter',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isReadingClock || _isSettingClock 
                    ? null 
                    : _readMeterClock,
                icon: _isReadingClock
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.refresh),
                label: Text(_isReadingClock ? 'Reading...' : 'Read Clock'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSetClockSection(MeterModel meter) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Set Clock',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.warningColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'High Auth Required',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.warningColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Time selection mode
            RadioListTile<bool>(
              title: const Text('Use Current IST Time'),
              subtitle: Text(
                'Set to: ${DateFormat('MM/dd/yy HH:mm:ss').format(DateTime.now().toUtc().add(const Duration(hours: 5, minutes: 30)))} IST',
                style: const TextStyle(fontSize: 12),
              ),
              value: true,
              groupValue: _useCurrentTime,
              onChanged: (value) {
                setState(() {
                  _useCurrentTime = value!;
                });
              },
              contentPadding: EdgeInsets.zero,
            ),
            
            RadioListTile<bool>(
              title: const Text('Use Custom Time'),
              value: false,
              groupValue: _useCurrentTime,
              onChanged: (value) {
                setState(() {
                  _useCurrentTime = value!;
                });
              },
              contentPadding: EdgeInsets.zero,
            ),
            
            if (!_useCurrentTime) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isSettingClock ? null : _selectDate,
                      icon: const Icon(Icons.calendar_today, size: 20),
                      label: Text(
                        DateFormat('MMM d, y').format(_selectedDateTime),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isSettingClock ? null : _selectTime,
                      icon: const Icon(Icons.access_time, size: 20),
                      label: Text(
                        DateFormat('h:mm a').format(_selectedDateTime),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            
            const SizedBox(height: 16),
            
            // Warning message
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.warningColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.warning_amber_rounded, 
                       color: AppTheme.warningColor, 
                       size: 20),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'This operation takes 18-20 seconds. The meter may become unresponsive during this time.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isSettingClock || _isReadingClock 
                    ? null 
                    : () => _setMeterClock(meter),
                icon: _isSettingClock
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.update),
                label: Text(_isSettingClock ? 'Setting...' : 'Set Clock'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.warningColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyMessage() {
    return Card(
      color: Colors.blue.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.blue),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Read-Only Access',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'This meter does not have High authentication configured. Clock can only be read, not set.',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _selectedDateTime.hour,
          _selectedDateTime.minute,
        );
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );
    if (picked != null) {
      setState(() {
        _selectedDateTime = DateTime(
          _selectedDateTime.year,
          _selectedDateTime.month,
          _selectedDateTime.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  Future<void> _readMeterClock() async {
    setState(() {
      _isReadingClock = true;
      _error = null;
    });

    try {
      final meterProvider = context.read<MeterProvider>();
      final result = await meterProvider.readMeterClock(widget.meterId);
      
      if (mounted) {
        setState(() {
          _currentMeterTime = result['clock']?['formatted'] ?? 
                             result['clock']?['raw'] ?? 
                             'Unknown';
          _lastReadTime = DateTime.now();
          _isReadingClock = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString().replaceAll('Exception: ', '');
          _isReadingClock = false;
        });
      }
    }
  }

  Future<void> _setMeterClock(MeterModel meter) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Clock Update'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Are you sure you want to update the meter clock?'),
            const SizedBox(height: 16),
            Text(
              _useCurrentTime
                  ? 'New time: Current IST time'
                  : 'New time: ${DateFormat('MM/dd/yy HH:mm:ss').format(_selectedDateTime)}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.warningColor,
            ),
            child: const Text('Update Clock'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isSettingClock = true;
      _error = null;
    });

    try {
      // ignore: use_build_context_synchronously
      final meterProvider = context.read<MeterProvider>();
      final result = await meterProvider.setMeterClock(
        widget.meterId,
        useCurrentTime: _useCurrentTime,
        dateTime: _useCurrentTime ? null : _selectedDateTime,
      );
      
      if (mounted) {
        setState(() {
          _isSettingClock = false;
        });
        
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Clock set successfully'),
              backgroundColor: AppTheme.secondaryColor,
            ),
          );
        }
        
        // Automatically read clock to verify
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          _readMeterClock();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString().replaceAll('Exception: ', '');
          _isSettingClock = false;
        });
      }
    }
  }
}