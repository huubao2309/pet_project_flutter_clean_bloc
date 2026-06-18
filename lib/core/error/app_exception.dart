import 'package:easy_localization/easy_localization.dart';

part 'exceptions/account_blocked_exception.dart';
part 'exceptions/auth_exception.dart';
part 'exceptions/cache_exception.dart';
part 'exceptions/network_exception.dart';
part 'exceptions/phone_blocked_exception.dart';
part 'exceptions/server_exception.dart';
part 'exceptions/validation_exception.dart';

/// Base type for all app errors, and the root of this library.
///
/// `sealed`, so call sites can catch/switch exhaustively over the known error
/// kinds. Because `sealed` only permits subtypes within the same library, each
/// concrete exception is a `part` of this file (one small file per error kind,
/// under `exceptions/`) rather than a separate library. Add new ones there and
/// declare the `part` above.
///
/// Default messages are resolved from the current app locale via
/// easy_localization's context-free `.tr()` (the global controller reflects the
/// active locale). Call sites may still pass an explicit, already-localized
/// message (e.g. one returned by the API). The shared easy_localization import
/// lives here because part files cannot declare their own imports.
sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}
