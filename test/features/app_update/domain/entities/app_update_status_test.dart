import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/features/app_update/domain/entities/app_update_info.dart';
import 'package:pet_project_flutter_clean_bloc/features/app_update/domain/entities/app_update_status.dart';

void main() {
  const info = AppUpdateInfo(latestVersion: '2.0.0', storeUrl: 'https://s');

  group('AppUpdateStatus', () {
    test('AppUpToDate is a status with no info', () {
      expect(const AppUpToDate(), isA<AppUpdateStatus>());
    });

    test('AppOptionalUpdate carries info', () {
      const status = AppOptionalUpdate(info);
      expect(status, isA<AppUpdateStatus>());
      expect(status.info, same(info));
    });

    test('AppForcedUpdate carries info', () {
      const status = AppForcedUpdate(info);
      expect(status, isA<AppUpdateStatus>());
      expect(status.info, same(info));
    });

    test('exhaustive switch over sealed subtypes', () {
      String label(AppUpdateStatus s) => switch (s) {
            AppUpToDate() => 'none',
            AppOptionalUpdate() => 'optional',
            AppForcedUpdate() => 'forced',
          };

      expect(label(const AppUpToDate()), 'none');
      expect(label(const AppOptionalUpdate(info)), 'optional');
      expect(label(const AppForcedUpdate(info)), 'forced');
    });
  });
}
