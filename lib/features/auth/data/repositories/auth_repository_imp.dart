import '../../../../core/storage/secure_storage/secure_storage.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/request/forgot_password_request_dto.dart';
import '../models/request/login_request_dto.dart';
import '../models/request/reset_password_request_dto.dart';
import '../models/request/sign_up_request_dto.dart';

/// The single [AuthRepository] implementation, backed by an
/// [AuthRemoteDataSource] (real API or fake mock — chosen in DI) and
/// [SecureStorage] for token persistence.
///
/// The data layer owns DTO construction/serialization: the domain passes plain
/// values, this class maps them to request DTOs and maps response DTOs back to
/// domain entities. It also owns session persistence (saving/clearing tokens).
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required SecureStorage secureStorage,
  })  : _remoteDataSource = remoteDataSource,
        _secureStorage = secureStorage;

  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorage _secureStorage;

  @override
  Future<UserEntity> login({
    required String phone,
    required String password,
  }) async {
    final data = await _remoteDataSource.login(
      LoginRequestDto(phone: phone, password: password),
    );
    // Persist tokens so the user stays logged in after restarting the app.
    await _secureStorage.saveAccessToken(data.accessToken);
    await _secureStorage.saveRefreshToken(data.refreshToken);
    return data.userInfo.toEntity();
  }

  @override
  Future<bool> signUp({
    required String phone,
    required String password,
    bool? receiveUpdates,
  }) async {
    return _remoteDataSource.signUp(
      SignUpRequestDto(
        phone: phone,
        password: password,
        // The data layer owns transport concerns like the API language code.
        language: _defaultLanguage,
        statusUpdate: receiveUpdates,
      ),
    );
  }

  @override
  Future<void> forgotPassword({required String phone}) {
    return _remoteDataSource.forgotPassword(
      ForgotPasswordRequestDto(phone: phone),
    );
  }

  @override
  Future<void> resetPassword({
    required String newPassword,
    required String token,
  }) {
    return _remoteDataSource.resetPassword(
      ResetPasswordRequestDto(newPassword: newPassword, token: token),
    );
  }

  @override
  Future<void> logout() async {
    // The data source throws on failure; tokens are only cleared on success.
    await _remoteDataSource.logout();
    await _secureStorage.clearTokens();
  }

  static const _defaultLanguage = 'en';

  @override
  Future<bool> isLoggedIn() async {
    final token = await _secureStorage.getAccessToken();
    return token != null;
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    // TODO: fetch the current user from a /me endpoint or cached profile.
    return null;
  }
}
