abstract class SecureStorage {
  static const kAccessTokenKey = 'access_token';
  static const kRefreshTokenKey = 'refresh_token';

  Future<void> saveAccessToken(String token);

  Future<String?> getAccessToken();

  Future<void> saveRefreshToken(String token);

  Future<String?> getRefreshToken();

  Future<void> deleteAll();
}
