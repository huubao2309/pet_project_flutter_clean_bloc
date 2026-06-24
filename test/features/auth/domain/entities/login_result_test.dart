import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/entities/login_result.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/entities/otp_challenge.dart';

void main() {
  group('LoginResult', () {
    test('LoginAuthenticated is a LoginResult', () {
      const result = LoginAuthenticated();
      expect(result, isA<LoginResult>());
      expect(result, isA<LoginAuthenticated>());
    });

    test('LoginOtpRequired carries the challenge', () {
      const challenge = OtpChallenge(resendSecs: 60, enableResendSecs: 0);
      const result = LoginOtpRequired(challenge);

      expect(result, isA<LoginResult>());
      expect(result.challenge, same(challenge));
      expect(result.challenge.resendSecs, 60);
      expect(result.challenge.enableResendSecs, 0);
    });

    test('exhaustive switch over sealed subtypes', () {
      String label(LoginResult result) => switch (result) {
            LoginAuthenticated() => 'auth',
            LoginOtpRequired() => 'otp',
          };

      expect(label(const LoginAuthenticated()), 'auth');
      expect(
        label(
          const LoginOtpRequired(
            OtpChallenge(resendSecs: 30, enableResendSecs: 10),
          ),
        ),
        'otp',
      );
    });
  });
}
