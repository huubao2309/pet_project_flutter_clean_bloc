import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_project_flutter_clean_bloc/core/localization/data/repositories/language_repository_impl.dart';
import 'package:pet_project_flutter_clean_bloc/core/storage/local_storage/local_storage.dart';

class MockLocalStorage extends Mock implements LocalStorage {}

void main() {
  setUpAll(() {
    registerFallbackValue(const Locale('en'));
  });

  late MockLocalStorage storage;
  late LanguageRepositoryImpl repository;

  setUp(() {
    storage = MockLocalStorage();
    repository = LanguageRepositoryImpl(localStorage: storage);
  });

  group('getLanguage', () {
    test('returns the locale from storage', () {
      when(() => storage.getDeviceLanguage()).thenReturn(const Locale('vi'));
      expect(repository.getLanguage(), const Locale('vi'));
    });

    test('returns null when no language is saved', () {
      when(() => storage.getDeviceLanguage()).thenReturn(null);
      expect(repository.getLanguage(), isNull);
    });
  });

  group('saveLanguage', () {
    test('delegates the locale to storage', () async {
      when(() => storage.setDeviceLanguage(value: any(named: 'value')))
          .thenAnswer((_) async {});

      await repository.saveLanguage(const Locale('en'));

      verify(() => storage.setDeviceLanguage(value: const Locale('en')))
          .called(1);
    });
  });
}
