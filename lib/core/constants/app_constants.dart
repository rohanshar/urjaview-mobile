class AppConstants {
  // API Configuration
  static const String baseUrl =
      'https://o4yw7npcx6.execute-api.ap-south-1.amazonaws.com/dev';
  static const Duration apiTimeout = Duration(seconds: 30);

  // App Info
  static const String appName = 'Urja View';
  static const String appTagline = 'Smart Meter Management';
  static const String companyName = 'Indotech Meters';
  static const String poweredBy = 'Powered by Indotech Meters';

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';

  // Asset Paths
  static const String logoPath = 'assets/images/urjaview-logo.svg';
  static const String indotechLogoPath = 'assets/images/indotech-logo.svg';
  static const String iconPath = 'assets/images/icon.png';

  // Error Messages
  static const String networkError = 'Please check your internet connection';
  static const String serverError = 'Something went wrong. Please try again';
  static const String sessionExpired =
      'Your session has expired. Please login again';

  // Regex Patterns
  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
}
