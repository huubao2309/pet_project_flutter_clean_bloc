import '../models/request/forgot_password_request_dto.dart';
import '../models/request/login_request_dto.dart';
import '../models/request/reset_password_request_dto.dart';
import '../models/request/sign_up_request_dto.dart';
import '../models/response/login_data_dto.dart';

/// Remote data source contract for the auth feature.
///
/// Returns DTOs and throws [AppException]s on failure. The repository depends
/// on this abstraction, so swapping the real API for fake data is a single DI
/// line — see [AuthApiDataSource] (real) and [AuthMockDataSource] (fake).
abstract class AuthRemoteDataSource {
  Future<LoginDataDto> login(LoginRequestDto request);

  Future<bool> signUp(SignUpRequestDto request);

  Future<void> forgotPassword(ForgotPasswordRequestDto request);

  Future<void> resetPassword(ResetPasswordRequestDto request);

  Future<void> logout();
}
