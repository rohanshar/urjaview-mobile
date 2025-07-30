import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/meter_model.dart';

class MeterSettingsTab extends StatelessWidget {
  final MeterModel meter;

  const MeterSettingsTab({super.key, required this.meter});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSettingsSection(
            title: 'Connection Settings',
            icon: Icons.wifi,
            children: [
              _buildSettingTile(
                title: 'IP Address',
                subtitle: meter.meterIp,
                icon: Icons.language,
                onTap: () => _showEditDialog(context, 'IP Address'),
              ),
              _buildSettingTile(
                title: 'Port',
                subtitle: meter.port.toString(),
                icon: Icons.router,
                onTap: () => _showEditDialog(context, 'Port'),
              ),
              _buildSettingTile(
                title: 'Timeout',
                subtitle: '30 seconds',
                icon: Icons.timer,
                onTap: () => _showEditDialog(context, 'Timeout'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSettingsSection(
            title: 'Security Settings',
            icon: Icons.security,
            children: [
              _buildSettingTile(
                title: 'Authentication',
                subtitle: 'Low Level Security',
                icon: Icons.lock,
                onTap: () => _showEditDialog(context, 'Authentication'),
              ),
              _buildSettingTile(
                title: 'Client Address',
                subtitle: '16',
                icon: Icons.person,
                onTap: () => _showEditDialog(context, 'Client Address'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSettingsSection(
            title: 'Location',
            icon: Icons.location_on,
            children: [
              _buildSettingTile(
                title: 'Location',
                subtitle: 'Not set',
                icon: Icons.map,
                onTap: () => _showEditDialog(context, 'Location'),
              ),
              _buildSettingTile(
                title: 'Tags',
                subtitle: 'No tags',
                icon: Icons.label,
                onTap: () => _showEditDialog(context, 'Tags'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
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
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.textSecondary),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _showEditDialog(BuildContext context, String setting) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Edit $setting coming soon')));
  }
}
