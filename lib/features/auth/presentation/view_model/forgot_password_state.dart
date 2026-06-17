/// Immutable UI state for the forgot-password screen. Library-agnostic.
class ForgotPasswordState {
  const ForgotPasswordState({
    this.phone = '',
    this.isPhoneValid = false,
    this.isLoading = false,
    this.isSent = false,
    this.errorMessage,
  });

  final String phone;
  final bool isPhoneValid;
  final bool isLoading;
  final bool isSent;
  final String? errorMessage;

  bool get canSubmit => isPhoneValid;

  ForgotPasswordState copyWith({
    String? phone,
    bool? isPhoneValid,
    bool? isLoading,
    bool? isSent,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ForgotPasswordState(
      phone: phone ?? this.phone,
      isPhoneValid: isPhoneValid ?? this.isPhoneValid,
      isLoading: isLoading ?? this.isLoading,
      isSent: isSent ?? this.isSent,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
