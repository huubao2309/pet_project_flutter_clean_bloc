import 'package:flutter/material.dart';

/// The app's resolved colour mode. After first launch this is always a concrete
/// light/dark value (the system setting only seeds the very first run).
enum AppThemeMode {
  light,
  dark;

  bool get isDark => this == AppThemeMode.dark;

  Brightness get brightness =>
      isDark ? Brightness.dark : Brightness.light;

  /// Parses the persisted string; returns null for unknown/empty values.
  static AppThemeMode? fromStorage(String? value) => switch (value) {
        'light' => AppThemeMode.light,
        'dark' => AppThemeMode.dark,
        _ => null,
      };
}
