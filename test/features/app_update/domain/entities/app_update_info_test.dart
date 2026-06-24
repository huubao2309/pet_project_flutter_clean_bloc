import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/features/app_update/domain/entities/app_update_info.dart';

void main() {
  group('AppUpdateInfo', () {
    test('stores all fields', () {
      const info = AppUpdateInfo(
        latestVersion: '3.0.0',
        storeUrl: 'https://store/app',
        message: 'notes',
      );
      expect(info.latestVersion, '3.0.0');
      expect(info.storeUrl, 'https://store/app');
      expect(info.message, 'notes');
    });

    test('message is optional and defaults to null', () {
      const info = AppUpdateInfo(
        latestVersion: '3.0.0',
        storeUrl: 'https://store/app',
      );
      expect(info.message, isNull);
    });
  });
}
