/// Outcome of verifying an OTP code.
///
/// The backend resolves the verification into one of two next steps, told apart
/// by the response's `challenge_type`:
///   • login flow   → authenticated outright (tokens persisted).
///   • sign-up flow → the phone is confirmed but a password must still be set;
///     a fresh session token is issued for the register-password step.
sealed class VerifyOtpResult {
  const VerifyOtpResult();
}

/// Verification authenticated the user (login flow). Tokens are already saved.
final class VerifyOtpAuthenticated extends VerifyOtpResult {
  const VerifyOtpAuthenticated();
}

/// Verification passed but the user must set a password next (sign-up flow).
/// Carries the session token the register-password call needs.
final class VerifyOtpRegisterPassword extends VerifyOtpResult {
  const VerifyOtpRegisterPassword(this.sessionToken);

  final String sessionToken;
}
