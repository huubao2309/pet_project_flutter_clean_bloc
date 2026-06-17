import 'dart:ui' show Locale;

import '../../../use_case/use_case.dart';
import '../repositories/language_repository.dart';

/// Returns the saved app language, or null if none has been chosen.
class GetLanguageUseCase implements UseCase<Locale?, NoParams> {
  const GetLanguageUseCase({required this.languageRepository});

  final LanguageRepository languageRepository;

  @override
  Future<Locale?> execute(NoParams _) async => languageRepository.getLanguage();
}
