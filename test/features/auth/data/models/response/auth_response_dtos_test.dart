import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/data/models/response/login_data_dto.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/data/models/response/login_response_dto.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/data/models/response/otp_challenge_dto.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/data/models/response/register_password_data_dto.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/data/models/response/verify_otp_data_dto.dart';

void main() {
  group('LoginDataDto', () {
    test('fromJson parses authenticated (challenge_type none) shape', () {
      final dto = LoginDataDto.fromJson({
        'challenge_type': 'none',
        'access_token': 'at',
        'refresh_token': 'rt',
      });
      expect(dto.challengeType, 'none');
      expect(dto.accessToken, 'at');
      expect(dto.refreshToken, 'rt');
      expect(dto.sessionToken, isNull);
      expect(dto.otpResendSecs, isNull);
      expect(dto.otpEnableResendSecs, isNull);
    });

    test('fromJson parses verify_otp shape with int secs', () {
      final dto = LoginDataDto.fromJson({
        'challenge_type': 'verify_otp',
        'session_token': 'sess',
        'otp_resend_secs': 60,
        'otp_enable_resend_secs': 30,
      });
      expect(dto.challengeType, 'verify_otp');
      expect(dto.sessionToken, 'sess');
      expect(dto.otpResendSecs, 60);
      expect(dto.otpEnableResendSecs, 30);
      expect(dto.accessToken, isNull);
    });

    test('fromJson empty map yields all nulls', () {
      final dto = LoginDataDto.fromJson({});
      expect(dto.challengeType, isNull);
      expect(dto.accessToken, isNull);
      expect(dto.refreshToken, isNull);
      expect(dto.sessionToken, isNull);
      expect(dto.otpResendSecs, isNull);
      expect(dto.otpEnableResendSecs, isNull);
    });

    test('toJson outputs all snake_case keys', () {
      const dto = LoginDataDto(
        challengeType: 'none',
        accessToken: 'at',
        refreshToken: 'rt',
        sessionToken: 's',
        otpResendSecs: 60,
        otpEnableResendSecs: 30,
      );
      expect(dto.toJson(), {
        'challenge_type': 'none',
        'access_token': 'at',
        'refresh_token': 'rt',
        'session_token': 's',
        'otp_resend_secs': 60,
        'otp_enable_resend_secs': 30,
      });
    });
  });

  group('LoginResponseDto', () {
    test('fromJson parses message, verdict and nested data', () {
      final dto = LoginResponseDto.fromJson({
        'message': 'ok',
        'verdict': 'allow',
        'data': {
          'challenge_type': 'none',
          'access_token': 'at',
          'refresh_token': 'rt',
        },
      });
      expect(dto.message, 'ok');
      expect(dto.verdict, 'allow');
      expect(dto.data.challengeType, 'none');
      expect(dto.data.accessToken, 'at');
    });

    test('toJson serializes nested data dto', () {
      const dto = LoginResponseDto(
        message: 'ok',
        verdict: 'allow',
        data: LoginDataDto(challengeType: 'none', accessToken: 'at'),
      );
      final json = dto.toJson();
      expect(json['message'], 'ok');
      expect(json['verdict'], 'allow');
      final data = json['data'] as LoginDataDto;
      expect(data.challengeType, 'none');
      expect(data.accessToken, 'at');
    });
  });

  group('OtpChallengeDto', () {
    test('fromJson parses snake_case fields', () {
      final dto = OtpChallengeDto.fromJson({
        'challenge_type': 'verify_otp',
        'session_token': 'sess',
        'otp_resend_secs': 90,
        'otp_enable_resend_secs': 45,
      });
      expect(dto.challengeType, 'verify_otp');
      expect(dto.sessionToken, 'sess');
      expect(dto.otpResendSecs, 90);
      expect(dto.otpEnableResendSecs, 45);
    });

    test('toJson outputs snake_case keys', () {
      const dto = OtpChallengeDto(
        challengeType: 'verify_otp',
        sessionToken: 'sess',
        otpResendSecs: 90,
        otpEnableResendSecs: 45,
      );
      expect(dto.toJson(), {
        'challenge_type': 'verify_otp',
        'session_token': 'sess',
        'otp_resend_secs': 90,
        'otp_enable_resend_secs': 45,
      });
    });

    test('requiresOtpVerification true only for verify_otp', () {
      expect(
        const OtpChallengeDto(challengeType: 'verify_otp')
            .requiresOtpVerification,
        isTrue,
      );
      expect(
        const OtpChallengeDto(challengeType: 'none').requiresOtpVerification,
        isFalse,
      );
      expect(
        const OtpChallengeDto().requiresOtpVerification,
        isFalse,
      );
    });

    test('toEntity maps secs, defaulting nulls to 0', () {
      final entity = const OtpChallengeDto(
        otpResendSecs: 90,
        otpEnableResendSecs: 45,
      ).toEntity();
      expect(entity.resendSecs, 90);
      expect(entity.enableResendSecs, 45);

      final defaulted = const OtpChallengeDto().toEntity();
      expect(defaulted.resendSecs, 0);
      expect(defaulted.enableResendSecs, 0);
    });
  });

  group('RegisterPasswordDataDto', () {
    test('fromJson parses tokens', () {
      final dto = RegisterPasswordDataDto.fromJson({
        'challenge_type': 'none',
        'access_token': 'at',
        'refresh_token': 'rt',
      });
      expect(dto.challengeType, 'none');
      expect(dto.accessToken, 'at');
      expect(dto.refreshToken, 'rt');
    });

    test('fromJson empty map yields nulls', () {
      final dto = RegisterPasswordDataDto.fromJson({});
      expect(dto.challengeType, isNull);
      expect(dto.accessToken, isNull);
      expect(dto.refreshToken, isNull);
    });

    test('toJson outputs snake_case keys', () {
      const dto = RegisterPasswordDataDto(
        challengeType: 'none',
        accessToken: 'at',
        refreshToken: 'rt',
      );
      expect(dto.toJson(), {
        'challenge_type': 'none',
        'access_token': 'at',
        'refresh_token': 'rt',
      });
    });
  });

  group('VerifyOtpDataDto', () {
    test('fromJson parses all fields', () {
      final dto = VerifyOtpDataDto.fromJson({
        'challenge_type': 'register_password',
        'access_token': null,
        'refresh_token': null,
        'session_token': 'sess',
      });
      expect(dto.challengeType, 'register_password');
      expect(dto.sessionToken, 'sess');
      expect(dto.accessToken, isNull);
      expect(dto.refreshToken, isNull);
    });

    test('toJson outputs snake_case keys', () {
      const dto = VerifyOtpDataDto(
        challengeType: 'none',
        accessToken: 'at',
        refreshToken: 'rt',
        sessionToken: 's',
      );
      expect(dto.toJson(), {
        'challenge_type': 'none',
        'access_token': 'at',
        'refresh_token': 'rt',
        'session_token': 's',
      });
    });

    test('isAuthenticated true only for none', () {
      expect(
        const VerifyOtpDataDto(challengeType: 'none').isAuthenticated,
        isTrue,
      );
      expect(
        const VerifyOtpDataDto(challengeType: 'register_password')
            .isAuthenticated,
        isFalse,
      );
      expect(const VerifyOtpDataDto().isAuthenticated, isFalse);
    });

    test('requiresPasswordRegistration true only for register_password', () {
      expect(
        const VerifyOtpDataDto(challengeType: 'register_password')
            .requiresPasswordRegistration,
        isTrue,
      );
      expect(
        const VerifyOtpDataDto(challengeType: 'none')
            .requiresPasswordRegistration,
        isFalse,
      );
    });

    test('requiresPasswordReset true only for reset_password', () {
      expect(
        const VerifyOtpDataDto(challengeType: 'reset_password')
            .requiresPasswordReset,
        isTrue,
      );
      expect(
        const VerifyOtpDataDto(challengeType: 'none').requiresPasswordReset,
        isFalse,
      );
    });
  });
}
