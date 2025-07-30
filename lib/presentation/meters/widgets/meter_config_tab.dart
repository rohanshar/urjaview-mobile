import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/meter_model.dart';

class MeterConfigTab extends StatelessWidget {
  final MeterModel meter;

  const MeterConfigTab({
    super.key,
    required this.meter,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Clock Configuration
        _buildConfigCard(
          context: context,
          icon: Icons.access_time,
          title: 'Clock Configuration',
          subtitle: 'Read and set meter time',
          color: AppTheme.primaryColor,
          onTap: () => context.go('/meters/${meter.id}/config/clock'),
          canAccess: true, // Read is available for all auth levels
          canWrite: meter.canWrite, // Set requires high auth
        ),
        const SizedBox(height: 12),
        
        // More config options can be added here
        _buildConfigCard(
          context: context,
          icon: Icons.network_check,
          title: 'Communication Settings',
          subtitle: 'Configure meter communication parameters',
          color: AppTheme.infoColor,
          onTap: () => _showComingSoon(context, 'Communication Settings'),
          canAccess: meter.canWrite,
          canWrite: meter.canWrite,
        ),
        const SizedBox(height: 12),
        
        _buildConfigCard(
          context: context,
          icon: Icons.electrical_services,
          title: 'Energy Parameters',
          subtitle: 'Configure energy measurement settings',
          color: AppTheme.secondaryColor,
          onTap: () => _showComingSoon(context, 'Energy Parameters'),
          canAccess: meter.canWrite,
          canWrite: meter.canWrite,
        ),
        const SizedBox(height: 12),
        
        _buildConfigCard(
          context: context,
          icon: Icons.security,
          title: 'Security Settings',
          subtitle: 'Manage meter authentication and security',
          color: AppTheme.errorColor,
          onTap: () => _showComingSoon(context, 'Security Settings'),
          canAccess: meter.canWrite,
          canWrite: meter.canWrite,
        ),
      ],
    );
  }

  Widget _buildConfigCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    required bool canAccess,
    required bool canWrite,
  }) {
    final isDisabled = !canAccess;
    
    return Card(
      elevation: isDisabled ? 0 : 2,
      color: isDisabled ? AppTheme.surfaceVariant : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isDisabled 
            ? BorderSide(color: AppTheme.borderColor)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: isDisabled ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isDisabled 
                      ? Colors.grey[300] 
                      : color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: isDisabled ? Colors.grey : color,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isDisabled ? Colors.grey : null,
                          ),
                        ),
                        if (!canWrite && canAccess) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Read Only',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDisabled 
                            ? Colors.grey 
                            : AppTheme.textSecondary,
                      ),
                    ),
                    if (isDisabled) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Requires High authentication',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red[400],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: isDisabled 
                    ? Colors.grey 
                    : AppTheme.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature - Coming Soon'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}