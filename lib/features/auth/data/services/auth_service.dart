import '../../../../core/error/app_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../models/request/forgot_password_request_dto.dart';
import '../models/request/login_request_dto.dart';
import '../models/request/reset_password_request_dto.dart';
import '../models/request/sign_up_request_dto.dart';
import '../models/response/login_data_dto.dart';

class AuthService {
  const AuthService({required DioClient dioClient}) : _dioClient = dioClient;

  final DioClient _dioClient;

  static const _login = '/auth/login';
  static const _logout = '/auth/logout';
  static const _signUp = '/auth/signup';
  static const _forgotPassword = '/auth/forgot-password';
  static const _resetPassword = '/auth/reset-password';

  Future<LoginDataDto> login(LoginRequestDto request) async {
    final response = await _dioClient.post<LoginDataDto>(
      _login,
      data: request.toJson(),
      fromJson: (json) => LoginDataDto.fromJson(json as Map<String, dynamic>),
    );

    if (!response.success || response.data == null) {
      throw ServerException(message: response.message ?? 'Đăng nhập thất bại');
    }

    return response.data!;
  }

  Future<bool> signUp(SignUpRequestDto request) async {
    final response = await _dioClient.post<void>(
      _signUp,
      data: request.toJson(),
    );

    if (!response.success) {
      throw ServerException(message: response.message ?? 'Đăng ký thất bại');
    }
    return true;
  }

  Future<void> forgotPassword(ForgotPasswordRequestDto request) async {
    final response = await _dioClient.post<void>(
      _forgotPassword,
      data: request.toJson(),
    );
    if (!response.success) {
      throw ServerException(
        message: response.message ?? 'Gửi email thất bại',
      );
    }
  }

  Future<void> resetPassword(ResetPasswordRequestDto request) async {
    final response = await _dioClient.post<void>(
      _resetPassword,
      data: request.toJson(),
    );
    if (!response.success) {
      throw ServerException(
        message: response.message ?? 'Đặt lại mật khẩu thất bại',
      );
    }
  }

  Future<void> logout() async {
    final response = await _dioClient.post<void>(_logout);

    if (!response.success) {
      throw ServerException(message: response.message ?? 'Đăng xuất thất bại');
    }
  }
}
