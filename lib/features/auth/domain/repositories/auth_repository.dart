import '../entities/login_result.dart';
import '../entities/sign_up_result.dart';
import '../entities/user_entity.dart';

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
  /// OTP challenge that must be verified next.
  Future<SignUpResult> signUp({
    required String phone,
    required String password,
    bool? receiveUpdates,
  });

  /// Sends a password-reset code to [phone].
  Future<void> forgotPassword({required String phone});

  /// Sets a new password using the reset [token] from the email link.
  Future<void> resetPassword({
    required String newPassword,
    required String token,
  });

  Future<void> logout();

  Future<bool> isLoggedIn();

  Future<UserEntity?> getCurrentUser();
}
