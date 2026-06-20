import 'package:easy_localization/easy_localization.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../models/user_profile_dto.dart';
import 'profile_remote_data_source.dart';

/// Real [ProfileRemoteDataSource] talking to the backend over [DioClient].
class ProfileApiDataSource implements ProfileRemoteDataSource {
  const ProfileApiDataSource({required DioClient dioClient})
      : _dioClient = dioClient;

  final DioClient _dioClient;

  static const _profile = '/auth/me';

  @override
  Future<UserProfileDto> getProfile() async {
    final response = await _dioClient.get<UserProfileDto>(
      _profile,
      fromJson: (json) =>
          UserProfileDto.fromJson(json as Map<String, dynamic>),
    );

    if (!response.success || response.data == null) {
      throw ServerException(
        message: response.message ?? 'errors.unknown'.tr(),
      );
    }
    return response.data!;
  }
}
