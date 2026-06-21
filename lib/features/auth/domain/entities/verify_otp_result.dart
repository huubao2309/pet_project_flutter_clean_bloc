/// Outcome of verifying an OTP code — the next step in the flow, told apart by
/// the backend's `challenge_type`. The session token that carries the flow
/// forward is held by the data layer (PreAuthSession), so these are pure
/// markers: the View navigates on the type alone.
sealed class VerifyOtpResult {
  const VerifyOtpResult();
}

/// Verification authenticated the user (login flow). Tokens are already saved.
final class VerifyOtpAuthenticated extends VerifyOtpResult {
  const VerifyOtpAuthenticated();
}

/// Verification passed but the user must set a password next (sign-up flow).
final class VerifyOtpRegisterPassword extends VerifyOtpResult {
  const VerifyOtpRegisterPassword();
}

/// Verification passed and the user must set a new password (forgot-password
/// flow).
final class VerifyOtpResetPassword extends VerifyOtpResult {
  const VerifyOtpResetPassword();
}
