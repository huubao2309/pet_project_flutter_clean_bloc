import 'otp_challenge.dart';

/// Outcome of a login attempt.
///
/// The backend either authenticates the user immediately (`challenge_type:
/// "none"`) or requires an extra OTP step first (`challenge_type:
/// "verify_otp"`, used when the account hasn't signed in for a while, to make
/// sure it is still the genuine owner). Modeling both as a sealed result lets
/// the presentation layer switch exhaustively over the two outcomes.
sealed class LoginResult {
  const LoginResult();
}

/// Credentials accepted with no further challenge — tokens have been persisted
/// and the app can go straight to Home.
///
/// Login returns no user profile (the `challenge_type: "none"` response carries
/// only the tokens), so this is a plain marker — the profile is loaded
/// separately once on the main screen.
final class LoginAuthenticated extends LoginResult {
  const LoginAuthenticated();
}

/// Credentials accepted but an OTP verification is required before the session
/// is granted. Carries the parameters the OTP screen needs.
final class LoginOtpRequired extends LoginResult {
  const LoginOtpRequired(this.challenge);

  final OtpChallenge challenge;
}
