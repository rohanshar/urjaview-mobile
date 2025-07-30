import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:intl/intl.dart'; // Reserved for future use
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/meter_model.dart';
import '../providers/meter_provider.dart';

class MetersListScreen extends StatefulWidget {
  const MetersListScreen({super.key});

  @override
  State<MetersListScreen> createState() => _MetersListScreenState();
}

class _MetersListScreenState extends State<MetersListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MeterProvider>().loadMeters();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          // Header section
          Container(
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              border: Border(bottom: BorderSide(color: AppTheme.dividerColor)),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Manage and monitor your meter devices',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () {
                        context.read<MeterProvider>().loadMeters();
                      },
                      tooltip: 'Refresh',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Search bar
                TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search meters...',
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppTheme.textSecondary,
                    ),
                    suffixIcon:
                        _searchQuery.isNotEmpty
                            ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                            )
                            : null,
                    filled: true,
                    fillColor: AppTheme.backgroundColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ],
            ),
          ),
          // Meter list
          Expanded(
            child: Consumer<MeterProvider>(
              builder: (context, meterProvider, child) {
                if (meterProvider.isLoading && meterProvider.meters.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (meterProvider.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: AppTheme.errorColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading meters',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          meterProvider.error!,
                          style: TextStyle(color: AppTheme.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => meterProvider.loadMeters(),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                // Filter meters based on search
                final filteredMeters =
                    meterProvider.meters.where((meter) {
                      if (_searchQuery.isEmpty) return true;
                      return meter.name.toLowerCase().contains(_searchQuery) ||
                          meter.serialNumber.toLowerCase().contains(
                            _searchQuery,
                          ) ||
                          meter.meterIp.toLowerCase().contains(_searchQuery) ||
                          (meter.location?.toLowerCase().contains(
                                _searchQuery,
                              ) ??
                              false) ||
                          (meter.notes?.toLowerCase().contains(_searchQuery) ??
                              false);
                    }).toList();

                if (filteredMeters.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.electric_meter_outlined,
                          size: 64,
                          color: AppTheme.textSecondary.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty
                              ? 'No meters found'
                              : 'No meters match your search',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _searchQuery.isEmpty
                              ? 'Add meters to get started'
                              : 'Try a different search term',
                          style: TextStyle(color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => meterProvider.loadMeters(),
                  child: Column(
                    children: [
                      // Table header
                      Container(
                        color: AppTheme.surfaceColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                'METER DETAILS',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textSecondary,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'LOCATION / NOTES',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textSecondary,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 80,
                              child: Text(
                                'STATUS',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textSecondary,
                                  letterSpacing: 0.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Meter count
                      Container(
                        color: AppTheme.backgroundColor,
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Text(
                              '${filteredMeters.length} ${filteredMeters.length == 1 ? 'meter' : 'meters'} configured',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Meter list
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.only(bottom: 80),
                          itemCount: filteredMeters.length,
                          separatorBuilder:
                              (context, index) => Divider(
                                height: 1,
                                color: AppTheme.dividerColor,
                              ),
                          itemBuilder: (context, index) {
                            final meter = filteredMeters[index];
                            return _MeterListItem(meter: meter);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: AppTheme.primaryGradient,
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Add meter functionality coming soon'),
              ),
            );
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            'Add Meter',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

class _MeterListItem extends StatelessWidget {
  final MeterModel meter;

  const _MeterListItem({required this.meter});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.surfaceColor,
      child: InkWell(
        onTap: () {
          context.go('/meters/${meter.id}');
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Meter details
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            meter.serialNumber,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (meter.model != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              meter.model!,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.router_outlined,
                          size: 14,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatIpAddress(meter.meterIp),
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Location/Notes
              Expanded(
                flex: 2,
                child: Text(
                  meter.location ?? meter.notes ?? 'Unknown',
                  style: TextStyle(
                    fontSize: 14,
                    color:
                        meter.location != null || meter.notes != null
                            ? AppTheme.textPrimary
                            : AppTheme.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Status badges
              SizedBox(
                width: 80,
                child: Column(
                  children: [
                    _buildStatusBadge(meter.status),
                    if (meter.connectionStatus != null) ...[
                      const SizedBox(height: 4),
                      _buildConnectionBadge(meter.connectionStatus!),
                    ],
                  ],
                ),
              ),
              // Action button
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: AppTheme.textSecondary),
            ],
          ),
        ),
      ),
    );
  }

  String _formatIpAddress(String ip) {
    if (ip.contains(':')) {
      // IPv6 - show first 4 segments
      final segments = ip.split(':');
      if (segments.length > 4) {
        return '${segments.take(4).join(':')}...';
      }
    }
    return ip;
  }

  Widget _buildStatusBadge(String status) {
    final isActive = status.toLowerCase() == 'active';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color:
            isActive
                ? AppTheme.successColor.withValues(alpha: 0.1)
                : AppTheme.textSecondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isActive ? AppTheme.successColor : AppTheme.textSecondary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            isActive ? 'Active' : 'Inactive',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isActive ? AppTheme.successColor : AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionBadge(String status) {
    final isOnline = status.toLowerCase() == 'online';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.textPrimary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isOnline ? 'online' : 'offline',
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }
}
