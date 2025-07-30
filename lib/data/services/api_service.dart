import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/constants/app_constants.dart';
import 'token_manager.dart';

class ApiService {
  late final Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final TokenManager _tokenManager = TokenManager();

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: AppConstants.apiTimeout,
        receiveTimeout: AppConstants.apiTimeout,
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Add logging interceptor in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: true,
          responseHeader: true,
        ),
      );
    }

    _setupInterceptors();
    _setupTokenManager();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Debug log the request
          if (kDebugMode) {
            debugPrint('API Request: ${options.method} ${options.path}');
            debugPrint('Headers before processing: ${options.headers}');
          }

          // List of endpoints that don't require authentication
          final publicEndpoints = ['/auth/refresh', '/auth/signin'];

          // Check if this is a public endpoint
          final isPublicEndpoint = publicEndpoints.contains(options.path);

          if (isPublicEndpoint) {
            if (kDebugMode) {
              debugPrint('Skipping auth for endpoint: ${options.path}');
            }
            // Remove any existing Authorization header
            options.headers.remove('Authorization');
            options.headers.remove('authorization');
            handler.next(options);
            return;
          }

          // Add auth token to requests
          final token = await _tokenManager.getToken();
          if (token != null) {
            // Trim any whitespace from the token
            final trimmedToken = token.trim();

            // Ensure the token is properly formatted
            options.headers['Authorization'] = 'Bearer $trimmedToken';

            // Debug log to check token format
            if (kDebugMode) {
              final tokenPreview =
                  trimmedToken.length > 20
                      ? '${trimmedToken.substring(0, 20)}...'
                      : trimmedToken;
              debugPrint(
                'Setting auth header for ${options.path}: Bearer $tokenPreview',
              );
            }
          } else {
            if (kDebugMode) {
              debugPrint('No token available for ${options.path}');
            }
          }

          // Final debug log
          if (kDebugMode) {
            debugPrint('Final headers for ${options.path}: ${options.headers}');
          }

          handler.next(options);
        },
        onError: (error, handler) async {
          // Log error details for debugging
          if (kDebugMode && error.response != null) {
            debugPrint('Request failed: ${error.requestOptions.path}');
            debugPrint('Status: ${error.response?.statusCode}');
            debugPrint('Headers: ${error.requestOptions.headers}');
          }

          // Skip retry for refresh endpoint to avoid loops
          if (error.requestOptions.path == '/auth/refresh') {
            handler.next(error);
            return;
          }

          if (error.response?.statusCode == 401) {
            // Token expired, try to refresh
            final refreshToken = await _storage.read(
              key: AppConstants.refreshTokenKey,
            );
            if (refreshToken != null) {
              try {
                await refreshAuthToken(refreshToken);
                // Get the new token directly from storage to avoid recursive calls
                final newToken = await _storage.read(
                  key: AppConstants.tokenKey,
                );
                if (newToken != null) {
                  // Update the authorization header with new token
                  error.requestOptions.headers['Authorization'] =
                      'Bearer $newToken';
                }
                // Retry the request
                final response = await _dio.request(
                  error.requestOptions.path,
                  data: error.requestOptions.data,
                  options: Options(
                    method: error.requestOptions.method,
                    headers: error.requestOptions.headers,
                  ),
                );
                handler.resolve(response);
                return;
              } catch (e) {
                // Refresh failed, clear tokens
                await _tokenManager.clearTokens();
              }
            }
          }
          handler.next(error);
        },
      ),
    );
  }

  void _setupTokenManager() {
    _tokenManager.setCallbacks(
      onTokenRefreshed: (refreshToken) async {
        await refreshAuthToken(refreshToken);
      },
      onTokenExpired: () async {
        // Clear tokens and notify auth provider
        await _tokenManager.clearTokens();
      },
    );
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/signin',
        data: {'email': email, 'password': password},
      );

      final data = response.data['data'];

      // Debug log the token format
      if (kDebugMode) {
        final idToken = data['idToken'] as String?;
        if (idToken != null) {
          debugPrint('Login - Received token length: ${idToken.length}');
          debugPrint('Login - Token preview: ${idToken.substring(0, 20)}...');
        }
      }

      // Store tokens using token manager
      await _tokenManager.updateTokens(
        idToken: data['idToken'],
        refreshToken: data['refreshToken'],
      );

      // Start automatic token refresh
      await _tokenManager.startTokenRefreshTimer();

      return data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> logout() async {
    await _tokenManager.clearTokens();
  }

  Future<void> refreshAuthToken(String refreshToken) async {
    try {
      final response = await _dio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      final data = response.data['data'];

      // Update stored tokens using token manager
      await _tokenManager.updateTokens(
        idToken: data['idToken'],
        refreshToken: refreshToken,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Map<String, dynamic>>> getMeters() async {
    try {
      final response = await _dio.get('/meters');
      debugPrint('Meters API Response: ${response.data}'); // Debug log

      // Check if response has the expected structure
      if (response.data is Map &&
          response.data['data'] is Map &&
          response.data['data']['meters'] is List) {
        return List<Map<String, dynamic>>.from(response.data['data']['meters']);
      }

      // Fallback: check if data is directly a list
      if (response.data is Map && response.data['data'] is List) {
        return List<Map<String, dynamic>>.from(response.data['data']);
      }

      debugPrint(
        'Unexpected meters response format: ${response.data.runtimeType}',
      );
      return [];
    } on DioException catch (e) {
      debugPrint('Meters API Error: ${e.message}');
      debugPrint('Error Response: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getMeter(String meterId) async {
    try {
      final response = await _dio.get('/meters/$meterId');
      return response.data['data'];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> pingMeter(String meterId) async {
    try {
      final response = await _dio.post('/meters/$meterId/ping');
      debugPrint('Ping response: ${response.data}');
      if (response.data['success'] == true) {
        return response.data['data'] ?? {};
      } else {
        throw Exception(response.data['message'] ?? 'Ping failed');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> testMeterConnection(String meterId) async {
    try {
      final response = await _dio.post('/meters/$meterId/test-connection');
      debugPrint('Test connection response: ${response.data}');
      if (response.data['success'] == true) {
        return response.data['data'] ?? {};
      } else {
        throw Exception(response.data['message'] ?? 'Connection test failed');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> readMeterObjects(
    String meterId,
    List<String> obisCodes,
  ) async {
    try {
      final response = await _dio.post(
        '/meters/$meterId/read-objects',
        data: {'obisCodes': obisCodes},
      );
      debugPrint('Read objects response: ${response.data}');
      if (response.data['success'] == true) {
        return response.data['data'] ?? {};
      } else {
        throw Exception(response.data['message'] ?? 'Failed to read objects');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> readMeterClock(String meterId) async {
    try {
      final response = await _dio.get('/meters/$meterId/read-clock');
      debugPrint('Read clock response: ${response.data}');
      if (response.data['success'] == true) {
        return response.data['data'] ?? {};
      } else {
        throw Exception(response.data['message'] ?? 'Failed to read clock');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> setMeterClock(
    String meterId, {
    bool useCurrentTime = true,
    DateTime? dateTime,
  }) async {
    try {
      final data = <String, dynamic>{'useCurrentTime': useCurrentTime};

      if (!useCurrentTime && dateTime != null) {
        data['dateTime'] = dateTime.toIso8601String();
      }

      final response = await _dio.post(
        '/meters/$meterId/set-clock',
        data: data,
      );
      debugPrint('Set clock response: ${response.data}');
      if (response.data['success'] == true) {
        return response.data['data'] ?? {};
      } else {
        throw Exception(response.data['message'] ?? 'Failed to set clock');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> discoverObjects(String meterId) async {
    try {
      final response = await _dio.post('/meters/$meterId/discover-objects');
      debugPrint('Discover objects response: ${response.data}');
      if (response.data['success'] == true) {
        return response.data['data'] ?? {};
      } else {
        throw Exception(
          response.data['message'] ?? 'Failed to discover objects',
        );
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> readMultipleObjects(
    String meterId,
    List<Map<String, dynamic>> objects,
  ) async {
    try {
      final response = await _dio.post(
        '/meters/$meterId/read-multiple-objects',
        data: {'objects': objects},
      );
      debugPrint('Read multiple objects response: ${response.data}');
      if (response.data['success'] == true) {
        return response.data['data'] ?? {};
      } else {
        throw Exception(
          response.data['message'] ?? 'Failed to read multiple objects',
        );
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      return AppConstants.networkError;
    }

    if (error.response != null) {
      final statusCode = error.response!.statusCode;

      // Log error details for debugging
      if (kDebugMode) {
        debugPrint('API Error - Status: $statusCode');
        debugPrint('API Error - Response: ${error.response!.data}');
        debugPrint('API Error - Path: ${error.requestOptions.path}');
      }

      // Handle different response formats
      String? message;
      if (error.response!.data is Map) {
        final data = error.response!.data as Map<String, dynamic>;

        // Check for nested error object with message
        if (data['error'] is Map && data['error']['message'] != null) {
          message = data['error']['message'];
        } else {
          // Fallback to direct message field
          message = data['message'] ?? data['error']?.toString();
        }
      } else if (error.response!.data is String) {
        message = error.response!.data;
      }

      if (statusCode == 401) {
        return AppConstants.sessionExpired;
      }

      return message ?? AppConstants.serverError;
    }

    return AppConstants.serverError;
  }
}
