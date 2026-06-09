import 'package:dio/dio.dart';

import '../../storage/secure_storage.dart';

/// Attaches the Bearer token to every outgoing request and handles 401 errors.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({required this.secureStorage});

  final SecureStorage secureStorage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await secureStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // TODO: trigger token refresh flow or broadcast logout event
    }
    handler.next(err);
  }
}
