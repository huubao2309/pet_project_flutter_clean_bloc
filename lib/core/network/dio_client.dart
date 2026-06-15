import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../environments/env_type.dart';
import '../error/app_exception.dart';
import 'api_response.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import '../storage/secure_storage/secure_storage.dart';

class DioClient {
  DioClient({
    required String baseUrl,
    required SecureStorage secureStorage,
    required EnvType envType,
  }) : _dio = _build(baseUrl, secureStorage, envType);

  final Dio _dio;

  static Dio _build(
    String baseUrl,
    SecureStorage secureStorage,
    EnvType envType,
  ) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: const {'Content-Type': 'application/json'},
      ),
    );
    dio.interceptors.addAll([
      AuthInterceptor(secureStorage: secureStorage),
      if (!envType.isProduction) LoggingInterceptor(),
    ]);
    return dio;
  }

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(Object?)? fromJson,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
      );
      return _parse(response, fromJson);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    Object? data,
    T Function(Object?)? fromJson,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(path, data: data);
      return _parse(response, fromJson);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<ApiResponse<T>> put<T>(
    String path, {
    Object? data,
    T Function(Object?)? fromJson,
  }) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(path, data: data);
      return _parse(response, fromJson);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<ApiResponse<T>> delete<T>(String path) async {
    try {
      final response = await _dio.delete<Map<String, dynamic>>(path);
      return _parse(response, null);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  ApiResponse<T> _parse<T>(
    Response<Map<String, dynamic>> response,
    T Function(Object?)? fromJson,
  ) {
    final body = response.data ?? {};
    return ApiResponse<T>(
      success: response.statusCode != null && response.statusCode! < 400,
      data: fromJson != null && body['data'] != null
          ? fromJson(body['data'])
          : null,
      message: body['message'] as String?,
      statusCode: response.statusCode,
      meta: body['meta'] as Map<String, dynamic>?,
    );
  }

  AppException _mapDioError(DioException e) {
    if (e.response?.statusCode == 401) {
      return AuthException();
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return NetworkException('errors.network_timeout'.tr());
    }
    if (e.type == DioExceptionType.connectionError) {
      return NetworkException();
    }
    return ServerException.withCode(
      e.response?.statusCode ?? 500,
      e.message ?? 'errors.unknown'.tr(),
    );
  }
}
