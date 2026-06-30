import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_project_flutter_clean_bloc/core/storage/local_storage/local_storage.dart';
import 'package:pet_project_flutter_clean_bloc/core/storage/local_storage/local_storage_impl.dart';
import 'package:pet_project_flutter_clean_bloc/core/storage/local_storage/local_storage_wrapper/local_storage.dart';

class MockKeyValueStore extends Mock implements LocalKeyValueStore {}

void main() {
  late MockKeyValueStore store;
  late LocalStorageImpl storage;

  setUp(() {
    store = MockKeyValueStore();
    storage = LocalStorageImpl(store);
    when(() => store.setString(any(), any())).thenAnswer((_) async {});
  });

  group('phone number', () {
    test('writes under the phone-number key', () async {
      await storage.setPhoneNumber(value: '0900000000');
      verify(() => store.setString(LocalStorage.kPhoneNumberKey, '0900000000'))
          .called(1);
    });

    test('persists empty string when value is null', () async {
      await storage.setPhoneNumber(value: null);
      verify(() => store.setString(LocalStorage.kPhoneNumberKey, '')).called(1);
    });

    test('reads the stored value, or empty string when absent', () {
      when(() => store.getString(LocalStorage.kPhoneNumberKey))
          .thenReturn('0123456789');
      expect(storage.getPhoneNumber(), '0123456789');

      when(() => store.getString(LocalStorage.kPhoneNumberKey))
          .thenReturn(null);
      expect(storage.getPhoneNumber(), '');
    });
  });

  group('device language', () {
    test('stores only the language code', () async {
      await storage.setDeviceLanguage(value: const Locale('vi'));
      verify(() => store.setString(LocalStorage.kDeviceLanguageKey, 'vi'))
          .called(1);
    });

    test('maps a stored code back to a Locale, or null when empty', () {
      when(() => store.getString(LocalStorage.kDeviceLanguageKey))
          .thenReturn('en');
      expect(storage.getDeviceLanguage(), const Locale('en'));

      when(() => store.getString(LocalStorage.kDeviceLanguageKey))
          .thenReturn('');
      expect(storage.getDeviceLanguage(), isNull);

      when(() => store.getString(LocalStorage.kDeviceLanguageKey))
          .thenReturn(null);
      expect(storage.getDeviceLanguage(), isNull);
    });
  });

  group('vendor id', () {
    test('writes and reads through the store', () async {
      await storage.setVendorId(value: 'vendor-1');
      verify(() => store.setString(LocalStorage.kVendorIdKey, 'vendor-1'))
          .called(1);

      when(() => store.getString(LocalStorage.kVendorIdKey))
          .thenReturn('vendor-1');
      expect(storage.getVendorId(), 'vendor-1');
    });
  });

  group('dismissed update version', () {
    test('reads the value, normalising empty to null', () {
      when(() => store.getString(LocalStorage.kDismissedUpdateVersionKey))
          .thenReturn('2.4.0');
      expect(storage.getDismissedUpdateVersion(), '2.4.0');

      when(() => store.getString(LocalStorage.kDismissedUpdateVersionKey))
          .thenReturn('');
      expect(storage.getDismissedUpdateVersion(), isNull);
    });
  });

  group('theme mode', () {
    test('writes and reads the raw value', () async {
      await storage.setThemeMode(value: 'dark');
      verify(() => store.setString(LocalStorage.kThemeModeKey, 'dark'))
          .called(1);

      when(() => store.getString(LocalStorage.kThemeModeKey))
          .thenReturn('dark');
      expect(storage.getThemeMode(), 'dark');
    });
  });
}
