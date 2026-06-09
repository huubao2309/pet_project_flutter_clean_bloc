import 'package:shared_preferences/shared_preferences.dart';

/// Type-safe wrapper around [SharedPreferences].
class LocalStorage {
  LocalStorage._(this._prefs);

  final SharedPreferences _prefs;

  static Future<LocalStorage> create() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorage._(prefs);
  }

  // --- String ---
  Future<bool> setString(String key, String value) =>
      _prefs.setString(key, value);
  String? getString(String key) => _prefs.getString(key);

  // --- Bool ---
  Future<bool> setBool(String key, {required bool value}) =>
      _prefs.setBool(key, value);
  bool? getBool(String key) => _prefs.getBool(key);

  // --- Int ---
  Future<bool> setInt(String key, int value) => _prefs.setInt(key, value);
  int? getInt(String key) => _prefs.getInt(key);

  Future<bool> remove(String key) => _prefs.remove(key);

  Future<bool> clear() => _prefs.clear();

  bool containsKey(String key) => _prefs.containsKey(key);
}
