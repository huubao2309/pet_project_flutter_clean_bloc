import 'dart:ui' show Locale;

import '../../../../base/app_constants.dart';
import '../../../../core/localization/domain/use_cases/get_language_use_case.dart';
import '../../../../core/presentation/view_model.dart';
import '../../../../core/security/domain/use_cases/clear_stale_secure_storage_use_case.dart';
import '../../../../core/use_case/use_case.dart';
import '../../../auth/domain/use_cases/is_logged_in_use_case.dart';
import 'splash_state.dart';

/// Bootstraps the app on the splash screen, in order:
///  1. Drop stale keychain data left over from a previous iOS install.
///  2. Resolve the auth state (token) — now reliable after step 1.
///  3. Resolve the saved language.
///
/// Keeping this here (instead of in DI) lets dependency injection stay pure
/// wiring with no awaited I/O. The View applies the locale, sets the auth flag
/// and navigates — this view model never touches BuildContext.
class SplashViewModel extends ViewModel<SplashState> {
  SplashViewModel({
    required ClearStaleSecureStorageUseCase clearStaleSecureStorageUseCase,
    required IsLoggedInUseCase isLoggedInUseCase,
    required GetLanguageUseCase getLanguageUseCase,
  })  : _clearStaleSecureStorageUseCase = clearStaleSecureStorageUseCase,
        _isLoggedInUseCase = isLoggedInUseCase,
        _getLanguageUseCase = getLanguageUseCase,
        super(const SplashLoading());

  final ClearStaleSecureStorageUseCase _clearStaleSecureStorageUseCase;
  final IsLoggedInUseCase _isLoggedInUseCase;
  final GetLanguageUseCase _getLanguageUseCase;

  Future<void> bootstrap() async {
    await _clearStaleSecureStorageUseCase.execute(const NoParams());
    final isLoggedIn = await _isLoggedInUseCase.execute(const NoParams());
    final saved = await _getLanguageUseCase.execute(const NoParams());
    setState(
      SplashReady(locale: _resolveSupported(saved), isLoggedIn: isLoggedIn),
    );
  }

  /// Falls back to [AppConstants.fallbackLocale] if there is no saved language
  /// or it is not in the supported list (setLocale would throw otherwise).
  Locale _resolveSupported(Locale? saved) {
    final isSupported = saved != null &&
        AppConstants.supportedLocales
            .any((l) => l.languageCode == saved.languageCode);
    return isSupported ? saved : AppConstants.fallbackLocale;
  }
}
