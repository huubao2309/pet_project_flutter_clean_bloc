import '../../domain/entities/otp_challenge.dart';

/// Immutable UI state for the forgot-password screen. Library-agnostic.
class ForgotPasswordState {
  const ForgotPasswordState({
    this.phone = '',
    this.isPhoneValid = false,
    this.isLoading = false,
    this.otpChallenge,
    this.errorMessage,
  });

  final String phone;
  final bool isPhoneValid;
  final bool isLoading;

  /// Set once "Send reset code" succeeds — carries the `verify_otp` challenge
  /// (session token + timers). The View routes to the OTP screen when non-null.
  final OtpChallenge? otpChallenge;
  final String? errorMessage;

  bool get canSubmit => isPhoneValid;

  ForgotPasswordState copyWith({
    String? phone,
    bool? isPhoneValid,
    bool? isLoading,
    OtpChallenge? otpChallenge,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ForgotPasswordState(
      phone: phone ?? this.phone,
      isPhoneValid: isPhoneValid ?? this.isPhoneValid,
      isLoading: isLoading ?? this.isLoading,
      otpChallenge: otpChallenge ?? this.otpChallenge,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
