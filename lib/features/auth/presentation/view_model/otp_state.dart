import '../../domain/entities/verify_otp_result.dart';

/// Why the OTP entry is currently in an error state.
enum OtpError { none, invalid, expired }

/// Immutable UI state for the OTP screen. Library-agnostic (no Bloc/GetX types).
class OtpState {
  const OtpState({
    this.code = '',
    this.isVerifying = false,
    this.error = OtpError.none,
    this.isLocked = false,
    this.isVerified = false,
    this.verifyResult,
    this.secondsLeft = 0,
    this.resendIn = 0,
    this.attempts = 0,
  });

  final String code;
  final bool isVerifying;
  final OtpError error;

  /// Too many wrong attempts — the screen should hand off to the error view.
  final bool isLocked;
  final bool isVerified;

  /// The outcome of a successful verification — drives where the View navigates
  /// (login → Home; sign-up `register_password` → set-password screen). Null
  /// until [isVerified] flips true.
  final VerifyOtpResult? verifyResult;

  /// Remaining validity of the current code (seconds).
  final int secondsLeft;

  /// Cooldown before "resend" becomes available again (seconds).
  final int resendIn;

  final int attempts;

  bool get canResend => resendIn == 0 && !isLocked;

  bool get canVerify =>
      code.length == 6 &&
      !isVerifying &&
      !isLocked &&
      error != OtpError.expired;

  OtpState copyWith({
    String? code,
    bool? isVerifying,
    OtpError? error,
    bool? isLocked,
    bool? isVerified,
    VerifyOtpResult? verifyResult,
    int? secondsLeft,
    int? resendIn,
    int? attempts,
  }) {
    return OtpState(
      code: code ?? this.code,
      isVerifying: isVerifying ?? this.isVerifying,
      error: error ?? this.error,
      isLocked: isLocked ?? this.isLocked,
      isVerified: isVerified ?? this.isVerified,
      verifyResult: verifyResult ?? this.verifyResult,
      secondsLeft: secondsLeft ?? this.secondsLeft,
      resendIn: resendIn ?? this.resendIn,
      attempts: attempts ?? this.attempts,
    );
  }
}
