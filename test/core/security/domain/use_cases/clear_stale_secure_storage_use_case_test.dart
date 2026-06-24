import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_project_flutter_clean_bloc/core/security/domain/repositories/device_session_repository.dart';
import 'package:pet_project_flutter_clean_bloc/core/security/domain/use_cases/clear_stale_secure_storage_use_case.dart';
import 'package:pet_project_flutter_clean_bloc/core/use_case/use_case.dart';

class MockDeviceSessionRepository extends Mock
    implements DeviceSessionRepository {}

void main() {
  late MockDeviceSessionRepository repo;

  setUp(() {
    repo = MockDeviceSessionRepository();
  });

  ClearStaleSecureStorageUseCase build() =>
      ClearStaleSecureStorageUseCase(repository: repo);

  test('no-op when current vendor id is null (non-iOS)', () async {
    when(() => repo.currentVendorId()).thenReturn(null);

    await build().execute(const NoParams());

    verify(() => repo.currentVendorId()).called(1);
    verifyNever(() => repo.savedVendorId());
    verifyNever(() => repo.clearSecureStorage());
    verifyNever(() => repo.saveVendorId(any()));
  });

  test('no-op when saved id matches current id', () async {
    when(() => repo.currentVendorId()).thenReturn('vendor-1');
    when(() => repo.savedVendorId()).thenReturn('vendor-1');

    await build().execute(const NoParams());

    verifyNever(() => repo.clearSecureStorage());
    verifyNever(() => repo.saveVendorId(any()));
  });

  test('clears storage and saves new id on reinstall (id changed)', () async {
    when(() => repo.currentVendorId()).thenReturn('vendor-2');
    when(() => repo.savedVendorId()).thenReturn('vendor-1');
    when(() => repo.clearSecureStorage()).thenAnswer((_) async {});
    when(() => repo.saveVendorId(any())).thenAnswer((_) async {});

    await build().execute(const NoParams());

    verify(() => repo.clearSecureStorage()).called(1);
    verify(() => repo.saveVendorId('vendor-2')).called(1);
  });

  test('clears storage and saves id when no saved id exists (fresh install)',
      () async {
    when(() => repo.currentVendorId()).thenReturn('vendor-3');
    when(() => repo.savedVendorId()).thenReturn(null);
    when(() => repo.clearSecureStorage()).thenAnswer((_) async {});
    when(() => repo.saveVendorId(any())).thenAnswer((_) async {});

    await build().execute(const NoParams());

    verify(() => repo.clearSecureStorage()).called(1);
    verify(() => repo.saveVendorId('vendor-3')).called(1);
  });
}
