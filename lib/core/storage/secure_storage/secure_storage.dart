import 'secure_storage_wrapper/secure_key_value_storage.dart';

/// Abstract contract for secure credential storage (domain layer).
///
/// Defines business-level operations for sensitive user data.
/// The underlying storage mechanism is hidden behind [SecureKeyValueStore].
abstract class SecureStorage {
  Future<void> saveAccessToken(String token);

  Future<String?> getAccessToken();

  Future<void> saveRefreshToken(String token);

  Future<String?> getRefreshToken();

  /// Removes both the access and refresh tokens (used on logout).
  Future<void> clearTokens();
}
