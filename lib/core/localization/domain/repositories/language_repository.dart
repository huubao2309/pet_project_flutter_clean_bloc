import 'dart:ui' show Locale;

/// Domain contract for reading/writing the app language preference.
///
/// A cross-cutting concern (used by the splash bootstrap and the shared
/// language switcher), so it lives under `core/` — features depend on core,
/// never the other way around.
abstract class LanguageRepository {
  /// The saved language, or null if the user has not chosen one yet.
  Locale? getLanguage();

  /// Persists the selected [locale].
  Future<void> saveLanguage(Locale locale);
}
