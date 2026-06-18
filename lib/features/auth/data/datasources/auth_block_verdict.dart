import '../../../../core/error/app_exception.dart';

/// Maps a backend login `verdict` (the transport contract) to a domain
/// [BlockReason], or returns null when the verdict is not an account block
/// (the caller then treats it as a normal failure).
///
/// Lives in the data layer on purpose: the verdict string literals are a
/// backend API detail, so keeping them here — declared once, shared by every
/// auth data source — stops them from leaking into domain or presentation.
BlockReason? blockReasonFromVerdict(String? verdict) => switch (verdict) {
      'otp_limit_exceeded' => BlockReason.otpLimitExceeded,
      'account_is_deleted' => BlockReason.accountDeleted,
      _ => null,
    };

/// Whether a backend sign-up `verdict` means the phone is blocked from
/// registering (a hard stop shown full-screen). Kept here with the other
/// verdict literals so the transport contract stays in the data layer.
bool isPhoneBlockedVerdict(String? verdict) => verdict == 'phone_is_blocked';
