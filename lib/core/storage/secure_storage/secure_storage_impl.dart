import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'secure_storage.dart';
import 'secure_storage_wrapper/flutter_secure_key_value_storage_impl.dart';
import 'secure_storage_wrapper/secure_key_value_storage.dart';

/// Default implementation of [SecureStorage].
///
/// Delegates all I/O to [SecureKeyValueStore], which handles caching and the
/// underlying platform keychain. Adding a new credential field (e.g. phone
/// number) only requires adding a key constant and two methods here — no
/// changes needed anywhere else in the codebase.
///
/// Callers (e.g. injection.dart) should use [SecureStorageImpl.create] and
/// only depend on the [SecureStorage] interface — no knowledge of
/// FlutterSecureStorage or SecureKeyValueStore needed outside this folder.
class SecureStorageImpl implements SecureStorage {
  const SecureStorageImpl({required this.store});

  /// Builds the full storage chain and pre-loads all keys into memory.
  /// Swap the implementation inside here when migrating to a new backend
  /// (e.g. Hive) — injection.dart stays untouched.
  static Future<SecureStorage> create() async {
    //// ✅ Current: flutter_secure_storage (OS Keychain / Keystore)
    final kvStore = FlutterSecureKeyValueStoreImpl(const FlutterSecureStorage());

    //// 🔄 To swap to Hive AES-256, replace the line above with:
    // final kvStore = await HiveSecureKeyValueStoreImpl.create();

    await kvStore.loadAllDataIntoMemory();
    return SecureStorageImpl(store: kvStore);
  }

  final SecureKeyValueStore store;

  static const _kAccessToken = 'access_token';
  static const _kRefreshToken = 'refresh_token';

  @override
  Future<void> saveAccessToken(String token) => store.write(key: _kAccessToken, value: token);

  @override
  Future<String?> getAccessToken() => store.read(key: _kAccessToken);

  @override
  Future<void> saveRefreshToken(String token) => store.write(key: _kRefreshToken, value: token);

  @override
  Future<String?> getRefreshToken() => store.read(key: _kRefreshToken);

  @override
  Future<void> clearTokens() async {
    await store.delete(key: _kAccessToken);
    await store.delete(key: _kRefreshToken);
  }
}
