import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_project_flutter_clean_bloc/core/network/api_response.dart';
import 'package:pet_project_flutter_clean_bloc/core/network/http_client.dart';
import 'package:pet_project_flutter_clean_bloc/features/app_update/data/datasources/app_update_api_data_source.dart';
import 'package:pet_project_flutter_clean_bloc/features/app_update/data/models/app_update_config_dto.dart';

class MockHttpClient extends Mock implements HttpClient {}

void main() {
  late MockHttpClient http;
  late AppUpdateApiDataSource dataSource;

  setUp(() {
    http = MockHttpClient();
    dataSource = AppUpdateApiDataSource(httpClient: http);
  });

  void whenGet(ApiResponse<AppUpdateConfigDto> response) {
    when(
      () => http.get<AppUpdateConfigDto>(
        any(),
        fromJson: any(named: 'fromJson'),
      ),
    ).thenAnswer((_) async => response);
  }

  const config = AppUpdateConfigDto(
    latestVersion: '2.5.0',
    minRequiredVersion: '2.0.0',
    forceUpdate: false,
    androidUrl: 'https://play',
    iosUrl: 'https://appstore',
  );

  test('returns the config and GETs /app/version on success', () async {
    whenGet(const ApiResponse<AppUpdateConfigDto>(success: true, data: config));

    final result = await dataSource.fetchConfig();

    expect(result, same(config));
    final path = verify(
      () => http.get<AppUpdateConfigDto>(
        captureAny(),
        fromJson: any(named: 'fromJson'),
      ),
    ).captured.single;
    expect(path, '/app/version');
  });

  test('returns null when the response is unsuccessful', () async {
    whenGet(
      const ApiResponse<AppUpdateConfigDto>(success: false, data: config),
    );

    expect(await dataSource.fetchConfig(), isNull);
  });

  test('returns null when success but data is absent', () async {
    whenGet(const ApiResponse<AppUpdateConfigDto>(success: true));

    expect(await dataSource.fetchConfig(), isNull);
  });
}
