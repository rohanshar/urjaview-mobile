import 'package:flutter/material.dart';
import '../models/onboarding_page_model.dart';
import 'custom_illustrations.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingPageModel page;

  const OnboardingPage({
    super.key,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: _getIllustrationForPage(page.title),
            ),
          ),
          const SizedBox(height: 48),
          // Title
          Text(
            page.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Description
          Text(
            page.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _getIllustrationForPage(String title) {
    if (title.contains('Welcome')) {
      return const WelcomeIllustration();
    } else if (title.contains('Real-time')) {
      return const RealtimeMonitoringIllustration();
    } else if (title.contains('Scheduling')) {
      return const SchedulingIllustration();
    } else if (title.contains('Secure')) {
      return const SecurityIllustration();
    }
    return const WelcomeIllustration();
  }
}