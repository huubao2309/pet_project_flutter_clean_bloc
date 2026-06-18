import 'dart:ui' show Locale;

/// Abstract contract for local key-value storage.
///
/// Implementations (SharedPreferences, Hive, …) must honour this interface.
/// Reads are synchronous — implementations are expected to pre-load data into
/// memory during initialisation. Writes are async to allow I/O persistence.
abstract class LocalStorage {
  static const kPhoneNumberKey = 'benny_phone_number';
  static const kDeviceLanguageKey = 'benny_device_language';
  static const kVendorIdKey = 'benny_vendor_id';
  static const kThemeModeKey = 'benny_theme_mode';
  static const kDismissedUpdateVersionKey = 'benny_dismissed_update_version';

  Future<void> setPhoneNumber({required String? value});
  String getPhoneNumber();

  /// Persists the selected language (only its `languageCode` is stored).
  Future<void> setDeviceLanguage({required Locale value});

  /// Returns the saved language, or null if the user has not chosen one.
  Locale? getDeviceLanguage();

  /// Persists the iOS vendor id from the last known install (wiped on
  /// uninstall, unlike the keychain).
  Future<void> setVendorId({required String value});

  /// Returns the vendor id saved on the last install, or null.
  String? getVendorId();

  /// Persists the chosen theme mode (`'light'` / `'dark'`).
  Future<void> setThemeMode({required String value});

  /// Returns the saved theme mode, or null if the user/system hasn't set one
  /// (i.e. first launch — fall back to the system brightness).
  String? getThemeMode();

  /// Persists the latest app version whose optional-update prompt the user
  /// dismissed, so it is not shown again until a newer version ships.
  Future<void> setDismissedUpdateVersion({required String value});

  /// Returns the last dismissed optional-update version, or null if none.
  String? getDismissedUpdateVersion();
}
