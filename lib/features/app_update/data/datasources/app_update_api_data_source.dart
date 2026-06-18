import '../../../../core/network/dio_client.dart';
import '../models/app_update_config_dto.dart';
import 'app_update_remote_data_source.dart';

/// Real [AppUpdateRemoteDataSource] talking to the backend over [DioClient].
class AppUpdateApiDataSource implements AppUpdateRemoteDataSource {
  const AppUpdateApiDataSource({required DioClient dioClient})
      : _dioClient = dioClient;

  final DioClient _dioClient;

  static const _path = '/app/version';

  @override
  Future<AppUpdateConfigDto?> fetchConfig() async {
    final response = await _dioClient.get<AppUpdateConfigDto>(
      _path,
      fromJson: (json) =>
          AppUpdateConfigDto.fromJson(json as Map<String, dynamic>),
    );
    return response.success ? response.data : null;
  }
}
