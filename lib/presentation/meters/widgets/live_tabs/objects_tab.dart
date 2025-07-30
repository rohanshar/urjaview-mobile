import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/meter_model.dart';
import '../../providers/meter_provider.dart';

class ObjectsTab extends StatefulWidget {
  final MeterModel meter;

  const ObjectsTab({super.key, required this.meter});

  @override
  State<ObjectsTab> createState() => _ObjectsTabState();
}

class _ObjectsTabState extends State<ObjectsTab> {
  bool _isDiscovering = false;
  bool _isReading = false;
  Map<String, dynamic>? _discoveredObjects;
  Map<String, dynamic>? _readResults;
  String? _error;
  final Set<String> _selectedObjects = {};

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Discovery Card
          _buildDiscoveryCard(),
          const SizedBox(height: 16),

          // Results
          if (_error != null)
            _buildErrorCard(_error!),
          
          if (_discoveredObjects != null)
            _buildDiscoveredObjectsCard(),
            
          if (_readResults != null)
            _buildReadResultsCard(),
        ],
      ),
    );
  }

  Widget _buildDiscoveryCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.explore, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Object Discovery',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Discover available OBIS objects from the meter',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isDiscovering ? null : _discoverObjects,
                icon: _isDiscovering
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.search),
                label: Text(_isDiscovering ? 'Discovering...' : 'Discover Objects'),
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

  Widget _buildErrorCard(String error) {
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
                error,
                style: TextStyle(color: AppTheme.errorColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscoveredObjectsCard() {
    final objects = _discoveredObjects!['objects'] as List<dynamic>? ?? [];
    
    if (objects.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                Icons.info_outline,
                size: 48,
                color: AppTheme.textSecondary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 8),
              Text(
                'No objects discovered',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    // Group objects by type
    final groupedObjects = <String, List<dynamic>>{};
    for (final obj in objects) {
      final type = obj['type']?.toString() ?? 'Unknown';
      groupedObjects[type] ??= [];
      groupedObjects[type]!.add(obj);
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.category, color: AppTheme.primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      'Discovered Objects',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${objects.length} objects',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _selectedObjects.isEmpty ? null : _clearSelection,
                    icon: const Icon(Icons.clear),
                    label: Text('Clear (${_selectedObjects.length})'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _selectedObjects.isEmpty || _isReading ? null : _readSelectedObjects,
                    icon: _isReading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.download),
                    label: Text(_isReading ? 'Reading...' : 'Read Selected'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Object groups
            ...groupedObjects.entries.map((entry) => 
              _buildObjectGroup(entry.key, entry.value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildObjectGroup(String type, List<dynamic> objects) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(
          type,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${objects.length} objects',
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
        children: objects.map((obj) => _buildObjectItem(obj)).toList(),
      ),
    );
  }

  Widget _buildObjectItem(dynamic obj) {
    final obisCode = obj['obis_code']?.toString() ?? '';
    final description = obj['description']?.toString() ?? 'Unknown object';
    final isSelected = _selectedObjects.contains(obisCode);
    
    return ListTile(
      leading: Checkbox(
        value: isSelected,
        onChanged: (value) {
          setState(() {
            if (value == true) {
              _selectedObjects.add(obisCode);
            } else {
              _selectedObjects.remove(obisCode);
            }
          });
        },
      ),
      title: Text(
        obisCode,
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        description,
        style: TextStyle(
          fontSize: 12,
          color: AppTheme.textSecondary,
        ),
      ),
      dense: true,
    );
  }

  Widget _buildReadResultsCard() {
    final results = _readResults!['results'] as Map<String, dynamic>? ?? {};
    
    if (results.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                Icons.info_outline,
                size: 48,
                color: AppTheme.textSecondary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 8),
              Text(
                'No results',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.receipt_long, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Read Results',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Results table
            ...results.entries.map((entry) => _buildResultRow(
              entry.key,
              entry.value,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String obisCode, dynamic result) {
    final value = result['value']?.toString() ?? '--';
    final unit = result['unit']?.toString() ?? '';
    final scaler = result['scaler'];
    
    String displayValue = value;
    if (scaler != null && value != '--') {
      try {
        final numValue = double.parse(value);
        final scalerInt = int.parse(scaler.toString());
        final scaledValue = numValue * (scalerInt == 0 ? 1 : (10.0 * scalerInt));
        displayValue = scaledValue.toStringAsFixed(2);
      } catch (e) {
        // Keep original value if parsing fails
      }
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              obisCode,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
              ),
            ),
          ),
          Text(
            '$displayValue $unit',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _discoverObjects() async {
    setState(() {
      _isDiscovering = true;
      _error = null;
      _discoveredObjects = null;
      _readResults = null;
      _selectedObjects.clear();
    });

    try {
      final provider = context.read<MeterProvider>();
      final result = await provider.discoverObjects(widget.meter.id);
      
      setState(() {
        _discoveredObjects = result;
        _isDiscovering = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isDiscovering = false;
      });
    }
  }

  Future<void> _readSelectedObjects() async {
    if (_selectedObjects.isEmpty) return;
    
    setState(() {
      _isReading = true;
      _error = null;
      _readResults = null;
    });

    try {
      final provider = context.read<MeterProvider>();
      
      // Prepare objects for reading
      final objectsToRead = _selectedObjects.map((obisCode) {
        final obj = (_discoveredObjects!['objects'] as List<dynamic>)
            .firstWhere((o) => o['obis_code'] == obisCode);
        return {
          'obis_code': obisCode,
          'class_id': obj['class_id'],
          'attribute_id': obj['attribute_id'] ?? 2,
        };
      }).toList();
      
      final result = await provider.readMultipleObjects(
        widget.meter.id,
        objectsToRead,
      );
      
      setState(() {
        _readResults = result;
        _isReading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isReading = false;
      });
    }
  }

  void _clearSelection() {
    setState(() {
      _selectedObjects.clear();
    });
  }
}