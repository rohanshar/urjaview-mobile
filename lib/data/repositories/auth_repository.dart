import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/constants/app_constants.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthRepository {
  final ApiService _apiService;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthRepository(this._apiService);

  Future<UserModel?> getCurrentUser() async {
    final userData = await _storage.read(key: AppConstants.userKey);
    if (userData != null) {
      return UserModel.fromJson(jsonDecode(userData));
    }
    return null;
  }

  Future<UserModel> login(String email, String password) async {
    final response = await _apiService.login(email, password);

    // Parse user from JWT token
    final token = response['idToken'];
    final payload = _decodeJWT(token);
    final user = UserModel.fromJson(payload);

    // Store user data
    await _storage.write(
      key: AppConstants.userKey,
      value: jsonEncode(user.toJson()),
    );

    return user;
  }

  Future<void> logout() async {
    await _apiService.logout();
  }

  Future<bool> isAuthenticated() async {
    final token = await _storage.read(key: AppConstants.tokenKey);
    return token != null;
  }

  Map<String, dynamic> _decodeJWT(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid token');
    }

    final payload = parts[1];
    final normalized = base64Url.normalize(payload);
    final decoded = utf8.decode(base64Url.decode(normalized));

    return jsonDecode(decoded);
  }
}
