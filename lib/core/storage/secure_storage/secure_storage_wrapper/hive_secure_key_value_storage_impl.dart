import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import 'secure_key_value_storage.dart';

/// Hive AES-256 implementation of [SecureKeyValueStore].
///
/// Drop-in replacement for [FlutterSecureKeyValueStoreImpl].
/// To activate: change [SecureStorageImpl.create] to call
/// [HiveSecureKeyValueStoreImpl.create] — no other files change.
///
/// ── How encryption works ────────────────────────────────────────────────────
/// Hive encrypts the entire box with AES-256-CBC via [HiveAesCipher].
/// The 32-byte key is generated once per install and persisted in a separate
/// plain box.
///
/// ── Key storage trade-off ───────────────────────────────────────────────────
/// Storing the key in a plain Hive box (as done here) is fine for most apps.
/// If you need OS-level key protection (Keychain / Keystore), store the key
/// with flutter_secure_storage and load it here — this class body stays the
/// same, only [create] changes.
///
/// ── vs flutter_secure_storage ───────────────────────────────────────────────
/// | Aspect             | flutter_secure_storage    | This impl               |
/// |--------------------|---------------------------|-------------------------|
/// | Encryption         | OS keychain / keystore    | AES-256 (Hive cipher)   |
/// | Read speed         | Platform channel per read | In-memory cache O(1)    |
/// | Cross-platform     | Android/iOS/macOS/Windows | All Flutter platforms   |
/// | Key management     | Handled by OS             | App-managed (see above) |
class HiveSecureKeyValueStoreImpl implements SecureKeyValueStore {
  /// Takes the already-opened (encrypted) [Box] as a dependency (DI), so the
  /// cache / write-through logic is unit-testable with a test box. [create]
  /// builds the real encrypted one.
  HiveSecureKeyValueStoreImpl(this._box);

  final Box<String> _box;
  final Map<String, String> _cache = {};
  bool _isLoaded = false;

  static const _secureBoxName = 'secure_storage';
  static const _keyBoxName = 'secure_storage_key';
  static const _encryptionKeyEntry = 'aes_key';

  static Future<SecureKeyValueStore> create() async {
    await Hive.initFlutter();

    final encryptionKey = await _loadOrGenerateKey();
    final box = await Hive.openBox<String>(
      _secureBoxName,
      encryptionCipher: HiveAesCipher(encryptionKey),
    );

    return HiveSecureKeyValueStoreImpl(box);
  }

  /// Loads an existing AES key from the key box, or generates and saves a new one.
  static Future<List<int>> _loadOrGenerateKey() async {
    final keyBox = await Hive.openBox<String>(_keyBoxName);
    final stored = keyBox.get(_encryptionKeyEntry);

    if (stored != null) {
      return base64Decode(stored).toList();
    }

    final newKey = Hive.generateSecureKey();
    await keyBox.put(_encryptionKeyEntry, base64Encode(newKey));
    return newKey;
  }

  // ── SecureKeyValueStore ────────────────────────────────────────────────────

  @override
  Future<void> loadAllDataIntoMemory() async {
    for (final key in _box.keys) {
      final value = _box.get(key.toString());
      if (value != null) {
        _cache[key.toString()] = value;
      }
    }
    _isLoaded = true;
  }

  @override
  Future<void> write({required String key, required String? value}) async {
    if (value == null) {
      _cache.remove(key);
      await _box.delete(key);
    } else {
      _cache[key] = value;
      await _box.put(key, value);
    }
  }

  @override
  Future<String?> read({required String key}) async {
    if (_isLoaded) {
      return _cache[key];
    }
    return _box.get(key);
  }

  @override
  Future<Map<String, String>> readAll() async => Map.unmodifiable(_cache);

  @override
  Future<bool> containsKey({required String key}) async {
    if (_isLoaded) {
      return _cache.containsKey(key);
    }
    return _box.containsKey(key);
  }

  @override
  Future<void> delete({required String key}) async {
    _cache.remove(key);
    await _box.delete(key);
  }

  @override
  Future<void> deleteAll() async {
    _cache.clear();
    await _box.clear();
  }
}
