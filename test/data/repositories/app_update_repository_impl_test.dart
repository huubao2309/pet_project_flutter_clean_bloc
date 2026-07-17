import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_project_flutter_clean_bloc/core/storage/local_storage/local_storage.dart';
import 'package:pet_project_flutter_clean_bloc/data/datasources/app_update_remote_data_source.dart';
import 'package:pet_project_flutter_clean_bloc/data/models/app_update/app_update_config_dto.dart';
import 'package:pet_project_flutter_clean_bloc/data/repositories/app_update_repository_impl.dart';
import 'package:pet_project_flutter_clean_bloc/features/app_update/domain/entities/app_update_config.dart';

class MockAppUpdateRemoteDataSource extends Mock
    implements AppUpdateRemoteDataSource {}

class MockLocalStorage extends Mock implements LocalStorage {}

void main() {
  late MockAppUpdateRemoteDataSource remote;
  late MockLocalStorage localStorage;
  late AppUpdateRepositoryImpl repository;

  setUp(() {
    remote = MockAppUpdateRemoteDataSource();
    localStorage = MockLocalStorage();
    repository = AppUpdateRepositoryImpl(
      remoteDataSource: remote,
      localStorage: localStorage,
    );
  });

  group('fetchConfig', () {
    test('maps a non-null DTO to a domain entity', () async {
      when(() => remote.fetchConfig()).thenAnswer(
        (_) async => const AppUpdateConfigDto(
          latestVersion: '2.5.0',
          minRequiredVersion: '2.0.0',
          forceUpdate: true,
          androidUrl: 'https://play',
          iosUrl: 'https://app',
          releaseNotes: 'notes',
        ),
      );

      final config = await repository.fetchConfig();

      expect(config, isA<AppUpdateConfig>());
      expect(config!.latestVersion, '2.5.0');
      expect(config.minRequiredVersion, '2.0.0');
      expect(config.forceUpdate, isTrue);
      expect(config.message, 'notes');
      // Platform-resolved store URL is one of the two provided.
      expect(config.storeUrl, anyOf('https://play', 'https://app'));
    });

    test('returns null when the data source reports no update', () async {
      when(() => remote.fetchConfig()).thenAnswer((_) async => null);
      expect(await repository.fetchConfig(), isNull);
    });
  });

  group('lastDismissedVersion', () {
    test('returns the stored dismissed version', () async {
      when(() => localStorage.getDismissedUpdateVersion()).thenReturn('1.2.3');
      expect(await repository.lastDismissedVersion(), '1.2.3');
    });

    test('returns null when nothing was dismissed', () async {
      when(() => localStorage.getDismissedUpdateVersion()).thenReturn(null);
      expect(await repository.lastDismissedVersion(), isNull);
    });
  });

  group('saveDismissedVersion', () {
    test('persists the version through local storage', () async {
      when(
        () => localStorage.setDismissedUpdateVersion(
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});

      await repository.saveDismissedVersion('3.0.0');

      verify(
        () => localStorage.setDismissedUpdateVersion(value: '3.0.0'),
      ).called(1);
    });
  });

  group('openStore', () {
    test('returns early without launching for an empty url', () async {
      // No url_launcher plugin is available under flutter_test; the empty-url
      // guard means this must complete without touching the launcher.
      await expectLater(repository.openStore(''), completes);
    });
  });
}
