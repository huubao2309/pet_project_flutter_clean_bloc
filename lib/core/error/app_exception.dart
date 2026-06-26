import 'app_error_code.dart';

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
/// ── Localization ──────────────────────────────────────────────────────────
/// This layer stays free of any UI / localization framework (the Dependency
/// Rule). An exception carries a typed [code] for the default message and, when
/// the backend already returned user-facing text (localized server-side from
/// `Accept-Language`), an optional [serverMessage]. The presentation layer turns
/// these into copy: it shows [serverMessage] when present, otherwise maps [code]
/// to a localized string. Nothing here calls `.tr()`.
sealed class AppException implements Exception {
  const AppException({required this.code, this.serverMessage});

  /// The stable, machine-readable cause — mapped to localized text in the
  /// presentation layer.
  final AppErrorCode code;

  /// A user-facing message already returned (and localized) by the backend, or
  /// null. When set, the presentation layer prefers it over the [code] default.
  final String? serverMessage;

  @override
  String toString() => '$runtimeType(code: $code, serverMessage: $serverMessage)';
}
