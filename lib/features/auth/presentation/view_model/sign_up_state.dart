import '../../domain/entities/otp_challenge.dart';

/// Immutable UI state for the sign-up screen.
///
/// The screen collects and validates the phone number, then submits it via
/// `signUp()`. The backend (currently the `signup_success.json` mock) responds
/// with a `verify_otp` challenge, which the View uses to route to the OTP
/// screen. Library-agnostic.
class SignUpState {
  const SignUpState({
    this.phone = '',
    this.isPhoneValid = false,
    this.isLoading = false,
    this.isSuccess = false,
    this.isBlocked = false,
    this.errorMessage,
    this.otpChallenge,
  });

  final String phone;
  final bool isPhoneValid;
  final bool isLoading;
  final bool isSuccess;

  /// The phone is blocked from registering (hard stop). The View renders a
  /// full-screen error instead of a snackbar.
  final bool isBlocked;
  final String? errorMessage;

  /// Set when sign-up returns a `verify_otp` challenge. The View routes to the
  /// OTP screen once this becomes non-null.
  final OtpChallenge? otpChallenge;

  /// The "Continue" button is enabled only once the phone number is valid.
  bool get canSubmit => isPhoneValid;

  SignUpState copyWith({
    String? phone,
    bool? isPhoneValid,
    bool? isLoading,
    bool? isSuccess,
    bool? isBlocked,
    String? errorMessage,
    bool clearError = false,
    OtpChallenge? otpChallenge,
  }) {
    return SignUpState(
      phone: phone ?? this.phone,
      isPhoneValid: isPhoneValid ?? this.isPhoneValid,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isBlocked: isBlocked ?? this.isBlocked,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      otpChallenge: otpChallenge ?? this.otpChallenge,
    );
  }
}
