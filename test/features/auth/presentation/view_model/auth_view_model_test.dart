import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_project_flutter_clean_bloc/core/error/app_exception.dart';
import 'package:pet_project_flutter_clean_bloc/core/use_case/use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/entities/login_result.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/entities/otp_challenge.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/use_cases/login_use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/use_cases/logout_use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/view_model/auth_state.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/view_model/auth_view_model.dart';

import '../../../../helpers/test_setup.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

void main() {
  setUpAll(() async {
    await ensureTestBinding();
    registerFallbackValue(const LoginParams(phone: '', password: ''));
    registerFallbackValue(const NoParams());
  });

  late MockLoginUseCase loginUseCase;
  late MockLogoutUseCase logoutUseCase;

  setUp(() {
    loginUseCase = MockLoginUseCase();
    logoutUseCase = MockLogoutUseCase();
  });

  AuthViewModel build() => AuthViewModel(
        loginUseCase: loginUseCase,
        logoutUseCase: logoutUseCase,
      );

  test('starts in AuthInitial', () {
    final vm = build();
    expect(vm.currentState, isA<AuthInitial>());
    vm.close();
  });

  group('login', () {
    test('emits Loading then Authenticated when result is authenticated',
        () async {
      when(() => loginUseCase.execute(any()))
          .thenAnswer((_) async => const LoginAuthenticated());
      final vm = build();
      final states = <AuthState>[];
      final sub = vm.stream.listen(states.add);

      await vm.login(phone: '0900000000', password: 'secret');
      await Future<void>.delayed(Duration.zero);
      await sub.cancel();

      expect(states, [isA<AuthLoading>(), isA<AuthAuthenticated>()]);
      expect(vm.currentState, isA<AuthAuthenticated>());
      await vm.close();
    });

    test('emits Loading then OtpRequired carrying the challenge', () async {
      const challenge = OtpChallenge(resendSecs: 60, enableResendSecs: 30);
      when(() => loginUseCase.execute(any()))
          .thenAnswer((_) async => const LoginOtpRequired(challenge));
      final vm = build();
      final states = <AuthState>[];
      final sub = vm.stream.listen(states.add);

      await vm.login(phone: '0900000000', password: 'secret');
      await Future<void>.delayed(Duration.zero);
      await sub.cancel();

      expect(states, [isA<AuthLoading>(), isA<AuthOtpRequired>()]);
      expect((vm.currentState as AuthOtpRequired).challenge, same(challenge));
      await vm.close();
    });

    test('emits Blocked on AccountBlockedException', () async {
      when(() => loginUseCase.execute(any())).thenThrow(
        AccountBlockedException(BlockReason.accountDeleted, 'gone'),
      );
      final vm = build();
      final states = <AuthState>[];
      final sub = vm.stream.listen(states.add);

      await vm.login(phone: '0900000000', password: 'secret');
      await Future<void>.delayed(Duration.zero);
      await sub.cancel();

      expect(states, [isA<AuthLoading>(), isA<AuthBlocked>()]);
      final blocked = vm.currentState as AuthBlocked;
      expect(blocked.reason, BlockReason.accountDeleted);
      expect(blocked.message, 'gone');
      await vm.close();
    });

    test('emits Failure on generic AppException', () async {
      when(() => loginUseCase.execute(any()))
          .thenThrow(ServerException(message: 'boom'));
      final vm = build();
      final states = <AuthState>[];
      final sub = vm.stream.listen(states.add);

      await vm.login(phone: '0900000000', password: 'secret');
      await Future<void>.delayed(Duration.zero);
      await sub.cancel();

      expect(states, [isA<AuthLoading>(), isA<AuthFailure>()]);
      expect((vm.currentState as AuthFailure).message, 'boom');
      await vm.close();
    });
  });

  group('logout', () {
    test('emits Loading then Unauthenticated on success', () async {
      when(() => logoutUseCase.execute(any())).thenAnswer((_) async {});
      final vm = build();
      final states = <AuthState>[];
      final sub = vm.stream.listen(states.add);

      await vm.logout();
      await Future<void>.delayed(Duration.zero);
      await sub.cancel();

      expect(states, [isA<AuthLoading>(), isA<AuthUnauthenticated>()]);
      await vm.close();
    });

    test('emits Failure when logout throws', () async {
      when(() => logoutUseCase.execute(any()))
          .thenThrow(ServerException(message: 'no'));
      final vm = build();
      final states = <AuthState>[];
      final sub = vm.stream.listen(states.add);

      await vm.logout();
      await Future<void>.delayed(Duration.zero);
      await sub.cancel();

      expect(states, [isA<AuthLoading>(), isA<AuthFailure>()]);
      expect((vm.currentState as AuthFailure).message, 'no');
      await vm.close();
    });
  });

  test('reset returns to AuthInitial', () async {
    final vm = build();
    final states = <AuthState>[];
    final sub = vm.stream.listen(states.add);

    vm.reset();
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();

    expect(states, [isA<AuthInitial>()]);
    await vm.close();
  });
}
