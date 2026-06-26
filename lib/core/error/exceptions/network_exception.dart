part of '../app_exception.dart';

/// No / failed network connectivity while talking to the backend. Defaults to
/// [AppErrorCode.network]; pass [AppErrorCode.networkTimeout] for timeouts.
final class NetworkException extends AppException {
  NetworkException({super.code = AppErrorCode.network, String? message})
      : super(serverMessage: message);
}
