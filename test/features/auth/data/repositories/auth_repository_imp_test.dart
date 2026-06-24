import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_project_flutter_clean_bloc/core/error/app_exception.dart';
import 'package:pet_project_flutter_clean_bloc/core/storage/secure_storage/secure_storage.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/data/datasources/pre_auth_session.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/data/models/request/forgot_password_request_dto.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/data/models/request/login_request_dto.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/data/models/request/register_password_request_dto.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/data/models/request/reset_password_request_dto.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/data/models/request/sign_up_request_dto.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/data/models/request/verify_otp_request_dto.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/data/models/response/login_data_dto.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/data/models/response/otp_challenge_dto.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/data/models/response/register_password_data_dto.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/data/models/response/verify_otp_data_dto.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/data/repositories/auth_repository_imp.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/entities/login_result.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/entities/otp_challenge.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/entities/sign_up_result.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/entities/verify_otp_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockSecureStorage extends Mock implements SecureStorage {}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await EasyLocalization.ensureInitialized();

    registerFallbackValue(const LoginRequestDto(phone: '', password: ''));
    registerFallbackValue(
      const SignUpRequestDto(phone: '', language: 'en'),
    );
    registerFallbackValue(
      const VerifyOtpRequestDto(code: '', sessionToken: ''),
    );
    registerFallbackValue(
      const RegisterPasswordRequestDto(password: '', sessionToken: ''),
    );
    registerFallbackValue(const ForgotPasswordRequestDto(phone: ''));
    registerFallbackValue(
      const ResetPasswordRequestDto(newPassword: '', sessionToken: ''),
    );
  });

  late MockAuthRemoteDataSource remote;
  late MockSecureStorage secureStorage;
  late PreAuthSession session;
  late AuthRepositoryImpl repository;

  setUp(() {
    remote = MockAuthRemoteDataSource();
    secureStorage = MockSecureStorage();
    session = PreAuthSession();
    repository = AuthRepositoryImpl(
      remoteDataSource: remote,
      secureStorage: secureStorage,
      preAuthSession: session,
    );

    // Default void token writes succeed.
    when(() => secureStorage.saveAccessToken(any()))
        .thenAnswer((_) async {});
    when(() => secureStorage.saveRefreshToken(any()))
        .thenAnswer((_) async {});
    when(() => secureStorage.clearTokens()).thenAnswer((_) async {});
  });

  group('login', () {
    test('OTP challenge: stashes session token and returns LoginOtpRequired',
        () async {
      when(() => remote.login(any())).thenAnswer(
        (_) async => const LoginDataDto(
          challengeType: 'verify_otp',
          sessionToken: 'sess-1',
          otpResendSecs: 30,
          otpEnableResendSecs: 10,
        ),
      );

      final result = await repository.login(phone: '0900', password: 'pw');

      expect(result, isA<LoginOtpRequired>());
      final challenge = (result as LoginOtpRequired).challenge;
      expect(challenge.resendSecs, 30);
      expect(challenge.enableResendSecs, 10);
      // Pre-auth session token stashed for verify-otp.
      expect(session.token, 'sess-1');
      // No tokens persisted on a challenge.
      verifyNever(() => secureStorage.saveAccessToken(any()));
      verifyNever(() => secureStorage.saveRefreshToken(any()));
    });

    test('OTP challenge with null timers defaults them to 0', () async {
      when(() => remote.login(any())).thenAnswer(
        (_) async => const LoginDataDto(challengeType: 'verify_otp'),
      );

      final result = await repository.login(phone: '0900', password: 'pw');

      final challenge = (result as LoginOtpRequired).challenge;
      expect(challenge.resendSecs, 0);
      expect(challenge.enableResendSecs, 0);
      // Null session token stashed as empty string.
      expect(session.token, '');
    });

    test('builds the LoginRequestDto from phone + password', () async {
      when(() => remote.login(any())).thenAnswer(
        (_) async => const LoginDataDto(
          accessToken: 'a',
          refreshToken: 'r',
        ),
      );

      await repository.login(phone: '0911', password: 'secret');

      final captured =
          verify(() => remote.login(captureAny())).captured.single
              as LoginRequestDto;
      expect(captured.phone, '0911');
      expect(captured.password, 'secret');
    });

    test('authenticated: persists tokens and returns LoginAuthenticated',
        () async {
      when(() => remote.login(any())).thenAnswer(
        (_) async => const LoginDataDto(
          accessToken: 'access',
          refreshToken: 'refresh',
        ),
      );

      final result = await repository.login(phone: '0900', password: 'pw');

      expect(result, isA<LoginAuthenticated>());
      verify(() => secureStorage.saveAccessToken('access')).called(1);
      verify(() => secureStorage.saveRefreshToken('refresh')).called(1);
    });

    test('missing access token throws ServerException, persists nothing',
        () async {
      when(() => remote.login(any())).thenAnswer(
        (_) async => const LoginDataDto(refreshToken: 'refresh'),
      );

      await expectLater(
        repository.login(phone: '0900', password: 'pw'),
        throwsA(isA<ServerException>()),
      );
      verifyNever(() => secureStorage.saveAccessToken(any()));
      verifyNever(() => secureStorage.saveRefreshToken(any()));
    });

    test('missing refresh token throws ServerException', () async {
      when(() => remote.login(any())).thenAnswer(
        (_) async => const LoginDataDto(accessToken: 'access'),
      );

      await expectLater(
        repository.login(phone: '0900', password: 'pw'),
        throwsA(
          isA<ServerException>()
              .having((e) => e.message, 'message', isNotEmpty),
        ),
      );
      verifyNever(() => secureStorage.saveAccessToken(any()));
    });
  });

  group('signUp', () {
    test('OTP required: stashes session token and returns SignUpOtpRequired',
        () async {
      when(() => remote.signUp(any())).thenAnswer(
        (_) async => const OtpChallengeDto(
          challengeType: 'verify_otp',
          sessionToken: 'sess-su',
          otpResendSecs: 20,
          otpEnableResendSecs: 5,
        ),
      );

      final result = await repository.signUp(phone: '0900');

      expect(result, isA<SignUpOtpRequired>());
      final challenge = (result as SignUpOtpRequired).challenge;
      expect(challenge.resendSecs, 20);
      expect(challenge.enableResendSecs, 5);
      expect(session.token, 'sess-su');
    });

    test('no challenge: returns SignUpCompleted and stashes nothing',
        () async {
      when(() => remote.signUp(any())).thenAnswer(
        (_) async => const OtpChallengeDto(),
      );

      final result = await repository.signUp(phone: '0900');

      expect(result, isA<SignUpCompleted>());
      expect(session.token, isNull);
    });

    test('builds SignUpRequestDto with default language and receiveUpdates',
        () async {
      when(() => remote.signUp(any())).thenAnswer(
        (_) async => const OtpChallengeDto(),
      );

      await repository.signUp(phone: '0922', receiveUpdates: true);

      final dto = verify(() => remote.signUp(captureAny())).captured.single
          as SignUpRequestDto;
      expect(dto.phone, '0922');
      expect(dto.language, 'en');
      expect(dto.statusUpdate, true);
    });

    test('null session token on challenge is stashed as empty string',
        () async {
      when(() => remote.signUp(any())).thenAnswer(
        (_) async => const OtpChallengeDto(challengeType: 'verify_otp'),
      );

      await repository.signUp(phone: '0900');
      expect(session.token, '');
    });
  });

  group('verifyOtp', () {
    test('requires an active pre-auth session', () async {
      // No session saved -> require() throws StateError before any remote call.
      await expectLater(
        repository.verifyOtp(code: '1234'),
        throwsStateError,
      );
      verifyNever(() => remote.verifyOtp(any()));
    });

    test('passes code and session token to the data source', () async {
      session.save('the-session');
      when(() => remote.verifyOtp(any())).thenAnswer(
        (_) async => const VerifyOtpDataDto(challengeType: 'none'),
      );

      await repository.verifyOtp(code: '4321');

      final dto = verify(() => remote.verifyOtp(captureAny())).captured.single
          as VerifyOtpRequestDto;
      expect(dto.code, '4321');
      expect(dto.sessionToken, 'the-session');
    });

    test('authenticated with tokens: persists tokens and clears session',
        () async {
      session.save('s');
      when(() => remote.verifyOtp(any())).thenAnswer(
        (_) async => const VerifyOtpDataDto(
          challengeType: 'none',
          accessToken: 'a',
          refreshToken: 'r',
        ),
      );

      final result = await repository.verifyOtp(code: '1234');

      expect(result, isA<VerifyOtpAuthenticated>());
      verify(() => secureStorage.saveAccessToken('a')).called(1);
      verify(() => secureStorage.saveRefreshToken('r')).called(1);
      expect(session.token, isNull);
    });

    test('authenticated without tokens: skips persistence but clears session',
        () async {
      session.save('s');
      when(() => remote.verifyOtp(any())).thenAnswer(
        (_) async => const VerifyOtpDataDto(challengeType: 'none'),
      );

      final result = await repository.verifyOtp(code: '1234');

      expect(result, isA<VerifyOtpAuthenticated>());
      verifyNever(() => secureStorage.saveAccessToken(any()));
      verifyNever(() => secureStorage.saveRefreshToken(any()));
      expect(session.token, isNull);
    });

    test('register_password: stashes new session token, returns marker',
        () async {
      session.save('old');
      when(() => remote.verifyOtp(any())).thenAnswer(
        (_) async => const VerifyOtpDataDto(
          challengeType: 'register_password',
          sessionToken: 'new-session',
        ),
      );

      final result = await repository.verifyOtp(code: '1234');

      expect(result, isA<VerifyOtpRegisterPassword>());
      expect(session.token, 'new-session');
      verifyNever(() => secureStorage.saveAccessToken(any()));
    });

    test('reset_password: stashes new session token, returns marker',
        () async {
      session.save('old');
      when(() => remote.verifyOtp(any())).thenAnswer(
        (_) async => const VerifyOtpDataDto(
          challengeType: 'reset_password',
          sessionToken: 'reset-session',
        ),
      );

      final result = await repository.verifyOtp(code: '1234');

      expect(result, isA<VerifyOtpResetPassword>());
      expect(session.token, 'reset-session');
    });

    test('unknown challenge type: clears session, returns Authenticated',
        () async {
      session.save('old');
      when(() => remote.verifyOtp(any())).thenAnswer(
        (_) async => const VerifyOtpDataDto(challengeType: 'mystery'),
      );

      final result = await repository.verifyOtp(code: '1234');

      expect(result, isA<VerifyOtpAuthenticated>());
      expect(session.token, isNull);
    });

    test('register_password with null session token stashes empty string',
        () async {
      session.save('old');
      when(() => remote.verifyOtp(any())).thenAnswer(
        (_) async =>
            const VerifyOtpDataDto(challengeType: 'register_password'),
      );

      await repository.verifyOtp(code: '1234');
      expect(session.token, '');
    });
  });

  group('registerPassword', () {
    test('requires an active pre-auth session', () async {
      await expectLater(
        repository.registerPassword(password: 'pw'),
        throwsStateError,
      );
      verifyNever(() => remote.registerPassword(any()));
    });

    test('success: persists tokens and clears session', () async {
      session.save('s');
      when(() => remote.registerPassword(any())).thenAnswer(
        (_) async => const RegisterPasswordDataDto(
          accessToken: 'a',
          refreshToken: 'r',
        ),
      );

      await repository.registerPassword(password: 'pw');

      final dto = verify(() => remote.registerPassword(captureAny()))
          .captured
          .single as RegisterPasswordRequestDto;
      expect(dto.password, 'pw');
      expect(dto.sessionToken, 's');
      verify(() => secureStorage.saveAccessToken('a')).called(1);
      verify(() => secureStorage.saveRefreshToken('r')).called(1);
      expect(session.token, isNull);
    });

    test('missing tokens throws ServerException and keeps session', () async {
      session.save('s');
      when(() => remote.registerPassword(any())).thenAnswer(
        (_) async => const RegisterPasswordDataDto(accessToken: 'a'),
      );

      await expectLater(
        repository.registerPassword(password: 'pw'),
        throwsA(isA<ServerException>()),
      );
      verifyNever(() => secureStorage.saveAccessToken(any()));
      // Session is not cleared on failure.
      expect(session.token, 's');
    });
  });

  group('forgotPassword', () {
    test('stashes session token and returns the OTP challenge entity',
        () async {
      when(() => remote.forgotPassword(any())).thenAnswer(
        (_) async => const OtpChallengeDto(
          challengeType: 'verify_otp',
          sessionToken: 'fp-session',
          otpResendSecs: 15,
          otpEnableResendSecs: 3,
        ),
      );

      final challenge = await repository.forgotPassword(phone: '0900');

      expect(challenge, isA<OtpChallenge>());
      expect(challenge.resendSecs, 15);
      expect(challenge.enableResendSecs, 3);
      expect(session.token, 'fp-session');

      final dto = verify(() => remote.forgotPassword(captureAny()))
          .captured
          .single as ForgotPasswordRequestDto;
      expect(dto.phone, '0900');
    });

    test('null session token stashed as empty string', () async {
      when(() => remote.forgotPassword(any())).thenAnswer(
        (_) async => const OtpChallengeDto(),
      );

      await repository.forgotPassword(phone: '0900');
      expect(session.token, '');
    });
  });

  group('resetPassword', () {
    test('requires an active pre-auth session', () async {
      await expectLater(
        repository.resetPassword(newPassword: 'pw'),
        throwsStateError,
      );
      verifyNever(() => remote.resetPassword(any()));
    });

    test('sends new password + session token, then clears the session',
        () async {
      session.save('reset-s');
      when(() => remote.resetPassword(any())).thenAnswer((_) async {});

      await repository.resetPassword(newPassword: 'newpw');

      final dto = verify(() => remote.resetPassword(captureAny()))
          .captured
          .single as ResetPasswordRequestDto;
      expect(dto.newPassword, 'newpw');
      expect(dto.sessionToken, 'reset-s');
      expect(session.token, isNull);
    });
  });

  group('logout', () {
    test('clears tokens after a successful remote logout', () async {
      when(() => remote.logout()).thenAnswer((_) async {});

      await repository.logout();

      verify(() => remote.logout()).called(1);
      verify(() => secureStorage.clearTokens()).called(1);
    });

    test('does not clear tokens when remote logout throws', () async {
      when(() => remote.logout()).thenThrow(ServerException(message: 'boom'));

      await expectLater(repository.logout(), throwsA(isA<ServerException>()));
      verifyNever(() => secureStorage.clearTokens());
    });
  });

  group('isLoggedIn', () {
    test('true when an access token exists', () async {
      when(() => secureStorage.getAccessToken())
          .thenAnswer((_) async => 'token');
      expect(await repository.isLoggedIn(), isTrue);
    });

    test('false when no access token', () async {
      when(() => secureStorage.getAccessToken())
          .thenAnswer((_) async => null);
      expect(await repository.isLoggedIn(), isFalse);
    });
  });
}
