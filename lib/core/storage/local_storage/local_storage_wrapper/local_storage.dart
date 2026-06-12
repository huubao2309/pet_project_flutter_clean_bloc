/// Abstract contract for a generic local key-value store (infrastructure layer).
///
/// Implementations hide the underlying storage backend (SharedPreferences,
/// Hive, …) so [LocalStorageImpl] never depends on any concrete library.
abstract class LocalKeyValueStore {
  Future<void> setString(String key, String value);
  String? getString(String key);

  Future<void> remove(String key);
  Future<void> clear();
  bool containsKey(String key);
}
