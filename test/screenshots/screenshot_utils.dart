import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:urjaview_mobile/data/models/user_model.dart';
import 'package:urjaview_mobile/data/models/meter_model.dart';
import 'test_theme.dart';

// Provider for platform-specific UI adjustments
final platformScreenshotProvider = Provider<bool?>.value(value: null);

// Screen sizes and densities for different devices
class ScreenshotDevice {
  final String name;
  final Size sizePx;
  final double density;

  const ScreenshotDevice({
    required this.name,
    required this.sizePx,
    required this.density,
  });

  Size get sizeDp => Size(sizePx.width / density, sizePx.height / density);

  static const androidSmartphone = ScreenshotDevice(
    name: 'android_smartphone',
    sizePx: Size(1107, 1968),
    density: 3,
  );

  static const android7inchTablet = ScreenshotDevice(
    name: 'android_tablet_7',
    sizePx: Size(1206, 2144),
    density: 2,
  );

  static const android10inchTablet = ScreenshotDevice(
    name: 'android_tablet_10',
    sizePx: Size(1449, 2576),
    density: 2,
  );

  static const iPadPro2ndGen = ScreenshotDevice(
    name: 'ipad_pro_2nd_gen',
    sizePx: Size(2048, 2732),
    density: 2,
  );

  static const iPadPro6thGen = ScreenshotDevice(
    name: 'IPAD_PRO_3GEN_129',
    sizePx: Size(2048, 2732),
    density: 2,
  );

  static const iPhone8Plus = ScreenshotDevice(
    name: 'iphone_8_plus',
    sizePx: Size(1242, 2208),
    density: 3,
  );

  static const iPhoneXsMax = ScreenshotDevice(
    name: 'iphone_xs_max',
    sizePx: Size(1242, 2688),
    density: 3,
  );
}

// Wrapper for the screen to add status bar and proper theming
Widget getScreenWrapper({
  required Widget child,
  required Locale locale,
  required bool isAndroid,
  List<InheritedProvider> overrides = const [],
}) {
  return MultiProvider(
    providers: [Provider<bool?>.value(value: isAndroid), ...overrides],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: const [Locale('en', 'US'), Locale('fr', 'FR')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      locale: locale,
      theme: TestAppTheme.lightTheme.copyWith(
        platform: isAndroid ? TargetPlatform.android : TargetPlatform.iOS,
      ),
      home: Column(
        children: [
          // Fake status bar
          Container(color: Colors.black, height: 24),
          // Main content
          Expanded(child: child),
        ],
      ),
    ),
  );
}

// Take a screenshot of a widget
Future<void> takeScreenshot({
  required WidgetTester tester,
  required Widget widget,
  required String pageName,
  required bool isFinal,
  required Size sizeDp,
  required double density,
  CustomPump? customPump,
}) async {
  await tester.pumpWidgetBuilder(widget);
  await multiScreenGolden(
    tester,
    pageName,
    customPump: customPump,
    devices: [
      Device(
        name: isFinal ? "final" : "screen",
        size: sizeDp,
        textScale: 1,
        devicePixelRatio: density,
      ),
    ],
  );
}

// Load screenshot image from file
MemoryImage loadScreenshotImage(String pageName) {
  final screenFile = File("test/screenshots/goldens/$pageName.screen.png");
  return MemoryImage(screenFile.readAsBytesSync());
}

// Delete intermediate screenshot
void deleteIntermediateScreenshot(String pageName) {
  final screenFile = File("test/screenshots/goldens/$pageName.screen.png");
  if (screenFile.existsSync()) {
    screenFile.deleteSync();
  }
}

// Mock authentication provider for screenshots
class MockAuthProvider extends ChangeNotifier {
  bool get isAuthenticated => true;

  String? get token => "mock_token";

  bool get isLoading => false;

  String? get error => null;

  UserModel? get user => UserModel(
    id: '1',
    email: 'test@example.com',
    name: 'Test User',
    role: 'user',
    clientId: 'test-client',
    companyId: '1',
  );

  Future<void> signIn(String email, String password) async {}

  Future<void> signOut() async {}

  Future<void> refreshToken() async {}

  void clearError() {}
}

// Mock meter provider for screenshots
class MockMeterProvider extends ChangeNotifier {
  List<MeterModel> get meters => [
    MeterModel(
      id: 'MTR-1234567890-abc',
      name: 'Main Building Meter',
      serialNumber: '98525130',
      meterIp: '2401:4900:9852:5130:0::2',
      port: 4059,
      status: 'active',
      manufacturer: 'Schneider Electric',
      model: 'EM6400',
      location: 'Building A, Floor 1',
      notes: 'Three phase power meter',
      connectionStatus: 'online',
      lastReadTime: DateTime.now().subtract(const Duration(minutes: 5)),
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    MeterModel(
      id: 'MTR-1234567891-def',
      name: 'Solar Panel Meter',
      serialNumber: '98525131',
      meterIp: '2401:4900:9852:5130:0::3',
      port: 4059,
      status: 'active',
      manufacturer: 'ABB',
      model: 'B23-212',
      location: 'Rooftop Installation',
      notes: 'Net metering for solar generation',
      connectionStatus: 'online',
      lastReadTime: DateTime.now().subtract(const Duration(minutes: 15)),
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
      updatedAt: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
  ];

  List<MeterModel> get filteredMeters => meters;

  bool get isLoading => false;

  String? get error => null;

  Future<void> fetchMeters() async {}

  Future<void> refreshMeters() async {}

  void searchMeters(String query) {}

  Future<void> pingMeter(String meterId) async {}

  Future<void> testMeterConnection(String meterId) async {}

  Future<void> loadMeters() async {}

  void clearError() {}
}

// Custom app bar back icon for screenshots
class AppBarBackIcon extends StatelessWidget {
  final bool? isAndroid;

  const AppBarBackIcon({super.key, this.isAndroid});

  @override
  Widget build(BuildContext context) {
    return Icon(
      isAndroid == true ? Icons.arrow_back_sharp : Icons.arrow_back_ios_sharp,
    );
  }
}

// Decorate screenshot with device frame and text
Widget getDecoratedScreen({
  required Widget image,
  required String title,
  required String subtitle,
  required bool isTablet,
  required Locale locale,
  Color backgroundColor = Colors.white,
}) {
  return Container(
    color: backgroundColor,
    child: Column(
      children: [
        const SizedBox(height: 40),
        // Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 10),
        // Subtitle
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            subtitle,
            style: TextStyle(
              fontSize: isTablet ? 20 : 18,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 30),
        // Screenshot
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: image,
              ),
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    ),
  );
}
