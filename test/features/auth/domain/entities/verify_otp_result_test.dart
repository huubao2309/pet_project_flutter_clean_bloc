import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/entities/verify_otp_result.dart';

void main() {
  group('VerifyOtpResult', () {
    test('subtypes are VerifyOtpResult instances', () {
      expect(const VerifyOtpAuthenticated(), isA<VerifyOtpResult>());
      expect(const VerifyOtpRegisterPassword(), isA<VerifyOtpResult>());
      expect(const VerifyOtpResetPassword(), isA<VerifyOtpResult>());
    });

    test('exhaustive switch over all three subtypes', () {
      String label(VerifyOtpResult r) => switch (r) {
            VerifyOtpAuthenticated() => 'auth',
            VerifyOtpRegisterPassword() => 'register',
            VerifyOtpResetPassword() => 'reset',
          };

      expect(label(const VerifyOtpAuthenticated()), 'auth');
      expect(label(const VerifyOtpRegisterPassword()), 'register');
      expect(label(const VerifyOtpResetPassword()), 'reset');
    });
  });
}
