import 'package:shared_preferences/shared_preferences.dart';

import 'local_storage.dart';

/// [SharedPreferences] implementation of [LocalKeyValueStore].
///
/// To swap to Hive (or any other backend), create a new [LocalKeyValueStore]
/// implementation — [LocalStorageImpl] and injection.dart stay untouched.
class SharedPreferencesStorageImpl implements LocalKeyValueStore {
  SharedPreferencesStorageImpl._(this._prefs);

  static Future<LocalKeyValueStore> create() async {
    final prefs = await SharedPreferences.getInstance();
    return SharedPreferencesStorageImpl._(prefs);
  }

  final SharedPreferences _prefs;

  @override
  Future<void> setString(String key, String value) =>
      _prefs.setString(key, value);

  @override
  String? getString(String key) => _prefs.getString(key);

  @override
  Future<void> remove(String key) => _prefs.remove(key);

  @override
  Future<void> clear() => _prefs.clear();

  @override
  bool containsKey(String key) => _prefs.containsKey(key);
}
