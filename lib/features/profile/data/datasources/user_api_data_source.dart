import '../../../../core/error/app_error_code.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/network/http_client.dart';
import '../models/request/change_password_request_dto.dart';
import '../models/user_profile_dto.dart';
import 'user_remote_data_source.dart';

/// Real [UserRemoteDataSource] talking to the backend over an [HttpClient].
class UserApiDataSource implements UserRemoteDataSource {
  const UserApiDataSource({required HttpClient httpClient})
      : _httpClient = httpClient;

  final HttpClient _httpClient;

  static const _profile = '/user/me';
  static const _changePassword = '/user/change-password';

  @override
  Future<UserProfileDto> getProfile() async {
    final response = await _httpClient.get<UserProfileDto>(
      _profile,
      fromJson: (json) =>
          UserProfileDto.fromJson(json as Map<String, dynamic>),
    );

    if (!response.success || response.data == null) {
      throw ServerException(
        code: AppErrorCode.unknown,
        message: response.message,
      );
    }
    return response.data!;
  }

  @override
  Future<void> changePassword(ChangePasswordRequestDto request) async {
    final response = await _httpClient.post<void>(
      _changePassword,
      data: request.toJson(),
    );
    if (!response.success) {
      throw ServerException(
        code: AppErrorCode.changePasswordFailed,
        message: response.message,
      );
    }
  }
}
