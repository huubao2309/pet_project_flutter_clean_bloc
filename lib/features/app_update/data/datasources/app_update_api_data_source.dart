import '../../../../core/network/http_client.dart';
import '../models/app_update_config_dto.dart';
import 'app_update_remote_data_source.dart';

/// Real [AppUpdateRemoteDataSource] talking to the backend over an [HttpClient].
class AppUpdateApiDataSource implements AppUpdateRemoteDataSource {
  const AppUpdateApiDataSource({required HttpClient httpClient})
      : _httpClient = httpClient;

  final HttpClient _httpClient;

  static const _path = '/app/version';

  @override
  Future<AppUpdateConfigDto?> fetchConfig() async {
    final response = await _httpClient.get<AppUpdateConfigDto>(
      _path,
      fromJson: (json) =>
          AppUpdateConfigDto.fromJson(json as Map<String, dynamic>),
    );
    return response.success ? response.data : null;
  }
}
