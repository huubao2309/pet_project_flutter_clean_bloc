import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import '../../environments/env.dart';
import '../../features/auth/data/datasources/auth_mock_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/datasources/pre_auth_session.dart';
import '../../features/auth/data/repositories/auth_repository_imp.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/use_cases/forgot_password_use_case.dart';
import '../../features/auth/domain/use_cases/is_logged_in_use_case.dart';
import '../../features/auth/domain/use_cases/login_use_case.dart';
import '../../features/auth/domain/use_cases/logout_use_case.dart';
import '../../features/auth/domain/use_cases/register_password_use_case.dart';
import '../../features/auth/domain/use_cases/reset_password_use_case.dart';
import '../../features/auth/domain/use_cases/sign_up_use_case.dart';
import '../../features/auth/domain/use_cases/verify_otp_use_case.dart';
import '../../features/auth/presentation/view_model/auth_view_model.dart';
import '../../features/auth/presentation/view_model/forgot_password_view_model.dart';
import '../../features/auth/presentation/view_model/sign_up_view_model.dart';
import '../../features/commission/presentation/view_model/commission_view_model.dart';
import '../../features/home/presentation/view_model/home_view_model.dart';
import '../../features/main/presentation/view_model/main_view_model.dart';
import '../../features/onboarding/presentation/view_model/billing_info_view_model.dart';
import '../../features/onboarding/presentation/view_model/personal_info_view_model.dart';
import '../../features/profile/data/datasources/user_mock_data_source.dart';
import '../../features/profile/data/datasources/user_remote_data_source.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/use_cases/change_password_use_case.dart';
import '../../features/profile/domain/use_cases/get_profile_use_case.dart';
import '../../features/profile/presentation/view_model/profile_view_model.dart';
import '../../features/app_update/data/datasources/app_update_mock_data_source.dart';
import '../../features/app_update/data/datasources/app_update_remote_data_source.dart';
import '../../features/app_update/data/repositories/app_update_repository_impl.dart';
import '../../features/app_update/domain/repositories/app_update_repository.dart';
import '../../features/app_update/domain/use_cases/check_app_update_use_case.dart';
import '../../features/app_update/domain/use_cases/dismiss_optional_update_use_case.dart';
import '../../features/app_update/domain/use_cases/open_store_use_case.dart';
import '../../features/app_update/presentation/app_update_overlay.dart';
import '../../features/splash/presentation/view_model/splash_view_model.dart';
import '../deep_link/deep_link_service.dart';
import '../localization/data/repositories/language_repository_impl.dart';
import '../localization/domain/repositories/language_repository.dart';
import '../localization/domain/use_cases/change_language_use_case.dart';
import '../localization/domain/use_cases/get_language_use_case.dart';
import '../network/dio_client.dart';
import '../network/http_client.dart';
import '../router/app_router.dart';
import '../security/data/repositories/device_session_repository_impl.dart';
import '../security/domain/repositories/device_session_repository.dart';
import '../security/domain/use_cases/clear_stale_secure_storage_use_case.dart';
import '../theme/benny_style_initializer.dart';
import '../theme/theme_view_model.dart';
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

  // --- Theme (Light/Dark mode controller; seeds from system on first launch) ---
  getIt.registerLazySingleton<ThemeViewModel>(
    () => ThemeViewModel(
      localStorage: getIt<LocalStorage>(),
      systemBrightness:
          WidgetsBinding.instance.platformDispatcher.platformBrightness,
    ),
  );

  // --- Security ---
  // Drops stale keychain data left over from an iOS reinstall. Registered here
  // but EXECUTED on the splash screen (SplashViewModel), so DI stays pure
  // wiring with no awaited I/O.
  getIt.registerLazySingleton<DeviceSessionRepository>(
    () => DeviceSessionRepositoryImpl(
      deviceInfo: DeviceInfoUtil.instance,
      localStorage: getIt<LocalStorage>(),
      secureStorage: getIt<SecureStorage>(),
    ),
  );
  getIt.registerLazySingleton(
    () => ClearStaleSecureStorageUseCase(
      repository: getIt<DeviceSessionRepository>(),
    ),
  );

  // --- Network ---
  // Registered behind the [HttpClient] port so data sources depend on the
  // abstraction (and can be unit-tested against a fake), not on Dio directly.
  getIt.registerSingleton<HttpClient>(
    DioClient(baseUrl: env.baseUrl, secureStorage: getIt<SecureStorage>(), envType: env.envType),
  );

  // --- Router ---
  getIt.registerSingleton<AppRouter>(AppRouter());

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
  _registerCommissionFeature();
  _registerProfileFeature();
  _registerMainFeature();
  _registerOnboardingFeature();
  _registerAppUpdateFeature();
}

/// App-update wiring (version check + force/optional prompts).
///
/// Swap the stub for the real backend by replacing the
/// [AppUpdateRemoteDataSource] registration with
/// `AppUpdateApiDataSource(httpClient: getIt<HttpClient>())`.
void _registerAppUpdateFeature() {
  // Data source — ONE line to switch fake data ⇄ real backend.
  getIt.registerLazySingleton<AppUpdateRemoteDataSource>(
    AppUpdateMockDataSource.new,
  );

  getIt.registerLazySingleton<AppUpdateRepository>(
    () => AppUpdateRepositoryImpl(
      remoteDataSource: getIt<AppUpdateRemoteDataSource>(),
      localStorage: getIt<LocalStorage>(),
    ),
  );

  getIt.registerLazySingleton(
    () => CheckAppUpdateUseCase(repository: getIt<AppUpdateRepository>()),
  );
  getIt.registerLazySingleton(
    () => DismissOptionalUpdateUseCase(repository: getIt<AppUpdateRepository>()),
  );
  getIt.registerLazySingleton(
    () => OpenStoreUseCase(repository: getIt<AppUpdateRepository>()),
  );

  // Presentation orchestrator: a singleton so its single-entry guard persists
  // for the app's lifetime. Triggered once from the splash screen.
  getIt.registerLazySingleton(
    () => AppUpdateOverlay(
      checkUseCase: getIt<CheckAppUpdateUseCase>(),
      dismissUseCase: getIt<DismissOptionalUpdateUseCase>(),
      openStoreUseCase: getIt<OpenStoreUseCase>(),
    ),
  );
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
    () => SplashViewModel(
      clearStaleSecureStorageUseCase: getIt<ClearStaleSecureStorageUseCase>(),
      isLoggedInUseCase: getIt<IsLoggedInUseCase>(),
      getLanguageUseCase: getIt<GetLanguageUseCase>(),
    ),
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

/// Profile feature wiring (the current user's account — backend `/user/*`).
///
/// Swap the stub for the real backend by replacing the [UserRemoteDataSource]
/// registration with `UserApiDataSource(httpClient: getIt<HttpClient>())`. Use
/// cases, view model and pages stay untouched.
void _registerProfileFeature() {
  getIt.registerLazySingleton<UserRemoteDataSource>(
    UserMockDataSource.new,
  );
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      remoteDataSource: getIt<UserRemoteDataSource>(),
    ),
  );
  getIt.registerLazySingleton(
    () => GetProfileUseCase(profileRepository: getIt<ProfileRepository>()),
  );
  // Change password is an authenticated account operation, so it lives with the
  // user/profile context (not auth, which handles the pre-auth session flows).
  getIt.registerLazySingleton(
    () => ChangePasswordUseCase(profileRepository: getIt<ProfileRepository>()),
  );
  // Factory: MainPage creates one instance and shares it with the Profile tab
  // via the widget tree (BlocProvider), so both see the same loaded profile.
  getIt.registerFactory(
    () => ProfileViewModel(getProfileUseCase: getIt<GetProfileUseCase>()),
  );
}

/// Commission (Hoa hồng) feature wiring.
void _registerCommissionFeature() {
  getIt.registerFactory(CommissionViewModel.new);
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
  //   • Real : AuthApiDataSource(httpClient: getIt<HttpClient>())
  getIt.registerLazySingleton<AuthRemoteDataSource>(AuthMockDataSource.new);

  // Transient holder for the pre-auth `session_token` (sign-up / forgot-password
  // flows). Singleton so every step of a flow shares the same instance.
  getIt.registerLazySingleton(PreAuthSession.new);

  // Repository — same impl for both data sources.
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      secureStorage: getIt<SecureStorage>(),
      preAuthSession: getIt<PreAuthSession>(),
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
    () => IsLoggedInUseCase(authRepository: getIt<AuthRepository>()),
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
  getIt.registerLazySingleton(
    () => VerifyOtpUseCase(authRepository: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton(
    () => RegisterPasswordUseCase(authRepository: getIt<AuthRepository>()),
  );

  // View models — factory so each screen gets a fresh instance.
  getIt.registerFactory(
    () => AuthViewModel(
      loginUseCase: getIt<LoginUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
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
