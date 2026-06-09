import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure key-value store for sensitive data (tokens, credentials).
class SecureStorage {
  const SecureStorage(this._storage);

  final FlutterSecureStorage _storage;

  static const _kAccessToken = 'access_token';
  static const _kRefreshToken = 'refresh_token';

  Future<void> saveAccessToken(String token) =>
      _storage.write(key: _kAccessToken, value: token);

  Future<String?> getAccessToken() => _storage.read(key: _kAccessToken);

  Future<void> saveRefreshToken(String token) =>
      _storage.write(key: _kRefreshToken, value: token);

  Future<String?> getRefreshToken() => _storage.read(key: _kRefreshToken);

  Future<void> deleteAll() => _storage.deleteAll();
}
