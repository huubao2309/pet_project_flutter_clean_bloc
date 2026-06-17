part of '../app_exception.dart';

/// The session is invalid or has expired (e.g. a rejected token).
final class AuthException extends AppException {
  AuthException([String? message]) : super(message ?? 'errors.auth'.tr());
}
