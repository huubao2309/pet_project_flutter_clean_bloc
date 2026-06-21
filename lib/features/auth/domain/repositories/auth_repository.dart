import '../entities/login_result.dart';
import '../entities/sign_up_result.dart';
import '../entities/user_entity.dart';
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

  /// Verifies an OTP [code] against [sessionToken]. Returns a [VerifyOtpResult]:
  /// authenticated (login flow, tokens persisted) or a register-password step
  /// (sign-up flow, carrying a fresh session token).
  Future<VerifyOtpResult> verifyOtp({
    required String code,
    required String sessionToken,
  });

  /// Sets the password for an OTP-verified sign-up using [sessionToken], then
  /// persists the returned auth tokens (signing the user in).
  Future<void> registerPassword({
    required String password,
    required String sessionToken,
  });

  /// Sends a password-reset code to [phone].
  Future<void> forgotPassword({required String phone});

  /// Sets a new password using the reset [token] from the email link.
  Future<void> resetPassword({
    required String newPassword,
    required String token,
  });

  /// Changes the password for the logged-in user. The backend verifies
  /// [currentPassword] before applying [newPassword].
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<void> logout();

  Future<bool> isLoggedIn();

  Future<UserEntity?> getCurrentUser();
}
