/// Abstract contract for a generic secure key-value store (infrastructure layer).
///
/// Callers should invoke [loadAllDataIntoMemory] once at app startup so that
/// subsequent [read] / [containsKey] calls are served from the in-memory cache
/// rather than hitting the underlying platform keychain/keystore every time.
abstract class SecureKeyValueStore {
  /// Reads every persisted entry into memory. Call once during bootstrap.
  Future<void> loadAllDataIntoMemory();

  /// Writes [value] for [key]. Passing null deletes the key.
  Future<void> write({required String key, required String? value});

  /// Returns the cached value for [key], or null if not present.
  Future<String?> read({required String key});

  /// Returns an unmodifiable snapshot of the current in-memory cache.
  Future<Map<String, String>> readAll();

  /// Returns true if [key] exists in the cache.
  Future<bool> containsKey({required String key});

  /// Removes a single [key] from both cache and persistent storage.
  Future<void> delete({required String key});

  /// Clears all keys from both cache and persistent storage.
  Future<void> deleteAll();
}
