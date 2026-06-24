import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_project_flutter_clean_bloc/core/use_case/use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/app_update/domain/entities/app_update_config.dart';
import 'package:pet_project_flutter_clean_bloc/features/app_update/domain/entities/app_update_status.dart';
import 'package:pet_project_flutter_clean_bloc/features/app_update/domain/repositories/app_update_repository.dart';
import 'package:pet_project_flutter_clean_bloc/features/app_update/domain/use_cases/check_app_update_use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/app_update/domain/use_cases/dismiss_optional_update_use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/app_update/domain/use_cases/open_store_use_case.dart';

class MockAppUpdateRepository extends Mock implements AppUpdateRepository {}

AppUpdateConfig config({
  String latest = '2.0.0',
  String minRequired = '1.0.0',
  bool forceUpdate = false,
  String storeUrl = 'https://store',
  String? message,
}) =>
    AppUpdateConfig(
      latestVersion: latest,
      minRequiredVersion: minRequired,
      forceUpdate: forceUpdate,
      storeUrl: storeUrl,
      message: message,
    );

void main() {
  late MockAppUpdateRepository repo;

  setUp(() {
    repo = MockAppUpdateRepository();
  });

  group('DismissOptionalUpdateUseCase', () {
    test('delegates version to repository.saveDismissedVersion', () async {
      when(() => repo.saveDismissedVersion(any())).thenAnswer((_) async {});

      await DismissOptionalUpdateUseCase(repository: repo).execute('2.0.0');

      verify(() => repo.saveDismissedVersion('2.0.0')).called(1);
    });
  });

  group('OpenStoreUseCase', () {
    test('delegates url to repository.openStore', () async {
      when(() => repo.openStore(any())).thenAnswer((_) async {});

      await OpenStoreUseCase(repository: repo).execute('https://store/app');

      verify(() => repo.openStore('https://store/app')).called(1);
    });
  });

  group('CheckAppUpdateUseCase', () {
    CheckAppUpdateUseCase build() => CheckAppUpdateUseCase(repository: repo);

    test('AppUpToDate when config is null', () async {
      when(() => repo.fetchConfig()).thenAnswer((_) async => null);

      final result = await build().execute(const NoParams());

      expect(result, isA<AppUpToDate>());
      verifyNever(() => repo.currentVersion());
    });

    test('AppUpToDate when current version is not lower than latest', () async {
      when(() => repo.fetchConfig()).thenAnswer((_) async => config());
      when(() => repo.currentVersion()).thenAnswer((_) async => '2.0.0');

      final result = await build().execute(const NoParams());

      expect(result, isA<AppUpToDate>());
    });

    test('AppForcedUpdate when config.forceUpdate is true', () async {
      when(() => repo.fetchConfig()).thenAnswer(
        (_) async => config(forceUpdate: true, message: 'notes'),
      );
      when(() => repo.currentVersion()).thenAnswer((_) async => '1.0.0');

      final result = await build().execute(const NoParams());

      expect(result, isA<AppForcedUpdate>());
      final forced = result as AppForcedUpdate;
      expect(forced.info.latestVersion, '2.0.0');
      expect(forced.info.storeUrl, 'https://store');
      expect(forced.info.message, 'notes');
      verifyNever(() => repo.lastDismissedVersion());
    });

    test('AppForcedUpdate when current is below minRequiredVersion', () async {
      when(() => repo.fetchConfig()).thenAnswer(
        (_) async => config(minRequired: '1.5.0'),
      );
      when(() => repo.currentVersion()).thenAnswer((_) async => '1.4.0');

      final result = await build().execute(const NoParams());

      expect(result, isA<AppForcedUpdate>());
    });

    test('AppOptionalUpdate when newer and not dismissed', () async {
      when(() => repo.fetchConfig()).thenAnswer((_) async => config());
      when(() => repo.currentVersion()).thenAnswer((_) async => '1.0.0');
      when(() => repo.lastDismissedVersion()).thenAnswer((_) async => null);

      final result = await build().execute(const NoParams());

      expect(result, isA<AppOptionalUpdate>());
      expect((result as AppOptionalUpdate).info.latestVersion, '2.0.0');
    });

    test('AppUpToDate when dismissed version >= latest', () async {
      when(() => repo.fetchConfig()).thenAnswer((_) async => config());
      when(() => repo.currentVersion()).thenAnswer((_) async => '1.0.0');
      when(() => repo.lastDismissedVersion()).thenAnswer((_) async => '2.0.0');

      final result = await build().execute(const NoParams());

      expect(result, isA<AppUpToDate>());
    });

    test('AppOptionalUpdate when dismissed version is older than latest', () async {
      when(() => repo.fetchConfig()).thenAnswer((_) async => config());
      when(() => repo.currentVersion()).thenAnswer((_) async => '1.0.0');
      when(() => repo.lastDismissedVersion()).thenAnswer((_) async => '1.5.0');

      final result = await build().execute(const NoParams());

      expect(result, isA<AppOptionalUpdate>());
    });
  });
}
