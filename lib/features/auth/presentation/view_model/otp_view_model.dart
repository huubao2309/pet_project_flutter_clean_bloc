import 'dart:async';

import '../../../../core/presentation/view_model.dart';
import 'otp_state.dart';
import 'otp_timer_config.dart';

/// View model for the OTP screen. Verification is mocked for now (expected code
/// `123456`); swap [_verifyCode] / [_requestCode] for real use cases later.
///
/// Runs a 1s ticker that counts down the code validity and the resend cooldown,
/// flips to [OtpError.expired] when validity hits zero, and locks the screen
/// after [OtpTimerConfig.maxAttempts] wrong codes. Durations come from
/// [OtpTimerConfig] so each flow (forgot-password, login) can configure them.
class OtpViewModel extends ViewModel<OtpState> {
  OtpViewModel({OtpTimerConfig config = const OtpTimerConfig()})
      : _config = config,
        super(const OtpState()) {
    _restart();
  }

  final OtpTimerConfig _config;

  static const String _mockCode = '123456';

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
    final ok = await _verifyCode(currentState.code);

    if (ok) {
      _timer?.cancel();
      setState(currentState.copyWith(isVerifying: false, isVerified: true));
      return;
    }

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

  // ── Mock backend — replace with injected use cases ──────────────────────
  Future<bool> _verifyCode(String code) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return code == _mockCode;
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
