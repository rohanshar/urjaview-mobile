import 'package:flutter/material.dart';
import 'realtime_monitoring_illustration.dart';

export 'realtime_monitoring_illustration.dart';

class WelcomeIllustration extends StatelessWidget {
  const WelcomeIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background circle
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
              ],
            ),
          ),
        ),
        // Main meter icon
        Icon(
          Icons.electric_meter,
          size: 80,
          color: Theme.of(context).colorScheme.primary,
        ),
        // Floating elements
        Positioned(
          top: 20,
          right: 30,
          child: _buildFloatingElement(context, Icons.show_chart, Colors.blue),
        ),
        Positioned(
          bottom: 20,
          left: 30,
          child: _buildFloatingElement(
            context,
            Icons.phone_android,
            Colors.green,
          ),
        ),
        Positioned(
          top: 40,
          left: 20,
          child: _buildFloatingElement(
            context,
            Icons.cloud_sync,
            Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingElement(
    BuildContext context,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: 24, color: color),
    );
  }
}

// Use the new implementation from realtime_monitoring_illustration.dart
class RealtimeMonitoringIllustration extends RealtimeMonitoringIllustrationV2 {
  const RealtimeMonitoringIllustration({super.key});
}

class SchedulingIllustration extends StatelessWidget {
  const SchedulingIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Calendar grid
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.primaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(16),
          ),
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: 16,
            itemBuilder: (context, index) {
              final isScheduled = index % 3 == 0;
              return Container(
                decoration: BoxDecoration(
                  color:
                      isScheduled
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(4),
                ),
                child:
                    isScheduled
                        ? Icon(Icons.check, size: 12, color: Colors.white)
                        : null,
              );
            },
          ),
        ),
        // Clock overlay
        Positioned(
          bottom: -10,
          right: -10,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Icon(
              Icons.access_time,
              color: Theme.of(context).colorScheme.primary,
              size: 32,
            ),
          ),
        ),
      ],
    );
  }
}

class SecurityIllustration extends StatelessWidget {
  const SecurityIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Shield background
        Container(
          width: 180,
          height: 200,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.green.withValues(alpha: 0.3),
                Colors.green.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(80),
              topRight: Radius.circular(80),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
        ),
        // Lock icon
        Icon(Icons.lock, size: 60, color: Colors.green[700]),
        // Security badges
        Positioned(
          top: 20,
          left: 20,
          child: _buildSecurityBadge(context, Icons.verified_user),
        ),
        Positioned(
          top: 20,
          right: 20,
          child: _buildSecurityBadge(context, Icons.security),
        ),
        Positioned(
          bottom: 30,
          child: Text(
            'DLMS',
            style: TextStyle(
              color: Colors.green[700],
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityBadge(BuildContext context, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4),
        ],
      ),
      child: Icon(icon, size: 20, color: Colors.green[700]),
    );
  }
}
