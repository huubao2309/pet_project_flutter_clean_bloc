import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../base/app_constants.dart';
import '../core/di/injection.dart';
import '../core/localization/domain/use_cases/get_language_use_case.dart';
import '../core/use_case/use_case.dart';
import '../main.dart';
import 'env_type.dart';

abstract class Env {
  abstract final String baseUrl;
  abstract final EnvType envType;

  Env() {
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    await EasyLocalization.ensureInitialized();

    await configureDependencies(this);

    _initStyle();
    _initProvider();
    _initServices();
    _initRepoAndUseCase();

    // Resolve the saved language HERE (before runApp) and pass it as the app's
    // startLocale. Applying it later (on the splash) would change the
    // locale-keyed MaterialApp and recreate the whole tree mid-launch — the
    // black flash on the splash→welcome transition.
    final startLocale = await _resolveStartLocale();

    runApp(MyApp(envType: envType, startLocale: startLocale));
    FlutterNativeSplash.remove();
  }

  /// The saved language, falling back to [AppConstants.fallbackLocale] when none
  /// is stored or it is not in the supported list.
  Future<Locale> _resolveStartLocale() async {
    final saved = await getIt<GetLanguageUseCase>().execute(const NoParams());
    final isSupported = saved != null &&
        AppConstants.supportedLocales
            .any((l) => l.languageCode == saved.languageCode);
    return isSupported ? saved : AppConstants.fallbackLocale;
  }

  Future<void> prepareForAppInitiation() async {}

  void _initProvider() {}

  void _initServices() {}

  void _initRepoAndUseCase() {}

  void _initStyle() {}
}
