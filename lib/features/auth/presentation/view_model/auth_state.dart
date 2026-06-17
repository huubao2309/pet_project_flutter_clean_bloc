import '../../../../core/error/app_exception.dart';
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
  const AuthAuthenticated(this.user);
  final UserEntity user;
}

final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
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
