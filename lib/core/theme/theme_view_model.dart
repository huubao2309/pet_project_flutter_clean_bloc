import 'package:flutter/widgets.dart' show Brightness;

import '../presentation/view_model.dart';
import '../storage/local_storage/local_storage.dart';
import 'app_theme_mode.dart';

/// App-wide theme controller (the "VM" for Light/Dark Mode).
///
/// Resolution rules:
///  - If [LocalStorage] already holds a mode (set on a previous launch or by
///    the user), use it — the system setting is ignored from then on.
///  - On the very first launch (no saved flag), seed from the device's system
///    brightness and persist it, so subsequent launches are independent.
///
/// A single instance lives in `getIt`; `MyApp` listens to it to rebuild the
/// whole tree (swapping `ThemeState.colors` between Light/Dark), and the
/// Profile toggle calls [toggle] / [setDark].
class ThemeViewModel extends ViewModel<AppThemeMode> {
  ThemeViewModel({
    required LocalStorage localStorage,
    required Brightness systemBrightness,
  })  : _localStorage = localStorage,
        super(_resolveInitial(localStorage, systemBrightness)) {
    // First launch: persist the system-derived choice so later launches no
    // longer depend on the system setting.
    if (AppThemeMode.fromStorage(localStorage.getThemeMode()) == null) {
      _localStorage.setThemeMode(value: currentState.name);
    }
  }

  final LocalStorage _localStorage;

  static AppThemeMode _resolveInitial(
    LocalStorage storage,
    Brightness systemBrightness,
  ) {
    return AppThemeMode.fromStorage(storage.getThemeMode()) ??
        (systemBrightness == Brightness.dark
            ? AppThemeMode.dark
            : AppThemeMode.light);
  }

  bool get isDark => currentState.isDark;

  Future<void> setDark({required bool value}) async {
    final mode = value ? AppThemeMode.dark : AppThemeMode.light;
    if (mode == currentState) {
      return;
    }
    setState(mode);
    await _localStorage.setThemeMode(value: mode.name);
  }

  Future<void> toggle() => setDark(value: !isDark);
}
