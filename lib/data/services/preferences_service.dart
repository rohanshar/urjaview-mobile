import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _isFirstTimeKey = 'is_first_time';
  static const String _hasCompletedOnboardingKey = 'has_completed_onboarding';

  final SharedPreferences _prefs;

  PreferencesService(this._prefs);

  static Future<PreferencesService> getInstance() async {
    final prefs = await SharedPreferences.getInstance();
    return PreferencesService(prefs);
  }

  bool get isFirstTime => _prefs.getBool(_isFirstTimeKey) ?? true;

  bool get hasCompletedOnboarding =>
      _prefs.getBool(_hasCompletedOnboardingKey) ?? false;

  Future<void> setFirstTime(bool value) async {
    await _prefs.setBool(_isFirstTimeKey, value);
  }

  Future<void> setOnboardingCompleted(bool value) async {
    await _prefs.setBool(_hasCompletedOnboardingKey, value);
  }

  Future<void> completeOnboarding() async {
    await setFirstTime(false);
    await setOnboardingCompleted(true);
  }
}
