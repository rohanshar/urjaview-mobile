import 'package:flutter/foundation.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/services/token_manager.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
  final TokenManager _tokenManager = TokenManager();

  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  AuthProvider(this._authRepository) {
    _checkAuthStatus();
    _setupTokenExpiryListener();
  }

  Future<void> _checkAuthStatus() async {
    _user = await _authRepository.getCurrentUser();
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _user = await _authRepository.login(email, password);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    _user = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setupTokenExpiryListener() {
    _tokenManager.setCallbacks(
      onTokenExpired: () async {
        // Token expired, force logout
        debugPrint('Token expired, forcing logout');
        await logout();
      },
    );
  }
}
