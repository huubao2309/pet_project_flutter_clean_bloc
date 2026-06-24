import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/entities/otp_challenge.dart';

void main() {
  group('OtpChallenge', () {
    test('stores constructor values', () {
      const challenge = OtpChallenge(resendSecs: 120, enableResendSecs: 30);
      expect(challenge.resendSecs, 120);
      expect(challenge.enableResendSecs, 30);
    });

    test('enableResendSecs of 0 means resend enabled immediately', () {
      const challenge = OtpChallenge(resendSecs: 60, enableResendSecs: 0);
      expect(challenge.enableResendSecs, 0);
    });
  });
}
