import '../../../../core/error/app_exception.dart';
import '../../domain/entities/otp_challenge.dart';
import '../../domain/entities/user_entity.dart';

/// Immutable UI state for the auth feature.
///
/// This file is intentionally free of any state-management library types, so
/// it is reused as-is if the app migrates from Bloc to GetX/MobX/etc.
sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthAuthenticated extends AuthState {
  const AuthAuthenticated([this.user]);

  /// The signed-in user, when known. Null right after a token-only login
  /// (`challenge_type: "none"`), where the profile is loaded separately.
  final UserEntity? user;
}

final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Credentials accepted, but the account must pass an OTP check before the
/// session is granted (`challenge_type: "verify_otp"`). The View routes to the
/// OTP screen, carrying [challenge] so it can configure the timers.
final class AuthOtpRequired extends AuthState {
  const AuthOtpRequired(this.challenge);
  final OtpChallenge challenge;
}

final class AuthFailure extends AuthState {
  const AuthFailure(this.message);
  final String message;
}

/// The account is blocked (hard stop) — see [BlockReason] for the cause (too
/// many wrong OTP entries, a deleted account, …). The View renders a
/// full-screen error instead of a snackbar.
final class AuthBlocked extends AuthState {
  const AuthBlocked(this.reason, this.message);
  final BlockReason reason;
  final String message;
}
