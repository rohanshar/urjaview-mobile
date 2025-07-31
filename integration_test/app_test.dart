import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'splash_screen_test.dart' as splash_tests;
import 'login_screen_test.dart' as login_tests;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    splash_tests.main();
    login_tests.main();
  });
}
