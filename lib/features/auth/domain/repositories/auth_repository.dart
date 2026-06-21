import '../entities/login_result.dart';
import '../entities/otp_challenge.dart';
import '../entities/sign_up_result.dart';
import '../entities/verify_otp_result.dart';

/// Auth domain contract (a "port"). Lives in the domain layer so use cases
/// depend inward only; the data layer provides the implementation.
///
/// Note: parameters are plain domain values, never data-layer DTOs — keeping
/// the domain free of serialization concerns.
abstract class AuthRepository {
  /// Authenticates the user. Returns a [LoginResult]: either authenticated
  /// (tokens persisted) or an OTP challenge that must be verified first.
  Future<LoginResult> login({required String phone, required String password});

  /// Registers a new account. Returns a [SignUpResult]: either completed, or an
  /// OTP challenge that must be verified next. The signup API takes only the
  /// phone; the password is set in a later step.
  Future<SignUpResult> signUp({
    required String phone,
    bool? receiveUpdates,
  });

  /// Verifies an OTP [code] for the active pre-auth flow. Returns a
  /// [VerifyOtpResult]: authenticated (login, tokens persisted), or a
  /// register-/reset-password step (the session carries on internally).
  Future<VerifyOtpResult> verifyOtp({required String code});

  /// Sets the password for an OTP-verified sign-up, then persists the returned
  /// auth tokens (signing the user in).
  Future<void> registerPassword({required String password});

  /// Sends a password-reset code to [phone] and returns the `verify_otp`
  /// challenge (session token + timers) for the OTP screen.
  Future<OtpChallenge> forgotPassword({required String phone});

  /// Sets a new password for an OTP-verified forgot-password flow.
  Future<void> resetPassword({required String newPassword});

  /// Changes the password for the logged-in user. The backend verifies
  /// [currentPassword] before applying [newPassword].
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<void> logout();

  Future<bool> isLoggedIn();
}
