part of '../app_exception.dart';

/// A recoverable server-side failure (the user can usually retry). The UI
/// surfaces this as a snackbar — contrast with [AccountBlockedException], a
/// hard stop shown full-screen.
final class ServerException extends AppException {
  ServerException({
    super.code = AppErrorCode.server,
    String? message,
    this.statusCode,
    this.responseData,
  }) : super(serverMessage: message);

  final int? statusCode;
  final Object? responseData;

  /// Convenience for transport-level failures that carry an HTTP [statusCode].
  static ServerException withStatus(
    int statusCode, {
    AppErrorCode code = AppErrorCode.unknown,
    String? message,
    Object? responseData,
  }) =>
      ServerException(
        code: code,
        message: message,
        statusCode: statusCode,
        responseData: responseData,
      );
}
