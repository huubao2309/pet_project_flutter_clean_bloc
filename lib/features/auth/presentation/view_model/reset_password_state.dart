import 'password_strength.dart';

export 'password_strength.dart';

/// Immutable UI state for the reset-password screen. Library-agnostic.
///
/// Reuses [PasswordStrength] from the registration flow for the same 4 password
/// rules.
class ResetPasswordState {
  const ResetPasswordState({
    this.password = '',
    this.confirmPassword = '',
    this.strength = const PasswordStrength.empty(),
    this.isLoading = false,
    this.isResetSuccess = false,
    this.errorMessage,
  });

  final String password;

  /// The re-entered password used to confirm the user typed what they intended.
  final String confirmPassword;
  final PasswordStrength strength;
  final bool isLoading;
  final bool isResetSuccess;
  final String? errorMessage;

  /// True once the confirmation matches a non-empty password.
  bool get isConfirmValid =>
      confirmPassword.isNotEmpty && confirmPassword == password;

  /// True when the user typed a confirmation that does NOT match (drives the
  /// inline mismatch error).
  bool get hasConfirmMismatch =>
      confirmPassword.isNotEmpty && confirmPassword != password;

  bool get canSubmit => strength.isAllValid && isConfirmValid;

  ResetPasswordState copyWith({
    String? password,
    String? confirmPassword,
    PasswordStrength? strength,
    bool? isLoading,
    bool? isResetSuccess,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ResetPasswordState(
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      strength: strength ?? this.strength,
      isLoading: isLoading ?? this.isLoading,
      isResetSuccess: isResetSuccess ?? this.isResetSuccess,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
