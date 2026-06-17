import 'dart:ui' show Locale;

import '../../../../base/app_constants.dart';
import '../../../../core/presentation/view_model.dart';
import '../../../../core/use_case/use_case.dart';
import '../../../../core/localization/domain/use_cases/get_language_use_case.dart';
import 'splash_state.dart';

/// Bootstraps the app on the splash screen: resolves the saved language.
///
/// It only reads the language (via [GetLanguageUseCase]) and exposes the
/// resolved [Locale] through state. Applying it (`context.setLocale`) and
/// navigating is done by the View — the view model stays free of BuildContext.
class SplashViewModel extends ViewModel<SplashState> {
  SplashViewModel({required GetLanguageUseCase getLanguageUseCase})
      : _getLanguageUseCase = getLanguageUseCase,
        super(const SplashLoading());

  final GetLanguageUseCase _getLanguageUseCase;

  Future<void> bootstrap() async {
    final saved = await _getLanguageUseCase.execute(const NoParams());
    setState(SplashReady(_resolveSupported(saved)));
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
