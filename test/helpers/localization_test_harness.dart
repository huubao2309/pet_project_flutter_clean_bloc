// ignore_for_file: implementation_imports
//
// `Localization` and `Translations` are not exported from the public
// easy_localization surface, but the context-free `'key'.tr()` extension used
// all over the app (models, view models, widgets, screens) resolves against the
// global `Localization.instance`. Loading that instance directly is the only way
// to make `.tr()` behave deterministically in a plain `flutter test` without
// pumping the whole `EasyLocalization` widget — so we reach into `src` here, in
// test code only.
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/src/localization.dart';
import 'package:easy_localization/src/translations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/base/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Reusable easy_localization test harness.
///
/// Call ONE of the setup methods in `setUp`/`setUpAll` before exercising any
/// code that uses `.tr()` (a model, a view model, a widget, a screen). After
/// that, `'some.key'.tr()` no longer throws and resolves the way you chose:
///
/// ```dart
/// // Model / view-model test — keys are enough, no assets needed:
/// setUpAll(LocalizationTestHarness.useKeys);
///
/// // Widget / screen test — assert the REAL Vietnamese/English copy:
/// setUpAll(LocalizationTestHarness.useRealTranslations);
///
/// // Full control — inject exactly the keys a test cares about:
/// setUp(() => LocalizationTestHarness.useFake({'errors': {'server': 'BOOM'}}));
/// ```
///
/// For widgets that read `context.locale` or rely on `localizationsDelegates`,
/// wrap them with [wrap] inside `pumpWidget`.
abstract final class LocalizationTestHarness {
  /// Binds the test framework, mocks shared_preferences (easy_localization reads
  /// it for the saved locale) and initialises easy_localization. Shared by every
  /// mode below.
  static Future<void> _bootstrap() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  }

  /// `.tr()` returns the translation KEY unchanged (no assets loaded).
  /// The lightest mode — ideal for model / logic / view-model tests that only
  /// need `.tr()` to not throw and assert on the key.
  static Future<void> useKeys() async {
    await _bootstrap();
    Localization.load(
      AppConstants.fallbackLocale,
      translations: Translations(const <String, dynamic>{}),
    );
  }

  /// `.tr()` returns the REAL app translations from `assets/translations/`.
  /// Use in widget / screen tests to assert on the actual visible copy. Missing
  /// keys fall back to the key string, mirroring runtime behaviour.
  static Future<void> useRealTranslations({
    Locale locale = const Locale('vi'),
  }) async {
    await _bootstrap();
    const loader = RootBundleAssetLoader();
    final main = await loader.load(AppConstants.translationsPath, locale);
    final fallback = await loader.load(
      AppConstants.translationsPath,
      AppConstants.fallbackLocale,
    );
    Localization.load(
      locale,
      translations: Translations(main),
      fallbackTranslations: Translations(fallback),
      useFallbackTranslationsForEmptyResources: true,
    );
  }

  /// `.tr()` resolves only the [translations] you pass — a fully controllable
  /// fake. Keys outside the map fall back to the key string. Nested maps work
  /// (`{'errors': {'server': '...'}}`) just like the JSON files.
  static Future<void> useFake(
    Map<String, dynamic> translations, {
    Locale locale = const Locale('vi'),
  }) async {
    await _bootstrap();
    Localization.load(locale, translations: Translations(translations));
  }

  /// Wraps [child] in a real [EasyLocalization] for widgets/screens that read
  /// `context.locale` or use `localizationsDelegates`. After `pumpWidget`, call
  /// `await tester.pump()` once to let translations load.
  static Widget wrap(
    Widget child, {
    Locale startLocale = const Locale('vi'),
  }) {
    return EasyLocalization(
      supportedLocales: AppConstants.supportedLocales,
      path: AppConstants.translationsPath,
      fallbackLocale: AppConstants.fallbackLocale,
      startLocale: startLocale,
      saveLocale: false,
      child: child,
    );
  }
}
