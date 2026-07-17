import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/constants/mock_assets.dart';
import 'package:pet_project_flutter_clean_bloc/data/datasources/app_update_mock_data_source.dart';

/// Drives the mock against the real bundled JSON fixtures. The injectable
/// scenario lets us reach every case, and `latency: Duration.zero` keeps it fast.
void main() {
  setUpAll(TestWidgetsFlutterBinding.ensureInitialized);

  AppUpdateMockDataSource source(String scenario) =>
      AppUpdateMockDataSource(scenario: scenario, latency: Duration.zero);

  test('force scenario maps to a forced config', () async {
    final config = await source(MockAssets.appUpdateForce).fetchConfig();

    expect(config, isNotNull);
    expect(config!.forceUpdate, isTrue);
    expect(config.latestVersion, '2.5.0');
    expect(config.minRequiredVersion, '2.0.0');
  });

  test('optional scenario maps to a non-forced config', () async {
    final config = await source(MockAssets.appUpdateOptional).fetchConfig();

    expect(config, isNotNull);
    expect(config!.forceUpdate, isFalse);
    expect(config.latestVersion, '2.5.0');
  });

  test('none scenario still returns a config (a current version)', () async {
    final config = await source(MockAssets.appUpdateNone).fetchConfig();

    expect(config, isNotNull);
    expect(config!.forceUpdate, isFalse);
    expect(config.latestVersion, '1.0.0');
  });
}
