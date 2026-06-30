import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_project_flutter_clean_bloc/core/use_case/use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/entities/login_result.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/entities/otp_challenge.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/entities/sign_up_result.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/entities/verify_otp_result.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/repositories/auth_repository.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/use_cases/forgot_password_use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/use_cases/is_logged_in_use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/use_cases/login_use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/use_cases/logout_use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/use_cases/register_password_use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/use_cases/reset_password_use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/use_cases/verify_otp_use_case.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repo;

  setUp(() {
    repo = MockAuthRepository();
  });

  group('LoginUseCase', () {
    test('delegates to repository.login and returns its result', () async {
      const expected = LoginAuthenticated();
      when(
        () => repo.login(
          phone: any(named: 'phone'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => expected);

      final useCase = LoginUseCase(authRepository: repo);
      final result = await useCase.execute(
        const LoginParams(phone: '0900', password: 'secret'),
      );

      expect(result, same(expected));
      verify(() => repo.login(phone: '0900', password: 'secret')).called(1);
    });

    test('propagates OTP-required result', () async {
      const expected = LoginOtpRequired(
        OtpChallenge(resendSecs: 60, enableResendSecs: 0),
      );
      when(
        () => repo.login(
          phone: any(named: 'phone'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => expected);

      final result = await LoginUseCase(authRepository: repo)
          .execute(const LoginParams(phone: 'p', password: 'q'));

      expect(result, isA<LoginOtpRequired>());
    });
  });

  group('SignUpUseCase', () {
    test('delegates with phone and receiveUpdates', () async {
      const expected = SignUpCompleted();
      when(
        () => repo.signUp(
          phone: any(named: 'phone'),
          receiveUpdates: any(named: 'receiveUpdates'),
        ),
      ).thenAnswer((_) async => expected);

      final result = await SignUpUseCase(authRepository: repo).execute(
        const SignUpParams(phone: '0911', receiveUpdates: true),
      );

      expect(result, same(expected));
      verify(() => repo.signUp(phone: '0911', receiveUpdates: true)).called(1);
    });

    test('defaults receiveUpdates to false', () async {
      when(
        () => repo.signUp(
          phone: any(named: 'phone'),
          receiveUpdates: any(named: 'receiveUpdates'),
        ),
      ).thenAnswer((_) async => const SignUpCompleted());

      await SignUpUseCase(authRepository: repo)
          .execute(const SignUpParams(phone: '0911'));

      verify(() => repo.signUp(phone: '0911', receiveUpdates: false)).called(1);
    });
  });

  group('VerifyOtpUseCase', () {
    test('delegates code to repository.verifyOtp', () async {
      const expected = VerifyOtpAuthenticated();
      when(() => repo.verifyOtp(code: any(named: 'code')))
          .thenAnswer((_) async => expected);

      final result =
          await VerifyOtpUseCase(authRepository: repo).execute('123456');

      expect(result, same(expected));
      verify(() => repo.verifyOtp(code: '123456')).called(1);
    });
  });

  group('RegisterPasswordUseCase', () {
    test('delegates password to repository.registerPassword', () async {
      when(() => repo.registerPassword(password: any(named: 'password')))
          .thenAnswer((_) async {});

      await RegisterPasswordUseCase(authRepository: repo).execute('newpass');

      verify(() => repo.registerPassword(password: 'newpass')).called(1);
    });
  });

  group('ForgotPasswordUseCase', () {
    test('delegates phone and returns the challenge', () async {
      const expected = OtpChallenge(resendSecs: 120, enableResendSecs: 30);
      when(() => repo.forgotPassword(phone: any(named: 'phone')))
          .thenAnswer((_) async => expected);

      final result =
          await ForgotPasswordUseCase(authRepository: repo).execute('0900');

      expect(result, same(expected));
      verify(() => repo.forgotPassword(phone: '0900')).called(1);
    });
  });

  group('ResetPasswordUseCase', () {
    test('delegates newPassword to repository.resetPassword', () async {
      when(() => repo.resetPassword(newPassword: any(named: 'newPassword')))
          .thenAnswer((_) async {});

      await ResetPasswordUseCase(authRepository: repo).execute('reset123');

      verify(() => repo.resetPassword(newPassword: 'reset123')).called(1);
    });
  });

  group('LogoutUseCase', () {
    test('delegates to repository.logout', () async {
      when(() => repo.logout()).thenAnswer((_) async {});

      await LogoutUseCase(authRepository: repo).execute(const NoParams());

      verify(() => repo.logout()).called(1);
    });
  });

  group('IsLoggedInUseCase', () {
    test('returns repository.isLoggedIn result', () async {
      when(() => repo.isLoggedIn()).thenAnswer((_) async => true);

      final result = await IsLoggedInUseCase(authRepository: repo)
          .execute(const NoParams());

      expect(result, isTrue);
      verify(() => repo.isLoggedIn()).called(1);
    });
  });
}
