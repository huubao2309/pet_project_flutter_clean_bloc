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
    this.phone = '',
    this.password = '',
    this.receiveUpdates = false,
    this.strength = const PasswordStrength.empty(),
    this.isPhoneValid = false,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  final String phone;
  final String password;
  final bool receiveUpdates;
  final PasswordStrength strength;
  final bool isPhoneValid;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  /// The submit button is enabled only when the phone and every password rule
  /// pass validation.
  bool get canSubmit => isPhoneValid && strength.isAllValid;

  SignUpState copyWith({
    String? phone,
    String? password,
    bool? receiveUpdates,
    PasswordStrength? strength,
    bool? isPhoneValid,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SignUpState(
      phone: phone ?? this.phone,
      password: password ?? this.password,
      receiveUpdates: receiveUpdates ?? this.receiveUpdates,
      strength: strength ?? this.strength,
      isPhoneValid: isPhoneValid ?? this.isPhoneValid,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
