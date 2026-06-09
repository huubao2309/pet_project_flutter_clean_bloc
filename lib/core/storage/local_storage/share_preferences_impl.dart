import 'package:shared_preferences/shared_preferences.dart';

import 'local_storage.dart';

/// [SharedPreferences] implementation of [LocalStorage].
///
/// To swap to Hive (or any other library), create a new implementation of
/// [LocalStorage] and register it in injection.dart — no other code changes.
class SharedPreferencesImpl implements LocalStorage {
  SharedPreferencesImpl._(this._prefs);

  final SharedPreferences _prefs;

  static Future<LocalStorage> create() async {
    final prefs = await SharedPreferences.getInstance();
    return SharedPreferencesImpl._(prefs);
  }

  @override
  Future<void> setPhoneNumber({required String? value}) async {
    await _prefs.setString(LocalStorage.kPhoneNumberKey, value ?? '');
  }

  @override
  String getPhoneNumber() {
    return _prefs.getString(LocalStorage.kPhoneNumberKey) ?? '';
  }

  @override
  Future<void> remove(String key) => _prefs.remove(key);

  @override
  Future<void> clear() => _prefs.clear();

  @override
  bool containsKey(String key) => _prefs.containsKey(key);
}
