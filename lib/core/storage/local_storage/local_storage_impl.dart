import 'dart:ui' show Locale;

import 'local_storage.dart';
import 'local_storage_wrapper/local_storage.dart';
import 'local_storage_wrapper/shared_preferences_storage_impl.dart';

/// Default implementation of [LocalStorage].
///
/// Delegates all I/O to [LocalKeyValueStore] — this class has zero knowledge
/// of SharedPreferences, Hive, or any other concrete library.
///
/// To swap to Hive: replace [SharedPreferencesStorageImpl.create] with
/// [HiveStorageImpl.create] in [create] below — nothing else changes.
class LocalStorageImpl implements LocalStorage {
  const LocalStorageImpl(this._store);

  final LocalKeyValueStore _store;

  static Future<LocalStorage> create() async {
    //// ✅ Current: SharedPreferences
    final store = await SharedPreferencesStorageImpl.create();

    //// 🔄 To swap to Hive, replace the line above with:
    // final store = await HiveStorageImpl.create();

    return LocalStorageImpl(store);
  }

  @override
  Future<void> setPhoneNumber({required String? value}) => _store.setString(LocalStorage.kPhoneNumberKey, value ?? '');

  @override
  String getPhoneNumber() => _store.getString(LocalStorage.kPhoneNumberKey) ?? '';

  @override
  Future<void> setDeviceLanguage({required Locale value}) =>
      _store.setString(LocalStorage.kDeviceLanguageKey, value.languageCode);

  @override
  Locale? getDeviceLanguage() {
    final code = _store.getString(LocalStorage.kDeviceLanguageKey);
    if (code == null || code.isEmpty) {
      return null;
    }
    return Locale(code);
  }

  @override
  Future<void> setVendorId({required String value}) =>
      _store.setString(LocalStorage.kVendorIdKey, value);

  @override
  String? getVendorId() => _store.getString(LocalStorage.kVendorIdKey);

  @override
  Future<void> setThemeMode({required String value}) =>
      _store.setString(LocalStorage.kThemeModeKey, value);

  @override
  String? getThemeMode() => _store.getString(LocalStorage.kThemeModeKey);

  @override
  Future<void> setDismissedUpdateVersion({required String value}) =>
      _store.setString(LocalStorage.kDismissedUpdateVersionKey, value);

  @override
  String? getDismissedUpdateVersion() {
    final value = _store.getString(LocalStorage.kDismissedUpdateVersionKey);
    return (value == null || value.isEmpty) ? null : value;
  }
}
