import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../data/services/preferences_service.dart';
import '../models/onboarding_page_model.dart';
import '../widgets/onboarding_page.dart';
import '../widgets/page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isLoading = false;

  final List<OnboardingPageModel> _pages = [
    const OnboardingPageModel(
      title: 'Welcome to Urja View',
      description:
          'Your comprehensive smart meter management solution. Monitor and control your energy infrastructure with ease.',
      imagePath: 'assets/images/onboarding_1.png',
    ),
    const OnboardingPageModel(
      title: 'Real-time Monitoring',
      description:
          'Track energy consumption, voltage, current, and power factor in real-time. Get instant insights into your meter performance.',
      imagePath: 'assets/images/onboarding_2.png',
    ),
    const OnboardingPageModel(
      title: 'Intelligent Scheduling',
      description:
          'Schedule meter readings, create automated jobs, and manage your entire meter fleet efficiently from one platform.',
      imagePath: 'assets/images/onboarding_3.png',
    ),
    const OnboardingPageModel(
      title: 'Secure & Reliable',
      description:
          'Built with enterprise-grade security and DLMS protocol compliance. Your data is always protected and accessible.',
      imagePath: 'assets/images/onboarding_4.png',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    setState(() {
      _isLoading = true;
    });

    final prefsService = await PreferencesService.getInstance();
    await prefsService.completeOnboarding();

    if (!mounted) return;

    context.go('/login');
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Skip button
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (_currentPage < _pages.length - 1 && !_isLoading)
                        TextButton(
                          onPressed: _skipOnboarding,
                          child: Text(
                            'Skip',
                            style: TextStyle(
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                              fontSize: 16,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // Page content
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      return OnboardingPage(page: _pages[index]);
                    },
                  ),
                ),
                // Bottom section with indicators and button
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      PageIndicator(
                        pageCount: _pages.length,
                        currentPage: _currentPage,
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child:
                            _isLoading
                                ? Center(
                                  child:
                                      LoadingAnimationWidget.threeArchedCircle(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                        size: 40,
                                      ),
                                )
                                : ElevatedButton(
                                  onPressed: _nextPage,
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    _currentPage < _pages.length - 1
                                        ? 'Next'
                                        : 'Get Started',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
