/// Per-rule password strength result, used to drive the password-rule checklist
/// UI shared across the registration, reset, and change-password flows.
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
