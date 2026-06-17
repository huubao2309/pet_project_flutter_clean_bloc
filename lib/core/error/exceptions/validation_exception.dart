part of '../app_exception.dart';

/// Input failed validation at a system boundary.
final class ValidationException extends AppException {
  ValidationException([String? message])
      : super(message ?? 'errors.validation'.tr());
}
