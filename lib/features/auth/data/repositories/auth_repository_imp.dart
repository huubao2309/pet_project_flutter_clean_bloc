import '../../../../core/storage/secure_storage/secure_storage.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/request/forgot_password_request_dto.dart';
import '../models/request/login_request_dto.dart';
import '../models/request/reset_password_request_dto.dart';
import '../models/request/sign_up_request_dto.dart';
import '../services/auth_service.dart';

/// Real [AuthRepository] backed by [AuthService] (network) and
/// [SecureStorage] (token persistence).
///
/// The data layer owns DTO construction/serialization: the domain passes plain
/// values, and this class maps them to [LoginRequestDto] before hitting the API
/// and maps the response DTO back to a [UserEntity].
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthService authService,
    required SecureStorage secureStorage,
  })  : _authService = authService,
        _secureStorage = secureStorage;

  final AuthService _authService;
  final SecureStorage _secureStorage;

  @override
  Future<UserEntity> login({
    required String phone,
    required String password,
  }) async {
    final data = await _authService.login(
      LoginRequestDto(phone: phone, password: password),
    );
    await _secureStorage.saveAccessToken(data.accessToken);
    await _secureStorage.saveRefreshToken(data.refreshToken);
    return data.userInfo.toEntity();
  }

  @override
  Future<bool> signUp({
    required String email,
    required String password,
    bool? receiveUpdates,
  }) async {
    return _authService.signUp(
      SignUpRequestDto(
        email: email,
        password: password,
        // The data layer owns transport concerns like the API language code.
        language: _defaultLanguage,
        statusUpdate: receiveUpdates,
      ),
    );
  }

  @override
  Future<void> forgotPassword({required String email}) {
    return _authService.forgotPassword(
      ForgotPasswordRequestDto(email: email),
    );
  }

  @override
  Future<void> resetPassword({
    required String newPassword,
    required String token,
  }) {
    return _authService.resetPassword(
      ResetPasswordRequestDto(newPassword: newPassword, token: token),
    );
  }

  @override
  Future<void> logout() async {
    await _authService.logout();
  }

  static const _defaultLanguage = 'en';

  @override
  Future<bool> isLoggedIn() async {
    final token = await _secureStorage.getAccessToken();
    return token != null;
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    // TODO: fetch the current user from /me endpoint or cached profile.
    return null;
  }
}
