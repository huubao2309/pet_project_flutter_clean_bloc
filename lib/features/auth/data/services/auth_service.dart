import '../../../../core/error/app_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../models/request/login_request_dto.dart';
import '../models/response/login_data_dto.dart';

class AuthService {
  const AuthService({required DioClient dioClient}) : _dioClient = dioClient;

  final DioClient _dioClient;

  static const _login = '/auth/login';
  static const _logout = '/auth/logout';

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

  Future<void> logout() async {
    final response = await _dioClient.post<void>(_logout);

    if (!response.success) {
      throw ServerException(message: response.message ?? 'Đăng xuất thất bại');
    }
  }
}
