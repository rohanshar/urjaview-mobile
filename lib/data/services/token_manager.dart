import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../core/constants/app_constants.dart';

class TokenManager {
  static final TokenManager _instance = TokenManager._internal();
  factory TokenManager() => _instance;
  TokenManager._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  Timer? _refreshTimer;
  Function(String)? _onTokenRefreshed;
  Function()? _onTokenExpired;
  bool _isRefreshing = false;

  // Set callbacks
  void setCallbacks({
    Function(String)? onTokenRefreshed,
    Function()? onTokenExpired,
  }) {
    _onTokenRefreshed = onTokenRefreshed;
    _onTokenExpired = onTokenExpired;
  }

  // Start automatic token refresh
  Future<void> startTokenRefreshTimer() async {
    await _scheduleNextRefresh();
  }

  // Stop automatic token refresh
  void stopTokenRefreshTimer() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  // Get current token
  Future<String?> getToken() async {
    final token = await _storage.read(key: AppConstants.tokenKey);
    
    if (token != null && isTokenExpired(token)) {
      // Prevent recursive refresh attempts
      if (_isRefreshing) {
        debugPrint('Token refresh already in progress, skipping...');
        return null;
      }
      
      debugPrint('Token expired, attempting refresh...');
      final refreshed = await attemptTokenRefresh();
      if (refreshed) {
        return await _storage.read(key: AppConstants.tokenKey);
      }
      return null;
    }
    
    return token;
  }

  // Check if token is expired
  bool isTokenExpired(String token) {
    try {
      return JwtDecoder.isExpired(token);
    } catch (e) {
      debugPrint('Error checking token expiry: $e');
      return true;
    }
  }

  // Get token expiry time
  DateTime? getTokenExpiry(String token) {
    try {
      final decodedToken = JwtDecoder.decode(token);
      final exp = decodedToken['exp'] as int?;
      if (exp != null) {
        return DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      }
    } catch (e) {
      debugPrint('Error decoding token: $e');
    }
    return null;
  }

  // Attempt to refresh token
  Future<bool> attemptTokenRefresh() async {
    if (_isRefreshing) {
      debugPrint('Token refresh already in progress');
      return false;
    }
    
    _isRefreshing = true;
    
    try {
      final refreshToken = await _storage.read(key: AppConstants.refreshTokenKey);
      if (refreshToken == null) {
        debugPrint('No refresh token available');
        _onTokenExpired?.call();
        return false;
      }

      // This will be called by the API service
      _onTokenRefreshed?.call(refreshToken);
      return true;
    } catch (e) {
      debugPrint('Token refresh failed: $e');
      _onTokenExpired?.call();
      return false;
    } finally {
      _isRefreshing = false;
    }
  }

  // Schedule next token refresh
  Future<void> _scheduleNextRefresh() async {
    _refreshTimer?.cancel();

    final token = await _storage.read(key: AppConstants.tokenKey);
    if (token == null) return;

    final expiry = getTokenExpiry(token);
    if (expiry == null) return;

    // Refresh 5 minutes before expiry
    final refreshTime = expiry.subtract(const Duration(minutes: 5));
    final now = DateTime.now();

    if (refreshTime.isAfter(now)) {
      final duration = refreshTime.difference(now);
      debugPrint('Scheduling token refresh in ${duration.inMinutes} minutes');

      _refreshTimer = Timer(duration, () async {
        debugPrint('Attempting scheduled token refresh...');
        final refreshed = await attemptTokenRefresh();
        if (refreshed) {
          // Schedule next refresh
          await _scheduleNextRefresh();
        }
      });
    } else {
      // Token is about to expire or already expired
      debugPrint('Token needs immediate refresh');
      await attemptTokenRefresh();
    }
  }

  // Update stored tokens and reschedule refresh
  Future<void> updateTokens({
    required String idToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: AppConstants.tokenKey, value: idToken);
    await _storage.write(key: AppConstants.refreshTokenKey, value: refreshToken);
    await _scheduleNextRefresh();
  }

  // Clear all tokens
  Future<void> clearTokens() async {
    stopTokenRefreshTimer();
    await _storage.deleteAll();
  }
}