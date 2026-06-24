import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/entities/otp_challenge.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/entities/sign_up_result.dart';

void main() {
  group('SignUpResult', () {
    test('SignUpCompleted is a SignUpResult', () {
      const result = SignUpCompleted();
      expect(result, isA<SignUpResult>());
      expect(result, isA<SignUpCompleted>());
    });

    test('SignUpOtpRequired carries the challenge', () {
      const challenge = OtpChallenge(resendSecs: 90, enableResendSecs: 15);
      const result = SignUpOtpRequired(challenge);

      expect(result, isA<SignUpResult>());
      expect(result.challenge, same(challenge));
      expect(result.challenge.resendSecs, 90);
    });

    test('exhaustive switch over sealed subtypes', () {
      String label(SignUpResult result) => switch (result) {
            SignUpCompleted() => 'done',
            SignUpOtpRequired() => 'otp',
          };

      expect(label(const SignUpCompleted()), 'done');
      expect(
        label(
          const SignUpOtpRequired(
            OtpChallenge(resendSecs: 60, enableResendSecs: 0),
          ),
        ),
        'otp',
      );
    });
  });
}
