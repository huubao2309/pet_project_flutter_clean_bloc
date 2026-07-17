import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/constants/mock_assets.dart';
import 'package:pet_project_flutter_clean_bloc/core/error/app_exception.dart';
import 'package:pet_project_flutter_clean_bloc/data/datasources/auth_mock_data_source.dart';
import 'package:pet_project_flutter_clean_bloc/data/models/auth/request/forgot_password_request_dto.dart';
import 'package:pet_project_flutter_clean_bloc/data/models/auth/request/login_request_dto.dart';
import 'package:pet_project_flutter_clean_bloc/data/models/auth/request/register_password_request_dto.dart';
import 'package:pet_project_flutter_clean_bloc/data/models/auth/request/reset_password_request_dto.dart';
import 'package:pet_project_flutter_clean_bloc/data/models/auth/request/sign_up_request_dto.dart';
import 'package:pet_project_flutter_clean_bloc/data/models/auth/request/verify_otp_request_dto.dart';
import 'package:pet_project_flutter_clean_bloc/data/models/auth/response/login_data_dto.dart';
import 'package:pet_project_flutter_clean_bloc/data/models/auth/response/otp_challenge_dto.dart';
import 'package:pet_project_flutter_clean_bloc/data/models/auth/response/register_password_data_dto.dart';
import 'package:pet_project_flutter_clean_bloc/data/models/auth/response/verify_otp_data_dto.dart';

/// Drives the mock against the real bundled JSON fixtures (success / failure /
/// blocked), each instant via `latency: Duration.zero`.
void main() {
  setUpAll(TestWidgetsFlutterBinding.ensureInitialized);

  const login = LoginRequestDto(phone: '0900000000', password: 'pw');
  const signUp = SignUpRequestDto(phone: '0900000000', language: 'en');
  const verifyOtp = VerifyOtpRequestDto(code: '123456', sessionToken: 's');
  const registerPassword =
      RegisterPasswordRequestDto(password: 'pw', sessionToken: 's');
  const forgot = ForgotPasswordRequestDto(phone: '0900000000');
  const reset = ResetPasswordRequestDto(newPassword: 'pw', sessionToken: 's');

  AuthMockDataSource source({
    String? loginScenario,
    String? signUpScenario,
    String? logoutScenario,
    String? verifyOtpScenario,
    String? registerPasswordScenario,
    String? forgotPasswordScenario,
    String? resetPasswordScenario,
  }) =>
      AuthMockDataSource(
        latency: Duration.zero,
        loginScenario: loginScenario ?? MockAssets.loginSuccess,
        signUpScenario: signUpScenario ?? MockAssets.signupSuccess,
        logoutScenario: logoutScenario ?? MockAssets.logoutSuccess,
        verifyOtpScenario:
            verifyOtpScenario ?? MockAssets.verifyOtpForgotSuccess,
        registerPasswordScenario:
            registerPasswordScenario ?? MockAssets.registerPasswordSuccess,
        forgotPasswordScenario:
            forgotPasswordScenario ?? MockAssets.forgotPasswordSuccess,
        resetPasswordScenario:
            resetPasswordScenario ?? MockAssets.resetPasswordSuccess,
      );

  group('login', () {
    test('success → LoginDataDto with tokens', () async {
      final data = await source().login(login);
      expect(data, isA<LoginDataDto>());
      expect(data.challengeType, 'none');
      expect(data.accessToken, isNotNull);
    });

    test('otp_limit_exceeded → AccountBlockedException(otpLimitExceeded)',
        () async {
      await expectLater(
        source(loginScenario: MockAssets.loginOtpLimitExceeded).login(login),
        throwsA(
          isA<AccountBlockedException>()
              .having((e) => e.reason, 'reason', BlockReason.otpLimitExceeded),
        ),
      );
    });

    test('account_is_deleted → AccountBlockedException(accountDeleted)',
        () async {
      await expectLater(
        source(loginScenario: MockAssets.loginAccountIsDeleted).login(login),
        throwsA(
          isA<AccountBlockedException>()
              .having((e) => e.reason, 'reason', BlockReason.accountDeleted),
        ),
      );
    });

    test('failed → ServerException', () async {
      await expectLater(
        source(loginScenario: MockAssets.loginFailed).login(login),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('signUp', () {
    test('success → OtpChallengeDto', () async {
      final data = await source().signUp(signUp);
      expect(data, isA<OtpChallengeDto>());
      expect(data.sessionToken, isNotNull);
    });

    test('blocked → PhoneBlockedException', () async {
      await expectLater(
        source(signUpScenario: MockAssets.signupIsBlocked).signUp(signUp),
        throwsA(isA<PhoneBlockedException>()),
      );
    });

    test('failed → ServerException', () async {
      await expectLater(
        source(signUpScenario: MockAssets.signupFailed).signUp(signUp),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('verifyOtp', () {
    test('success → VerifyOtpDataDto', () async {
      final data = await source().verifyOtp(verifyOtp);
      expect(data, isA<VerifyOtpDataDto>());
    });

    test('incorrect → ServerException', () async {
      await expectLater(
        source(verifyOtpScenario: MockAssets.verifyOtpIncorrectFailed)
            .verifyOtp(verifyOtp),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('registerPassword', () {
    test('success → RegisterPasswordDataDto', () async {
      final data = await source().registerPassword(registerPassword);
      expect(data, isA<RegisterPasswordDataDto>());
    });

    test('failed → ServerException', () async {
      await expectLater(
        source(registerPasswordScenario: MockAssets.registerPasswordFailed)
            .registerPassword(registerPassword),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('forgotPassword', () {
    test('success → OtpChallengeDto', () async {
      final data = await source().forgotPassword(forgot);
      expect(data, isA<OtpChallengeDto>());
    });

    test('failed → ServerException', () async {
      await expectLater(
        source(forgotPasswordScenario: MockAssets.forgotPasswordFailed)
            .forgotPassword(forgot),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('resetPassword', () {
    test('success → completes', () async {
      await expectLater(source().resetPassword(reset), completes);
    });

    test('failed → ServerException', () async {
      await expectLater(
        source(resetPasswordScenario: MockAssets.resetPasswordFailed)
            .resetPassword(reset),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('logout', () {
    test('success → completes', () async {
      await expectLater(source().logout(), completes);
    });

    test('failed → ServerException', () async {
      await expectLater(
        source(logoutScenario: MockAssets.logoutFailed).logout(),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
