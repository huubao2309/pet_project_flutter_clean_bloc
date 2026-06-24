import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_project_flutter_clean_bloc/core/security/data/repositories/device_session_repository_impl.dart';
import 'package:pet_project_flutter_clean_bloc/core/storage/local_storage/local_storage.dart';
import 'package:pet_project_flutter_clean_bloc/core/storage/secure_storage/secure_storage.dart';
import 'package:pet_project_flutter_clean_bloc/core/utils/device_info_util.dart';

class MockDeviceInfoUtil extends Mock implements DeviceInfoUtil {}

class MockLocalStorage extends Mock implements LocalStorage {}

class MockSecureStorage extends Mock implements SecureStorage {}

void main() {
  late MockDeviceInfoUtil deviceInfo;
  late MockLocalStorage localStorage;
  late MockSecureStorage secureStorage;
  late DeviceSessionRepositoryImpl repository;

  setUp(() {
    deviceInfo = MockDeviceInfoUtil();
    localStorage = MockLocalStorage();
    secureStorage = MockSecureStorage();
    repository = DeviceSessionRepositoryImpl(
      deviceInfo: deviceInfo,
      localStorage: localStorage,
      secureStorage: secureStorage,
    );
  });

  group('currentVendorId', () {
    test('returns the iOS vendor id from device info', () {
      when(() => deviceInfo.iosVendorId).thenReturn('vendor-123');
      expect(repository.currentVendorId(), 'vendor-123');
    });

    test('returns null when device info has no vendor id', () {
      when(() => deviceInfo.iosVendorId).thenReturn(null);
      expect(repository.currentVendorId(), isNull);
    });
  });

  group('savedVendorId', () {
    test('returns the persisted vendor id', () {
      when(() => localStorage.getVendorId()).thenReturn('saved-1');
      expect(repository.savedVendorId(), 'saved-1');
    });

    test('returns null when none saved', () {
      when(() => localStorage.getVendorId()).thenReturn(null);
      expect(repository.savedVendorId(), isNull);
    });
  });

  group('saveVendorId', () {
    test('delegates to local storage', () async {
      when(() => localStorage.setVendorId(value: any(named: 'value')))
          .thenAnswer((_) async {});

      await repository.saveVendorId('new-vendor');

      verify(() => localStorage.setVendorId(value: 'new-vendor')).called(1);
    });
  });

  group('clearSecureStorage', () {
    test('wipes all secure data', () async {
      when(() => secureStorage.clearAll()).thenAnswer((_) async {});

      await repository.clearSecureStorage();

      verify(() => secureStorage.clearAll()).called(1);
    });
  });
}
