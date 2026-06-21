import 'password_strength.dart';

export 'password_strength.dart';

/// Immutable UI state for the change-password screen (reached from Profile).
///
/// Collects the current password plus a new password (with the same 4 rules as
/// registration) and its confirmation. Library-agnostic.
class ChangePasswordState {
  const ChangePasswordState({
    this.currentPassword = '',
    this.newPassword = '',
    this.confirmPassword = '',
    this.strength = const PasswordStrength.empty(),
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  final String currentPassword;
  final String newPassword;

  /// The re-entered new password used to confirm the user typed what they meant.
  final String confirmPassword;
  final PasswordStrength strength;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  /// True once the confirmation matches a non-empty new password.
  bool get isConfirmValid =>
      confirmPassword.isNotEmpty && confirmPassword == newPassword;

  /// True when the user typed a confirmation that does NOT match (drives the
  /// inline mismatch error).
  bool get hasConfirmMismatch =>
      confirmPassword.isNotEmpty && confirmPassword != newPassword;

  /// The submit button is enabled only when the current password is filled and
  /// every new-password rule plus the confirmation pass validation.
  bool get canSubmit =>
      currentPassword.isNotEmpty && strength.isAllValid && isConfirmValid;

  ChangePasswordState copyWith({
    String? currentPassword,
    String? newPassword,
    String? confirmPassword,
    PasswordStrength? strength,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ChangePasswordState(
      currentPassword: currentPassword ?? this.currentPassword,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      strength: strength ?? this.strength,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
