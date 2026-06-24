import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/base/app_constants.dart';

void main() {
  group('AppConstants', () {
    test('app name is Benny', () {
      expect(kAppName, 'Benny');
    });

    test('supports Vietnamese and English locales', () {
      expect(AppConstants.supportedLocales, [const Locale('vi'), const Locale('en')]);
    });

    test('falls back to Vietnamese', () {
      expect(AppConstants.fallbackLocale, const Locale('vi'));
      expect(
        AppConstants.supportedLocales.contains(AppConstants.fallbackLocale),
        isTrue,
      );
    });

    test('translations path points at the assets folder', () {
      expect(AppConstants.translationsPath, 'assets/translations');
    });

    test('declares an app version', () {
      expect(AppConstants.appVersion, '1.0.0');
    });
  });
}
