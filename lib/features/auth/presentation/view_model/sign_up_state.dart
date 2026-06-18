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
    this.confirmPassword = '',
    this.receiveUpdates = false,
    this.strength = const PasswordStrength.empty(),
    this.isPhoneValid = false,
    this.isLoading = false,
    this.isSuccess = false,
    this.isBlocked = false,
    this.errorMessage,
  });

  final String phone;
  final String password;

  /// The re-entered password used to confirm the user typed what they intended.
  final String confirmPassword;
  final bool receiveUpdates;
  final PasswordStrength strength;
  final bool isPhoneValid;
  final bool isLoading;
  final bool isSuccess;

  /// The phone is blocked from registering (hard stop). The View renders a
  /// full-screen error instead of a snackbar.
  final bool isBlocked;
  final String? errorMessage;

  /// True once the confirmation matches a non-empty password.
  bool get isConfirmValid =>
      confirmPassword.isNotEmpty && confirmPassword == password;

  /// True when the user typed a confirmation that does NOT match (drives the
  /// inline mismatch error).
  bool get hasConfirmMismatch =>
      confirmPassword.isNotEmpty && confirmPassword != password;

  /// The submit button is enabled only when the phone, every password rule, and
  /// the password confirmation all pass validation.
  bool get canSubmit =>
      isPhoneValid && strength.isAllValid && isConfirmValid;

  SignUpState copyWith({
    String? phone,
    String? password,
    String? confirmPassword,
    bool? receiveUpdates,
    PasswordStrength? strength,
    bool? isPhoneValid,
    bool? isLoading,
    bool? isSuccess,
    bool? isBlocked,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SignUpState(
      phone: phone ?? this.phone,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      receiveUpdates: receiveUpdates ?? this.receiveUpdates,
      strength: strength ?? this.strength,
      isPhoneValid: isPhoneValid ?? this.isPhoneValid,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isBlocked: isBlocked ?? this.isBlocked,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
