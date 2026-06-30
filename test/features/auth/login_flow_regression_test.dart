import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_project_flutter_clean_bloc/core/error/app_error_code.dart';
import 'package:pet_project_flutter_clean_bloc/core/error/app_exception.dart';
import 'package:pet_project_flutter_clean_bloc/core/presentation/app_error_localizer.dart';
import 'package:pet_project_flutter_clean_bloc/core/storage/secure_storage/secure_storage.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/data/datasources/pre_auth_session.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/data/models/request/login_request_dto.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/data/models/response/login_data_dto.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/data/repositories/auth_repository_imp.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/use_cases/login_use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/use_cases/logout_use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/view_model/auth_state.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/view_model/auth_view_model.dart';

import '../../helpers/test_setup.dart';

/// Regression test for the **Login flow** — a vertical slice that wires the
/// real layers together (ViewModel → UseCase → RepositoryImpl → PreAuthSession)
/// and mocks only the outermost boundaries ([AuthRemoteDataSource] and
/// [SecureStorage]).
///
/// The per-layer unit tests already prove each piece in isolation; this guards
/// the *contract between them*. A refactor that, say, changes how the repository
/// maps `challenge_type` or how the view model reads `LoginResult` will pass the
/// isolated tests but break here — which is exactly the regression we want to
/// catch.
class _MockRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class _MockSecureStorage extends Mock implements SecureStorage {}

void main() {
  setUpAll(() async {
    // Keys-only localization: `.tr()` returns the key, so error copy is the
    // stable translation key (e.g. 'errors.login_failed').
    await ensureTestBinding();
    registerFallbackValue(const LoginRequestDto(phone: '', password: ''));
  });

  late _MockRemoteDataSource remote;
  late _MockSecureStorage secureStorage;
  late PreAuthSession preAuthSession;

  setUp(() {
    remote = _MockRemoteDataSource();
    secureStorage = _MockSecureStorage();
    preAuthSession = PreAuthSession();

    // Default storage stubs — the methods return Future<void>; leaving them
    // unstubbed would throw on the persistence step.
    when(() => secureStorage.saveAccessToken(any())).thenAnswer((_) async {});
    when(() => secureStorage.saveRefreshToken(any())).thenAnswer((_) async {});
    when(() => secureStorage.clearTokens()).thenAnswer((_) async {});
  });

  /// Builds the full, real object graph with only the boundaries mocked.
  AuthViewModel buildViewModel() {
    final repository = AuthRepositoryImpl(
      remoteDataSource: remote,
      secureStorage: secureStorage,
      preAuthSession: preAuthSession,
    );
    return AuthViewModel(
      loginUseCase: LoginUseCase(authRepository: repository),
      logoutUseCase: LogoutUseCase(authRepository: repository),
    );
  }

  /// Drives a [AuthViewModel] action and returns every state it emitted (after
  /// the microtask queue drains), mirroring the existing view-model tests.
  Future<List<AuthState>> capture(
    AuthViewModel vm,
    Future<void> Function() action,
  ) async {
    final states = <AuthState>[];
    final sub = vm.stream.listen(states.add);
    await action();
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();
    return states;
  }

  group('login flow — happy paths', () {
    test(
      'authenticated response: emits Loading→Authenticated and persists tokens',
      () async {
        when(() => remote.login(any())).thenAnswer(
          (_) async => const LoginDataDto(
            challengeType: 'none',
            accessToken: 'access-token',
            refreshToken: 'refresh-token',
          ),
        );
        final vm = buildViewModel();

        final states = await capture(
          vm,
          () => vm.login(phone: '0900000000', password: 'secret123'),
        );

        expect(states, [isA<AuthLoading>(), isA<AuthAuthenticated>()]);
        expect(vm.currentState, isA<AuthAuthenticated>());

        // The request DTO carried the user's exact input down the stack.
        final captured = verify(() => remote.login(captureAny()))
            .captured
            .single as LoginRequestDto;
        expect(captured.phone, '0900000000');
        expect(captured.password, 'secret123');

        // Tokens were persisted; no pre-auth session was opened.
        verify(() => secureStorage.saveAccessToken('access-token')).called(1);
        verify(() => secureStorage.saveRefreshToken('refresh-token')).called(1);
        expect(preAuthSession.token, isNull);

        await vm.close();
      },
    );

    test(
      'verify_otp response: emits Loading→OtpRequired, stashes the session '
      'token and persists no tokens',
      () async {
        when(() => remote.login(any())).thenAnswer(
          (_) async => const LoginDataDto(
            challengeType: 'verify_otp',
            sessionToken: 'pre-auth-session',
            otpResendSecs: 60,
            otpEnableResendSecs: 30,
          ),
        );
        final vm = buildViewModel();

        final states = await capture(
          vm,
          () => vm.login(phone: '0900000000', password: 'secret123'),
        );

        expect(states, [isA<AuthLoading>(), isA<AuthOtpRequired>()]);
        final challenge = (vm.currentState as AuthOtpRequired).challenge;
        expect(challenge.resendSecs, 60);
        expect(challenge.enableResendSecs, 30);

        // The pre-auth token is stashed for the OTP step; nothing persisted.
        expect(preAuthSession.token, 'pre-auth-session');
        verifyNever(() => secureStorage.saveAccessToken(any()));
        verifyNever(() => secureStorage.saveRefreshToken(any()));

        await vm.close();
      },
    );
  });

  group('login flow — failures', () {
    test(
      'malformed authenticated payload (missing tokens): surfaces AuthFailure '
      'and persists nothing',
      () async {
        // challenge_type "none" but no tokens → the repository fails fast.
        when(() => remote.login(any())).thenAnswer(
          (_) async => const LoginDataDto(
            challengeType: 'none',
            refreshToken: 'refresh-only',
          ),
        );
        final vm = buildViewModel();

        final states = await capture(
          vm,
          () => vm.login(phone: '0900000000', password: 'secret123'),
        );

        expect(states, [isA<AuthLoading>(), isA<AuthFailure>()]);
        expect(
          (vm.currentState as AuthFailure).message,
          AppErrorCode.loginFailed.localized, // 'errors.login_failed'
        );
        verifyNever(() => secureStorage.saveAccessToken(any()));
        verifyNever(() => secureStorage.saveRefreshToken(any()));

        await vm.close();
      },
    );

    test('wrong credentials (ServerException): surfaces AuthFailure', () async {
      when(() => remote.login(any()))
          .thenThrow(ServerException(message: 'Wrong phone or password'));
      final vm = buildViewModel();

      final states = await capture(
        vm,
        () => vm.login(phone: '0900000000', password: 'wrong-password'),
      );

      expect(states, [isA<AuthLoading>(), isA<AuthFailure>()]);
      expect(
        (vm.currentState as AuthFailure).message,
        'Wrong phone or password',
      );

      await vm.close();
    });

    test(
      'blocked account (AccountBlockedException): surfaces AuthBlocked with the '
      'reason — a hard stop, not a snackbar',
      () async {
        when(() => remote.login(any())).thenThrow(
          AccountBlockedException(
            BlockReason.otpLimitExceeded,
            'Too many tries',
          ),
        );
        final vm = buildViewModel();

        final states = await capture(
          vm,
          () => vm.login(phone: '0900000000', password: 'secret123'),
        );

        expect(states, [isA<AuthLoading>(), isA<AuthBlocked>()]);
        final blocked = vm.currentState as AuthBlocked;
        expect(blocked.reason, BlockReason.otpLimitExceeded);
        expect(blocked.message, 'Too many tries');

        await vm.close();
      },
    );

    test('network failure (NetworkException): surfaces AuthFailure', () async {
      when(() => remote.login(any()))
          .thenThrow(NetworkException(code: AppErrorCode.networkTimeout));
      final vm = buildViewModel();

      final states = await capture(
        vm,
        () => vm.login(phone: '0900000000', password: 'secret123'),
      );

      expect(states, [isA<AuthLoading>(), isA<AuthFailure>()]);
      expect(
        (vm.currentState as AuthFailure).message,
        AppErrorCode.networkTimeout.localized, // 'errors.network_timeout'
      );

      await vm.close();
    });
  });

  group('post-login recovery', () {
    test('reset returns the flow to AuthInitial after a hard stop', () async {
      when(() => remote.login(any())).thenThrow(
        AccountBlockedException(BlockReason.accountDeleted),
      );
      final vm = buildViewModel();
      await vm.login(phone: '0900000000', password: 'secret123');
      expect(vm.currentState, isA<AuthBlocked>());

      vm.reset();

      expect(vm.currentState, isA<AuthInitial>());
      await vm.close();
    });

    test('logout: emits Loading→Unauthenticated and clears tokens', () async {
      when(() => remote.logout()).thenAnswer((_) async {});
      final vm = buildViewModel();

      final states = await capture(vm, () => vm.logout());

      expect(states, [isA<AuthLoading>(), isA<AuthUnauthenticated>()]);
      verify(() => remote.logout()).called(1);
      verify(() => secureStorage.clearTokens()).called(1);

      await vm.close();
    });

    test('logout failure: surfaces AuthFailure and keeps tokens', () async {
      when(() => remote.logout())
          .thenThrow(ServerException(code: AppErrorCode.logoutFailed));
      final vm = buildViewModel();

      final states = await capture(vm, () => vm.logout());

      expect(states, [isA<AuthLoading>(), isA<AuthFailure>()]);
      verifyNever(() => secureStorage.clearTokens());

      await vm.close();
    });
  });
}
