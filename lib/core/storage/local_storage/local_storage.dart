import 'dart:ui' show Locale;

/// Abstract contract for local key-value storage.
///
/// Implementations (SharedPreferences, Hive, …) must honour this interface.
/// Reads are synchronous — implementations are expected to pre-load data into
/// memory during initialisation. Writes are async to allow I/O persistence.
abstract class LocalStorage {
  static const kPhoneNumberKey = 'benny_phone_number';
  static const kDeviceLanguageKey = 'benny_device_language';

  Future<void> setPhoneNumber({required String? value});
  String getPhoneNumber();

  /// Persists the selected language (only its `languageCode` is stored).
  Future<void> setDeviceLanguage({required Locale value});

  /// Returns the saved language, or null if the user has not chosen one.
  Locale? getDeviceLanguage();
}
