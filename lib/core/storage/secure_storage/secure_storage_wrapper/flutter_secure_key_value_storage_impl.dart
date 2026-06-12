import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'secure_key_value_storage.dart';

/// [FlutterSecureStorage] implementation of [SecureKeyValueStore].
///
/// After [loadAllDataIntoMemory] is called, reads hit the in-memory [_cache]
/// (O(1), no platform-channel I/O). Writes are write-through: cache is updated
/// first, then the platform keychain/keystore is persisted asynchronously.
///
/// To swap to a different secure backend (e.g. Keychain wrapper, EncryptedSharedPreferences),
/// create a new [SecureKeyValueStore] implementation and register it in injection.dart.
class FlutterSecureKeyValueStoreImpl implements SecureKeyValueStore {
  FlutterSecureKeyValueStoreImpl(this._storage);

  final FlutterSecureStorage _storage;
  final Map<String, String> _cache = {};
  bool _isLoaded = false;

  @override
  Future<void> loadAllDataIntoMemory() async {
    final all = await _storage.readAll();
    _cache.addAll(all);
    _isLoaded = true;
  }

  @override
  Future<void> write({required String key, required String? value}) async {
    if (value == null) {
      _cache.remove(key);
      await _storage.delete(key: key);
    } else {
      _cache[key] = value;
      await _storage.write(key: key, value: value);
    }
  }

  @override
  Future<String?> read({required String key}) async {
    if (_isLoaded) {
      return _cache[key];
    }
    // Fallback to storage if loadAllDataIntoMemory was not yet called.
    return _storage.read(key: key);
  }

  @override
  Future<Map<String, String>> readAll() async => Map.unmodifiable(_cache);

  @override
  Future<bool> containsKey({required String key}) async {
    if (_isLoaded) {
      return _cache.containsKey(key);
    }
    return _storage.containsKey(key: key);
  }

  @override
  Future<void> delete({required String key}) async {
    _cache.remove(key);
    await _storage.delete(key: key);
  }

  @override
  Future<void> deleteAll() async {
    _cache.clear();
    await _storage.deleteAll();
  }
}
