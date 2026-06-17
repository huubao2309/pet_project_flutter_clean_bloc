part of '../app_exception.dart';

/// No / failed network connectivity while talking to the backend.
final class NetworkException extends AppException {
  NetworkException([String? message]) : super(message ?? 'errors.network'.tr());
}
