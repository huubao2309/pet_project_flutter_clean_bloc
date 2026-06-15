/// Per-rule password strength result, used to drive the checklist UI.
class PasswordStrength {
  const PasswordStrength({
    required this.hasMinLength,
    required this.hasSpecialChar,
    required this.hasNumber,
    required this.hasCapital,
  });

  const PasswordStrength.empty()
      : hasMinLength = false,
        hasSpecialChar = false,
        hasNumber = false,
        hasCapital = false;

  final bool hasMinLength;
  final bool hasSpecialChar;
  final bool hasNumber;
  final bool hasCapital;

  bool get isAllValid =>
      hasMinLength && hasSpecialChar && hasNumber && hasCapital;
}

/// Immutable UI state for the sign-up screen. Library-agnostic.
class SignUpState {
  const SignUpState({
    this.email = '',
    this.password = '',
    this.receiveUpdates = false,
    this.strength = const PasswordStrength.empty(),
    this.isEmailValid = false,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  final String email;
  final String password;
  final bool receiveUpdates;
  final PasswordStrength strength;
  final bool isEmailValid;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  /// The submit button is enabled only when the email and every password rule
  /// pass validation.
  bool get canSubmit => isEmailValid && strength.isAllValid;

  SignUpState copyWith({
    String? email,
    String? password,
    bool? receiveUpdates,
    PasswordStrength? strength,
    bool? isEmailValid,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      receiveUpdates: receiveUpdates ?? this.receiveUpdates,
      strength: strength ?? this.strength,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
