part of '../app_exception.dart';

/// A local persistence failure (secure storage, cache, etc.).
final class CacheException extends AppException {
  CacheException([String? message])
      : super(code: AppErrorCode.cache, serverMessage: message);
}
