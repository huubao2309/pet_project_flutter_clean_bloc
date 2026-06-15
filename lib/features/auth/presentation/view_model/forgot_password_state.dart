/// Immutable UI state for the forgot-password screen. Library-agnostic.
class ForgotPasswordState {
  const ForgotPasswordState({
    this.email = '',
    this.isLoading = false,
    this.isEmailSent = false,
    this.errorMessage,
  });

  final String email;
  final bool isLoading;
  final bool isEmailSent;
  final String? errorMessage;

  bool get canSubmit => email.trim().isNotEmpty;

  ForgotPasswordState copyWith({
    String? email,
    bool? isLoading,
    bool? isEmailSent,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      isLoading: isLoading ?? this.isLoading,
      isEmailSent: isEmailSent ?? this.isEmailSent,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
