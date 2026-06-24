import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/view_model/otp_timer_config.dart';

void main() {
  test('defaults match the forgot-password flow constants', () {
    const config = OtpTimerConfig();
    expect(config.validitySeconds, OtpTimerConfig.defaultValiditySeconds);
    expect(
      config.resendCooldownSeconds,
      OtpTimerConfig.defaultResendCooldownSeconds,
    );
    expect(config.maxAttempts, OtpTimerConfig.defaultMaxAttempts);
    expect(config.validitySeconds, 120);
    expect(config.resendCooldownSeconds, 30);
    expect(config.maxAttempts, 5);
  });

  test('accepts backend-supplied overrides', () {
    const config = OtpTimerConfig(
      validitySeconds: 90,
      resendCooldownSeconds: 15,
      maxAttempts: 3,
    );
    expect(config.validitySeconds, 90);
    expect(config.resendCooldownSeconds, 15);
    expect(config.maxAttempts, 3);
  });
}
