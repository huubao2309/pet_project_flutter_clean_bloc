import '../entities/user_entity.dart';

/// Auth domain contract (a "port"). Lives in the domain layer so use cases
/// depend inward only; the data layer provides the implementation.
///
/// Note: parameters are plain domain values, never data-layer DTOs — keeping
/// the domain free of serialization concerns.
abstract class AuthRepository {
  Future<UserEntity> login({required String phone, required String password});

  /// Registers a new account. Returns true when the sign-up succeeded
  /// (e.g. a confirmation email was sent).
  Future<bool> signUp({
    required String email,
    required String password,
    bool? receiveUpdates,
  });

  /// Sends a password-reset email to [email].
  Future<void> forgotPassword({required String email});

  /// Sets a new password using the reset [token] from the email link.
  Future<void> resetPassword({
    required String newPassword,
    required String token,
  });

  Future<void> logout();

  Future<bool> isLoggedIn();

  Future<UserEntity?> getCurrentUser();
}
