part of '../app_exception.dart';

/// Why the backend refused to log the account in — each value is a hard stop
/// (the user cannot simply retry), surfaced full-screen rather than as a
/// snackbar. Add a value here when the backend introduces a new blocking case;
/// the exhaustive `switch` in the View will then force you to give it a
/// title/description.
///
/// This is a pure domain concept: it deliberately knows nothing about the
/// backend `verdict` strings. That transport contract — and the verdict→reason
/// mapping — lives in the data layer (`blockReasonFromVerdict`), so it never
/// leaks up into domain/presentation.
enum BlockReason {
  /// Too many wrong OTP entries (a temporary lock).
  otpLimitExceeded,

  /// The account no longer exists (permanent).
  accountDeleted,
}

/// The account is blocked by the backend (a hard stop) — see [BlockReason] for
/// the specific cause (too many wrong OTP entries, a deleted account, …).
///
/// Unlike a plain [ServerException] (a recoverable failure shown in a
/// snackbar), this is surfaced as a full-screen `AppErrorView`: the user is
/// blocked and cannot simply retry.
final class AccountBlockedException extends AppException {
  AccountBlockedException(this.reason, [String? message])
      : super(message ?? 'errors.unknown'.tr());

  final BlockReason reason;
}
