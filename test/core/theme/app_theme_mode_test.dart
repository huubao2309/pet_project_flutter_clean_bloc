import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/theme/app_theme_mode.dart';

void main() {
  group('AppThemeMode.isDark', () {
    test('is true only for dark', () {
      expect(AppThemeMode.dark.isDark, isTrue);
      expect(AppThemeMode.light.isDark, isFalse);
    });
  });

  group('AppThemeMode.brightness', () {
    test('maps to the matching Brightness', () {
      expect(AppThemeMode.dark.brightness, Brightness.dark);
      expect(AppThemeMode.light.brightness, Brightness.light);
    });
  });

  group('AppThemeMode.fromStorage', () {
    test('parses known values', () {
      expect(AppThemeMode.fromStorage('light'), AppThemeMode.light);
      expect(AppThemeMode.fromStorage('dark'), AppThemeMode.dark);
    });

    test('returns null for unknown, empty or null input', () {
      expect(AppThemeMode.fromStorage('system'), isNull);
      expect(AppThemeMode.fromStorage(''), isNull);
      expect(AppThemeMode.fromStorage(null), isNull);
    });
  });

  group('AppThemeMode values', () {
    test('declares exactly light and dark', () {
      expect(AppThemeMode.values, [AppThemeMode.light, AppThemeMode.dark]);
    });
  });
}
