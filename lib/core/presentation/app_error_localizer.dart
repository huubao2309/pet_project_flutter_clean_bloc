import 'package:easy_localization/easy_localization.dart';

import '../error/app_error_code.dart';
import '../error/app_exception.dart';

/// The single place app errors become user-facing localized text.
///
/// Lives in the presentation layer on purpose: the data/domain layers raise a
/// typed [AppErrorCode] (plus an optional already-localized [AppException.serverMessage])
/// and never touch easy_localization. This mapper resolves them to copy — it is
/// the ONLY error path that calls `.tr()`. Resolving here (at display time) also
/// means the message honours the locale active when it is shown, not when the
/// error was thrown.
abstract final class AppErrorLocalizer {
  /// The user-facing message for [exception]: the backend's message when it
  /// provided one, otherwise the localized default for its [AppErrorCode].
  static String localize(AppException exception) =>
      exception.serverMessage ?? exception.code.localized;
}

extension AppErrorCodeLocalization on AppErrorCode {
  /// The localized copy for this error code (resolved via easy_localization).
  String get localized => _translationKey.tr();

  /// The translation key backing each code. Exhaustive so a new [AppErrorCode]
  /// fails to compile until it is given a key.
  String get _translationKey => switch (this) {
        AppErrorCode.unknown => 'errors.unknown',
        AppErrorCode.server => 'errors.server',
        AppErrorCode.network => 'errors.network',
        AppErrorCode.networkTimeout => 'errors.network_timeout',
        AppErrorCode.auth => 'errors.auth',
        AppErrorCode.cache => 'errors.cache',
        AppErrorCode.validation => 'errors.validation',
        AppErrorCode.accountBlocked => 'errors.unknown',
        AppErrorCode.phoneBlocked => 'errors.unknown',
        AppErrorCode.loginFailed => 'errors.login_failed',
        AppErrorCode.signupFailed => 'errors.signup_failed',
        AppErrorCode.forgotFailed => 'errors.forgot_failed',
        AppErrorCode.resetFailed => 'errors.reset_failed',
        AppErrorCode.verifyOtpFailed => 'errors.verify_otp_failed',
        AppErrorCode.registerPasswordFailed =>
          'errors.register_password_failed',
        AppErrorCode.logoutFailed => 'errors.logout_failed',
        AppErrorCode.changePasswordFailed => 'errors.change_failed',
      };
}
