/// Timer parameters for the OTP screen.
///
/// Defaults match the forgot-password flow (where the durations are fixed on
/// the client). The login OTP flow overrides them with values the backend sends
/// in the `verify_otp` challenge — see [OtpPage].
class OtpTimerConfig {
  const OtpTimerConfig({
    this.validitySeconds = defaultValiditySeconds,
    this.resendCooldownSeconds = defaultResendCooldownSeconds,
    this.maxAttempts = defaultMaxAttempts,
  });

  static const int defaultValiditySeconds = 120;
  static const int defaultResendCooldownSeconds = 30;
  static const int defaultMaxAttempts = 5;

  /// How long the entered code stays valid (drives the "expires in" countdown).
  final int validitySeconds;

  /// How long the "Resend" button stays disabled after the screen opens.
  final int resendCooldownSeconds;

  /// Wrong attempts allowed before the screen locks.
  final int maxAttempts;
}
