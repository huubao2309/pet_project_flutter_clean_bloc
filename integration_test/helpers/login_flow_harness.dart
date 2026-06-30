import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/di/injection.dart';
import 'package:pet_project_flutter_clean_bloc/core/storage/secure_storage/secure_storage.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/data/datasources/auth_mock_data_source.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/data/datasources/pre_auth_session.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/data/repositories/auth_repository_imp.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/repositories/auth_repository.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/use_cases/login_use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/use_cases/sign_up_use_case.dart';

/// Re-points the fake auth backend at [scenario] with zero latency, for a
/// deterministic, instant login response.
///
/// Why this re-registers the whole login chain (data source → repository → use
/// case) and not just the data source: the splash screen resolves the
/// `AuthRepository` during bootstrap (via `IsLoggedInUseCase`), so by the time a
/// test runs, the repository singleton has already captured the DEFAULT data
/// source. Replacing only the data source would be a no-op. Rebuilding the
/// repository and `LoginUseCase` here makes the login page resolve the chain
/// that uses [scenario]. (`IsLoggedInUseCase` keeps its already-resolved
/// instance — that's fine, the splash check is already done.)
void useLoginScenario(String scenario) {
  _reregister<AuthRemoteDataSource>(
    () => AuthMockDataSource(loginScenario: scenario, latency: Duration.zero),
  );
  _reregister<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      secureStorage: getIt<SecureStorage>(),
      preAuthSession: getIt<PreAuthSession>(),
    ),
  );
  _reregister<LoginUseCase>(
    () => LoginUseCase(authRepository: getIt<AuthRepository>()),
  );
}

/// Same idea as [useLoginScenario], but for the sign-up flow: re-points the
/// fake backend's sign-up endpoint at [scenario] (zero latency) and rebuilds the
/// repository + `SignUpUseCase` so the sign-up page resolves a chain that uses
/// it (the splash already cached the default repository — see [useLoginScenario]).
void useSignUpScenario(String scenario) {
  _reregister<AuthRemoteDataSource>(
    () => AuthMockDataSource(signUpScenario: scenario, latency: Duration.zero),
  );
  _reregister<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      secureStorage: getIt<SecureStorage>(),
      preAuthSession: getIt<PreAuthSession>(),
    ),
  );
  _reregister<SignUpUseCase>(
    () => SignUpUseCase(authRepository: getIt<AuthRepository>()),
  );
}

void _reregister<T extends Object>(T Function() factory) {
  if (getIt.isRegistered<T>()) {
    getIt.unregister<T>();
  }
  getIt.registerLazySingleton<T>(factory);
}

/// Pumps frames at a fixed cadence until [finder] matches or the budget runs
/// out. Used instead of [WidgetTester.pumpAndSettle] because the splash spinner
/// and the login button's loading spinner animate indefinitely — pumpAndSettle
/// would never settle.
Future<void> pumpUntil(
  WidgetTester tester,
  Finder finder, {
  int maxFrames = 200,
  Duration step = const Duration(milliseconds: 100),
}) async {
  for (var frame = 0; frame < maxFrames; frame++) {
    await tester.pump(step);
    if (finder.evaluate().isNotEmpty) {
      return;
    }
  }
  throw TestFailure(
    'Timed out after ${maxFrames * step.inMilliseconds}ms waiting for: $finder',
  );
}
