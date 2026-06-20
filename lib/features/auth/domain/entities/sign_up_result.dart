import 'otp_challenge.dart';

/// Outcome of a sign-up attempt.
///
/// The backend either completes registration outright or requires an OTP
/// verification step first (`challenge_type: "verify_otp"`) to confirm the
/// phone belongs to the user. Modeling both as a sealed result lets the
/// presentation layer switch exhaustively over the two outcomes.
sealed class SignUpResult {
  const SignUpResult();
}

/// Registration succeeded with no further challenge.
final class SignUpCompleted extends SignUpResult {
  const SignUpCompleted();
}

/// Registration accepted but an OTP verification is required next. Carries the
/// parameters the OTP screen needs.
final class SignUpOtpRequired extends SignUpResult {
  const SignUpOtpRequired(this.challenge);

  final OtpChallenge challenge;
}
