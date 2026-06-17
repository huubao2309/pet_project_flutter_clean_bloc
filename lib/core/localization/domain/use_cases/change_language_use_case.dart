import 'dart:ui' show Locale;

import '../../../use_case/use_case.dart';
import '../repositories/language_repository.dart';

/// Persists the user's chosen app language.
class ChangeLanguageUseCase implements UseCase<void, Locale> {
  const ChangeLanguageUseCase({required this.languageRepository});

  final LanguageRepository languageRepository;

  @override
  Future<void> execute(Locale params) =>
      languageRepository.saveLanguage(params);
}
