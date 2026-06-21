/// On-screen parameters for an OTP verification step, returned by the backend
/// alongside a `challenge_type: "verify_otp"` response. Shared by the login
/// re-verification, sign-up, and forgot-password flows.
///
/// The session token that ties the challenge to the request is NOT here — it is
/// a data-layer credential held by `PreAuthSession`; this entity only carries
/// what the OTP screen displays.
class OtpChallenge {
  const OtpChallenge({
    required this.resendSecs,
    required this.enableResendSecs,
  });

  /// `otp_resend_secs` — drives the on-screen code-expiry countdown.
  final int resendSecs;

  /// `otp_enable_resend_secs` — how long the "Resend" button stays disabled
  /// after the screen opens. 0 means it is enabled immediately.
  final int enableResendSecs;
}
