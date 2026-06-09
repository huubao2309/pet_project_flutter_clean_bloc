import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'secure_storage.dart';

class FlutterSecureStorageImpl implements SecureStorage {
  const FlutterSecureStorageImpl(this._storage);

  final FlutterSecureStorage _storage;

  @override
  Future<void> saveAccessToken(String token) => _storage.write(key: SecureStorage.kAccessTokenKey, value: token);

  @override
  Future<String?> getAccessToken() => _storage.read(key: SecureStorage.kAccessTokenKey);

  @override
  Future<void> saveRefreshToken(String token) => _storage.write(key: SecureStorage.kRefreshTokenKey, value: token);

  @override
  Future<String?> getRefreshToken() => _storage.read(key: SecureStorage.kRefreshTokenKey);

  @override
  Future<void> deleteAll() => _storage.deleteAll();
}
