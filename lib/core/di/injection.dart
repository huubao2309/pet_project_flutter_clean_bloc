import 'dart:async';

import 'package:get_it/get_it.dart';

import '../../environments/env.dart';
import '../../features/auth/data/datasources/auth_mock_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_imp.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/use_cases/forgot_password_use_case.dart';
import '../../features/auth/domain/use_cases/get_current_user_use_case.dart';
import '../../features/auth/domain/use_cases/login_use_case.dart';
import '../../features/auth/domain/use_cases/logout_use_case.dart';
import '../../features/auth/domain/use_cases/reset_password_use_case.dart';
import '../../features/auth/domain/use_cases/sign_up_use_case.dart';
import '../../features/auth/presentation/view_model/auth_view_model.dart';
import '../../features/auth/presentation/view_model/forgot_password_view_model.dart';
import '../../features/auth/presentation/view_model/sign_up_view_model.dart';
import '../../features/home/presentation/view_model/home_view_model.dart';
import '../../features/main/presentation/view_model/main_view_model.dart';
import '../../features/onboarding/presentation/view_model/billing_info_view_model.dart';
import '../../features/onboarding/presentation/view_model/personal_info_view_model.dart';
import '../../features/splash/presentation/view_model/splash_view_model.dart';
import '../deep_link/deep_link_service.dart';
import '../localization/data/repositories/language_repository_impl.dart';
import '../localization/domain/repositories/language_repository.dart';
import '../localization/domain/use_cases/change_language_use_case.dart';
import '../localization/domain/use_cases/get_language_use_case.dart';
import '../network/dio_client.dart';
import '../router/app_router.dart';
import '../theme/benny_style_initializer.dart';
import '../utils/device_info_util.dart';
import '../storage/local_storage/local_storage.dart';
import '../storage/local_storage/local_storage_impl.dart';
import '../storage/secure_storage/secure_storage.dart';
import '../storage/secure_storage/secure_storage_impl.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies(Env env) async {
  // --- Design system (must be ready before any widget builds) ---
  BennyStyleInitializer.ensureInitialized();

  // --- Device info (populates request headers) ---
  await DeviceInfoUtil.instance.setup();

  // --- Storage ---
  getIt.registerSingleton<LocalStorage>(await LocalStorageImpl.create());
  getIt.registerSingleton<SecureStorage>(await SecureStorageImpl.create());

  // --- Network ---
  getIt.registerSingleton<DioClient>(
    DioClient(baseUrl: env.baseUrl, secureStorage: getIt<SecureStorage>(), envType: env.envType),
  );

  // --- Router ---
  getIt.registerSingleton<AppRouter>(await AppRouter.create(getIt<SecureStorage>()));

  // --- Deep links ---
  getIt.registerSingleton<DeepLinkService>(
    DeepLinkService(router: getIt<AppRouter>()),
  );
  unawaited(getIt<DeepLinkService>().init());

  // --- Features ---
  _registerLocalizationFeature();
  _registerSplashFeature();
  _registerAuthFeature();
  _registerHomeFeature();
  _registerMainFeature();
  _registerOnboardingFeature();
}

/// Localization wiring (language preference get/set behind use cases).
void _registerLocalizationFeature() {
  getIt.registerLazySingleton<LanguageRepository>(
    () => LanguageRepositoryImpl(localStorage: getIt<LocalStorage>()),
  );
  getIt.registerLazySingleton(
    () => GetLanguageUseCase(languageRepository: getIt<LanguageRepository>()),
  );
  getIt.registerLazySingleton(
    () => ChangeLanguageUseCase(languageRepository: getIt<LanguageRepository>()),
  );
}

/// Splash bootstrap wiring.
void _registerSplashFeature() {
  getIt.registerFactory(
    () => SplashViewModel(getLanguageUseCase: getIt<GetLanguageUseCase>()),
  );
}

/// Main shell wiring.
void _registerMainFeature() {
  getIt.registerFactory(MainViewModel.new);
}

/// Home feature wiring.
void _registerHomeFeature() {
  getIt.registerFactory(HomeViewModel.new);
}

/// Onboarding feature wiring (pure form view models — no backend yet).
void _registerOnboardingFeature() {
  getIt.registerFactory(PersonalInfoViewModel.new);
  getIt.registerFactory(BillingInfoViewModel.new);
}

/// Auth feature wiring.
///
/// Swap the stub for the real backend by replacing the [AuthRepository]
/// registration with `AuthRepositoryImpl(authService: ..., secureStorage: ...)`.
/// Use cases, view models and pages stay untouched.
void _registerAuthFeature() {
  // Data source — ONE line to switch between fake data and the real backend:
  //   • Fake : AuthMockDataSource()            (serves assets/mock/*.json)
  //   • Real : AuthApiDataSource(dioClient: getIt<DioClient>())
  getIt.registerLazySingleton<AuthRemoteDataSource>(AuthMockDataSource.new);

  // Repository — same impl for both data sources.
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      secureStorage: getIt<SecureStorage>(),
    ),
  );

  // Use cases.
  getIt.registerLazySingleton(
    () => LoginUseCase(authRepository: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton(
    () => LogoutUseCase(authRepository: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetCurrentUserUseCase(authRepository: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton(
    () => SignUpUseCase(authRepository: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton(
    () => ForgotPasswordUseCase(authRepository: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton(
    () => ResetPasswordUseCase(authRepository: getIt<AuthRepository>()),
  );

  // View models — factory so each screen gets a fresh instance.
  getIt.registerFactory(
    () => AuthViewModel(
      loginUseCase: getIt<LoginUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
      getCurrentUserUseCase: getIt<GetCurrentUserUseCase>(),
    ),
  );
  getIt.registerFactory(
    () => SignUpViewModel(signUpUseCase: getIt<SignUpUseCase>()),
  );
  getIt.registerFactory(
    () => ForgotPasswordViewModel(
      forgotPasswordUseCase: getIt<ForgotPasswordUseCase>(),
    ),
  );
}
