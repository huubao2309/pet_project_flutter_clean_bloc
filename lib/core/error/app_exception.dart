import 'package:easy_localization/easy_localization.dart';

/// Base type for all app errors.
///
/// Default messages are resolved from the current app locale via
/// easy_localization's context-free `.tr()` (the global controller reflects the
/// active locale). Call sites may still pass an explicit, already-localized
/// message (e.g. one returned by the API).
sealed class AppException implements Exception {
  const AppException(this.message);
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

final class NetworkException extends AppException {
  NetworkException([String? message]) : super(message ?? 'errors.network'.tr());
}

final class AuthException extends AppException {
  AuthException([String? message]) : super(message ?? 'errors.auth'.tr());
}

final class ServerException extends AppException {
  ServerException({this.statusCode, String? message})
      : super(message ?? 'errors.server'.tr());

  final int? statusCode;

  static ServerException withCode(int code, [String? message]) =>
      ServerException(
        statusCode: code,
        message: message ?? 'errors.server'.tr(),
      );
}

final class CacheException extends AppException {
  CacheException([String? message]) : super(message ?? 'errors.cache'.tr());
}

final class ValidationException extends AppException {
  ValidationException([String? message])
      : super(message ?? 'errors.validation'.tr());
}
