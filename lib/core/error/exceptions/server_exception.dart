part of '../app_exception.dart';

/// A recoverable server-side failure (the user can usually retry). The UI
/// surfaces this as a snackbar — contrast with [AccountBlockedException], a
/// hard stop shown full-screen.
final class ServerException extends AppException {
  ServerException({
    this.statusCode,
    this.responseData,
    String? message,
  }) : super(message ?? 'errors.server'.tr());

  final int? statusCode;
  final Object? responseData;

  static ServerException withCode(int code, [String? message, Object? responseData]) => ServerException(
        statusCode: code,
        message: message ?? 'errors.server'.tr(),
        responseData: responseData,
      );
}
