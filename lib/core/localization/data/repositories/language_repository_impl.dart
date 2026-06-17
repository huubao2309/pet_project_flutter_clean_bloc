import 'dart:ui' show Locale;

import '../../../storage/local_storage/local_storage.dart';
import '../../domain/repositories/language_repository.dart';

/// [LanguageRepository] backed by [LocalStorage] (key `benny_device_language`).
class LanguageRepositoryImpl implements LanguageRepository {
  const LanguageRepositoryImpl({required LocalStorage localStorage})
      : _localStorage = localStorage;

  final LocalStorage _localStorage;

  @override
  Locale? getLanguage() => _localStorage.getDeviceLanguage();

  @override
  Future<void> saveLanguage(Locale locale) =>
      _localStorage.setDeviceLanguage(value: locale);
}
