import 'password_strength.dart';

export 'password_strength.dart';

/// Immutable UI state for the register-password screen — the final step of the
/// sign-up flow, reached after OTP verification. Holds the new password, its
/// confirmation, and live rule validation. Library-agnostic.
class RegisterPasswordState {
  const RegisterPasswordState({
    this.password = '',
    this.confirmPassword = '',
    this.strength = const PasswordStrength.empty(),
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  final String password;

  /// The re-entered password used to confirm the user typed what they intended.
  final String confirmPassword;
  final PasswordStrength strength;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  /// True once the confirmation matches a non-empty password.
  bool get isConfirmValid =>
      confirmPassword.isNotEmpty && confirmPassword == password;

  /// True when the user typed a confirmation that does NOT match (drives the
  /// inline mismatch error).
  bool get hasConfirmMismatch =>
      confirmPassword.isNotEmpty && confirmPassword != password;

  /// The submit button is enabled only when every password rule and the
  /// confirmation pass validation.
  bool get canSubmit => strength.isAllValid && isConfirmValid;

  RegisterPasswordState copyWith({
    String? password,
    String? confirmPassword,
    PasswordStrength? strength,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    bool clearError = false,
  }) {
    return RegisterPasswordState(
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      strength: strength ?? this.strength,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
