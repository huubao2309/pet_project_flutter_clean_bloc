import 'package:hive_flutter/hive_flutter.dart';

import 'local_storage.dart';

/// Hive implementation of [LocalKeyValueStore].
///
/// Drop-in replacement for [SharedPreferencesStorageImpl].
/// To activate: change [LocalStorageImpl.create] to call [HiveStorageImpl.create].
/// No other files need to change.
class HiveStorageImpl implements LocalKeyValueStore {
  /// Takes the already-opened [Box] as a dependency (DI), so the class is pure
  /// delegation and unit-testable with a test box. [create] builds the real one.
  HiveStorageImpl(this._box);

  final Box<String> _box;

  static const _boxName = 'app_local_storage';

  static Future<LocalKeyValueStore> create() async {
    await Hive.initFlutter();
    final box = await Hive.openBox<String>(_boxName);
    return HiveStorageImpl(box);
  }

  @override
  Future<void> setString(String key, String value) => _box.put(key, value);

  @override
  String? getString(String key) => _box.get(key);

  @override
  Future<void> remove(String key) => _box.delete(key);

  @override
  Future<void> clear() => _box.clear();

  @override
  bool containsKey(String key) => _box.containsKey(key);
}
