import 'sign_up_state.dart' show PasswordStrength;

export 'sign_up_state.dart' show PasswordStrength;

/// Immutable UI state for the reset-password screen. Library-agnostic.
///
/// Reuses [PasswordStrength] from the sign-up flow for the same 4 password
/// rules.
class ResetPasswordState {
  const ResetPasswordState({
    this.password = '',
    this.strength = const PasswordStrength.empty(),
    this.isLoading = false,
    this.isResetSuccess = false,
    this.errorMessage,
  });

  final String password;
  final PasswordStrength strength;
  final bool isLoading;
  final bool isResetSuccess;
  final String? errorMessage;

  bool get canSubmit => strength.isAllValid;

  ResetPasswordState copyWith({
    String? password,
    PasswordStrength? strength,
    bool? isLoading,
    bool? isResetSuccess,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ResetPasswordState(
      password: password ?? this.password,
      strength: strength ?? this.strength,
      isLoading: isLoading ?? this.isLoading,
      isResetSuccess: isResetSuccess ?? this.isResetSuccess,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
