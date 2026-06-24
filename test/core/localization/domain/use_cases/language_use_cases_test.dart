import 'dart:ui' show Locale;

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_project_flutter_clean_bloc/core/localization/domain/repositories/language_repository.dart';
import 'package:pet_project_flutter_clean_bloc/core/localization/domain/use_cases/change_language_use_case.dart';
import 'package:pet_project_flutter_clean_bloc/core/localization/domain/use_cases/get_language_use_case.dart';
import 'package:pet_project_flutter_clean_bloc/core/use_case/use_case.dart';

class MockLanguageRepository extends Mock implements LanguageRepository {}

void main() {
  late MockLanguageRepository repo;

  setUpAll(() {
    registerFallbackValue(const Locale('en'));
  });

  setUp(() {
    repo = MockLanguageRepository();
  });

  group('ChangeLanguageUseCase', () {
    test('delegates locale to repository.saveLanguage', () async {
      const locale = Locale('vi');
      when(() => repo.saveLanguage(any())).thenAnswer((_) async {});

      await ChangeLanguageUseCase(languageRepository: repo).execute(locale);

      verify(() => repo.saveLanguage(locale)).called(1);
    });
  });

  group('GetLanguageUseCase', () {
    test('returns repository.getLanguage result', () async {
      const locale = Locale('en');
      when(() => repo.getLanguage()).thenReturn(locale);

      final result = await GetLanguageUseCase(languageRepository: repo)
          .execute(const NoParams());

      expect(result, locale);
      verify(() => repo.getLanguage()).called(1);
    });

    test('returns null when no language saved', () async {
      when(() => repo.getLanguage()).thenReturn(null);

      final result = await GetLanguageUseCase(languageRepository: repo)
          .execute(const NoParams());

      expect(result, isNull);
    });
  });
}
