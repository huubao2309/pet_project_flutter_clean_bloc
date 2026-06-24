import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/features/app_update/domain/entities/app_update_config.dart';

void main() {
  group('AppUpdateConfig', () {
    test('stores all fields', () {
      const config = AppUpdateConfig(
        latestVersion: '2.1.0',
        minRequiredVersion: '2.0.0',
        forceUpdate: true,
        storeUrl: 'https://store/app',
        message: 'New stuff',
      );
      expect(config.latestVersion, '2.1.0');
      expect(config.minRequiredVersion, '2.0.0');
      expect(config.forceUpdate, isTrue);
      expect(config.storeUrl, 'https://store/app');
      expect(config.message, 'New stuff');
    });

    test('message is optional and defaults to null', () {
      const config = AppUpdateConfig(
        latestVersion: '1.0.0',
        minRequiredVersion: '1.0.0',
        forceUpdate: false,
        storeUrl: 'https://store/app',
      );
      expect(config.message, isNull);
    });
  });
}
