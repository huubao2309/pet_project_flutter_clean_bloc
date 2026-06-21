import 'dart:async';

import '../../../../core/error/app_exception.dart';
import '../../../../core/presentation/view_model.dart';
import '../../domain/use_cases/verify_otp_use_case.dart';
import 'otp_state.dart';
import 'otp_timer_config.dart';

/// View model for the OTP screen.
///
/// `verify()` calls the verify-otp API via [VerifyOtpUseCase] and exposes the
/// outcome as [OtpState.verifyResult] (with [OtpState.isVerified] true) so the
/// View can navigate on the backend's `challenge_type`:
///   • sign-up  → `register_password` challenge (go set a password);
///   • login    → authenticated (tokens persisted).
///
/// Runs a 1s ticker that counts down the code validity and the resend cooldown,
/// flips to [OtpError.expired] when validity hits zero, and locks the screen
/// after [OtpTimerConfig.maxAttempts] wrong codes.
class OtpViewModel extends ViewModel<OtpState> {
  OtpViewModel({
    required VerifyOtpUseCase verifyOtpUseCase,
    OtpTimerConfig config = const OtpTimerConfig(),
  })  : _config = config,
        _verifyOtpUseCase = verifyOtpUseCase,
        super(const OtpState()) {
    _restart();
  }

  final OtpTimerConfig _config;
  final VerifyOtpUseCase _verifyOtpUseCase;

  Timer? _timer;

  void onCodeChanged(String value) {
    final state = currentState;
    setState(
      state.copyWith(
        code: value,
        // Clear a previous "wrong code" error as soon as the user edits.
        error: state.error == OtpError.invalid ? OtpError.none : state.error,
      ),
    );
  }

  Future<void> verify() async {
    if (!currentState.canVerify) {
      return;
    }
    setState(currentState.copyWith(isVerifying: true));

    try {
      final result = await _verifyOtpUseCase.execute(currentState.code);
      _timer?.cancel();
      // The View navigates based on this result (see `_onVerified`).
      setState(
        currentState.copyWith(
          isVerifying: false,
          isVerified: true,
          verifyResult: result,
        ),
      );
    } on AppException catch (_) {
      _registerWrongAttempt();
    }
  }

  /// Records a wrong attempt: lock the screen at the limit, otherwise flag the
  /// code as invalid.
  void _registerWrongAttempt() {
    final attempts = currentState.attempts + 1;
    if (attempts >= _config.maxAttempts) {
      _timer?.cancel();
      setState(
        currentState.copyWith(
          isVerifying: false,
          attempts: attempts,
          isLocked: true,
        ),
      );
      return;
    }
    setState(
      currentState.copyWith(
        isVerifying: false,
        attempts: attempts,
        error: OtpError.invalid,
      ),
    );
  }

  /// User tapped "resend": request a fresh code and reset the timers.
  Future<void> resend() async {
    if (!currentState.canResend) {
      return;
    }
    await _requestCode();
    _restart();
  }

  void _restart() {
    setState(
      OtpState(
        secondsLeft: _config.validitySeconds,
        resendIn: _config.resendCooldownSeconds,
      ),
    );
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    final state = currentState;
    if (state.isLocked || state.isVerified) {
      _timer?.cancel();
      return;
    }
    final secondsLeft = state.secondsLeft > 0 ? state.secondsLeft - 1 : 0;
    final resendIn = state.resendIn > 0 ? state.resendIn - 1 : 0;
    final expired = secondsLeft == 0 && state.error != OtpError.expired
        ? OtpError.expired
        : state.error;
    setState(
      state.copyWith(
        secondsLeft: secondsLeft,
        resendIn: resendIn,
        error: expired,
      ),
    );
  }

  Future<void> _requestCode() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
