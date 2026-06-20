/// Parameters for an OTP verification step, returned by the backend alongside a
/// `challenge_type: "verify_otp"` response. Shared by the login re-verification
/// and sign-up flows.
class OtpChallenge {
  const OtpChallenge({
    required this.sessionToken,
    required this.resendSecs,
    required this.enableResendSecs,
  });

  /// Short-lived token that ties the OTP verification back to this request.
  final String sessionToken;

  /// `otp_resend_secs` — drives the on-screen code-expiry countdown.
  final int resendSecs;

  /// `otp_enable_resend_secs` — how long the "Resend" button stays disabled
  /// after the screen opens. 0 means it is enabled immediately.
  final int enableResendSecs;
}
