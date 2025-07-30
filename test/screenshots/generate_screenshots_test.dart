@Tags(["screenshots"])
library;

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:provider/provider.dart';
import 'package:urjaview_mobile/presentation/auth/screens/login_screen.dart';
import 'package:urjaview_mobile/presentation/dashboard/screens/dashboard_screen.dart';
import 'package:urjaview_mobile/presentation/meters/screens/meters_list_screen.dart';
import 'screenshot_utils.dart';

void main() {
  setUpAll(() async {
    // Ensure screenshots directory exists
    final dir = Directory('test/screenshots/goldens');
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
  });

  group('App Store Screenshots', () {
    final devices = [
      ScreenshotDevice.iPhone8Plus,
      ScreenshotDevice.iPhoneXsMax,
      ScreenshotDevice.iPadPro2ndGen,
      ScreenshotDevice.iPadPro6thGen,
    ];

    final locales = [
      const Locale('en', 'US'),
      const Locale('fr', 'FR'),
    ];

    for (final locale in locales) {
      for (final device in devices) {
        final langCode = locale.languageCode;
        final isTablet = device.name.contains('ipad');

        testGoldens('$langCode - ${device.name} - Login Screen', (tester) async {
          final pageName = '$langCode.${device.name}.01_login';

          // Take screenshot of login screen
          await takeScreenshot(
            tester: tester,
            widget: getScreenWrapper(
              child: const MockLoginScreen(),
              locale: locale,
              isAndroid: false,
            ),
            pageName: pageName,
            isFinal: false,
            sizeDp: device.sizeDp,
            density: device.density,
          );

          // Load and decorate screenshot
          final image = Image(image: loadScreenshotImage(pageName));
          final decoratedScreen = getDecoratedScreen(
            image: image,
            title: locale.languageCode == 'en' 
                ? 'Smart Meter Management' 
                : 'Gestion des Compteurs Intelligents',
            subtitle: locale.languageCode == 'en'
                ? 'Monitor and control your energy usage'
                : 'Surveillez et contrôlez votre consommation',
            isTablet: isTablet,
            locale: locale,
          );

          // Take final screenshot
          await takeScreenshot(
            tester: tester,
            widget: decoratedScreen,
            pageName: pageName,
            isFinal: true,
            sizeDp: device.sizeDp,
            density: device.density,
          );

          // Clean up
          deleteIntermediateScreenshot(pageName);
        });

        testGoldens('$langCode - ${device.name} - Dashboard', (tester) async {
          final pageName = '$langCode.${device.name}.02_dashboard';

          // Mock providers
          final mockAuthProvider = MockAuthProvider();
          
          // Take screenshot of dashboard
          await takeScreenshot(
            tester: tester,
            widget: getScreenWrapper(
              child: ChangeNotifierProvider.value(
                value: mockAuthProvider,
                child: const MockDashboardScreen(),
              ),
              locale: locale,
              isAndroid: false,
              overrides: [],
            ),
            pageName: pageName,
            isFinal: false,
            sizeDp: device.sizeDp,
            density: device.density,
          );

          // Load and decorate screenshot
          final image = Image(image: loadScreenshotImage(pageName));
          final decoratedScreen = getDecoratedScreen(
            image: image,
            title: locale.languageCode == 'en'
                ? 'Real-time Analytics'
                : 'Analyses en Temps Réel',
            subtitle: locale.languageCode == 'en'
                ? 'Track your energy consumption patterns'
                : 'Suivez vos habitudes de consommation',
            isTablet: isTablet,
            locale: locale,
          );

          // Take final screenshot
          await takeScreenshot(
            tester: tester,
            widget: decoratedScreen,
            pageName: pageName,
            isFinal: true,
            sizeDp: device.sizeDp,
            density: device.density,
          );

          // Clean up
          deleteIntermediateScreenshot(pageName);
        });

        testGoldens('$langCode - ${device.name} - Meters List', (tester) async {
          final pageName = '$langCode.${device.name}.03_meters';

          // Mock providers
          final mockAuthProvider = MockAuthProvider();
          final mockMeterProvider = MockMeterProvider();
          
          // Take screenshot of meters list
          await takeScreenshot(
            tester: tester,
            widget: getScreenWrapper(
              child: const MockMetersListWidget(),
              locale: locale,
              isAndroid: false,
              overrides: [
                ChangeNotifierProvider.value(value: mockAuthProvider),
                ChangeNotifierProvider.value(value: mockMeterProvider),
              ],
            ),
            pageName: pageName,
            isFinal: false,
            sizeDp: device.sizeDp,
            density: device.density,
            customPump: (tester) async => await tester.pump(const Duration(milliseconds: 200)),
          );

          // Load and decorate screenshot
          final image = Image(image: loadScreenshotImage(pageName));
          final decoratedScreen = getDecoratedScreen(
            image: image,
            title: locale.languageCode == 'en'
                ? 'Manage Your Meters'
                : 'Gérez Vos Compteurs',
            subtitle: locale.languageCode == 'en'
                ? 'Connect and monitor multiple devices'
                : 'Connectez et surveillez plusieurs appareils',
            isTablet: isTablet,
            locale: locale,
          );

          // Take final screenshot
          await takeScreenshot(
            tester: tester,
            widget: decoratedScreen,
            pageName: pageName,
            isFinal: true,
            sizeDp: device.sizeDp,
            density: device.density,
          );

          // Clean up
          deleteIntermediateScreenshot(pageName);
        });
      }
    }
  });

  group('Google Play Screenshots', () {
    final devices = [
      ScreenshotDevice.androidSmartphone,
      ScreenshotDevice.android7inchTablet,
      ScreenshotDevice.android10inchTablet,
    ];

    final locales = [
      const Locale('en', 'US'),
      const Locale('fr', 'FR'),
    ];

    for (final locale in locales) {
      for (final device in devices) {
        final langCode = locale.languageCode;
        final isTablet = device.name.contains('tablet');

        testGoldens('$langCode - ${device.name} - Login Screen', (tester) async {
          final pageName = '$langCode.${device.name}.01_login';

          // Take screenshot of login screen
          await takeScreenshot(
            tester: tester,
            widget: getScreenWrapper(
              child: const MockLoginScreen(),
              locale: locale,
              isAndroid: true,
            ),
            pageName: pageName,
            isFinal: false,
            sizeDp: device.sizeDp,
            density: device.density,
          );

          // Load and decorate screenshot
          final image = Image(image: loadScreenshotImage(pageName));
          final decoratedScreen = getDecoratedScreen(
            image: image,
            title: locale.languageCode == 'en' 
                ? 'Smart Meter Management' 
                : 'Gestion des Compteurs Intelligents',
            subtitle: locale.languageCode == 'en'
                ? 'Monitor and control your energy usage'
                : 'Surveillez et contrôlez votre consommation',
            isTablet: isTablet,
            locale: locale,
            backgroundColor: const Color(0xFFF5F5F5),
          );

          // Take final screenshot
          await takeScreenshot(
            tester: tester,
            widget: decoratedScreen,
            pageName: pageName,
            isFinal: true,
            sizeDp: device.sizeDp,
            density: device.density,
          );

          // Clean up
          deleteIntermediateScreenshot(pageName);
        });

        testGoldens('$langCode - ${device.name} - Dashboard', (tester) async {
          final pageName = '$langCode.${device.name}.02_dashboard';

          // Mock providers
          final mockAuthProvider = MockAuthProvider();
          
          // Take screenshot of dashboard
          await takeScreenshot(
            tester: tester,
            widget: getScreenWrapper(
              child: ChangeNotifierProvider.value(
                value: mockAuthProvider,
                child: const MockDashboardScreen(),
              ),
              locale: locale,
              isAndroid: true,
              overrides: [],
            ),
            pageName: pageName,
            isFinal: false,
            sizeDp: device.sizeDp,
            density: device.density,
          );

          // Load and decorate screenshot
          final image = Image(image: loadScreenshotImage(pageName));
          final decoratedScreen = getDecoratedScreen(
            image: image,
            title: locale.languageCode == 'en'
                ? 'Real-time Analytics'
                : 'Analyses en Temps Réel',
            subtitle: locale.languageCode == 'en'
                ? 'Track your energy consumption patterns'
                : 'Suivez vos habitudes de consommation',
            isTablet: isTablet,
            locale: locale,
            backgroundColor: const Color(0xFFF5F5F5),
          );

          // Take final screenshot
          await takeScreenshot(
            tester: tester,
            widget: decoratedScreen,
            pageName: pageName,
            isFinal: true,
            sizeDp: device.sizeDp,
            density: device.density,
          );

          // Clean up
          deleteIntermediateScreenshot(pageName);
        });

        testGoldens('$langCode - ${device.name} - Meters List', (tester) async {
          final pageName = '$langCode.${device.name}.03_meters';

          // Mock providers
          final mockAuthProvider = MockAuthProvider();
          final mockMeterProvider = MockMeterProvider();
          
          // Take screenshot of meters list
          await takeScreenshot(
            tester: tester,
            widget: getScreenWrapper(
              child: const MockMetersListWidget(),
              locale: locale,
              isAndroid: true,
              overrides: [
                ChangeNotifierProvider.value(value: mockAuthProvider),
                ChangeNotifierProvider.value(value: mockMeterProvider),
              ],
            ),
            pageName: pageName,
            isFinal: false,
            sizeDp: device.sizeDp,
            density: device.density,
            customPump: (tester) async => await tester.pump(const Duration(milliseconds: 200)),
          );

          // Load and decorate screenshot
          final image = Image(image: loadScreenshotImage(pageName));
          final decoratedScreen = getDecoratedScreen(
            image: image,
            title: locale.languageCode == 'en'
                ? 'Manage Your Meters'
                : 'Gérez Vos Compteurs',
            subtitle: locale.languageCode == 'en'
                ? 'Connect and monitor multiple devices'
                : 'Connectez et surveillez plusieurs appareils',
            isTablet: isTablet,
            locale: locale,
            backgroundColor: const Color(0xFFF5F5F5),
          );

          // Take final screenshot
          await takeScreenshot(
            tester: tester,
            widget: decoratedScreen,
            pageName: pageName,
            isFinal: true,
            sizeDp: device.sizeDp,
            density: device.density,
          );

          // Clean up
          deleteIntermediateScreenshot(pageName);
        });
      }
    }
  });
}