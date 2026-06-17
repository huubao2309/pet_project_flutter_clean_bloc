import 'dart:ui';

const String kAppName = 'Benny';

abstract final class AppConstants {
  static const List<Locale> supportedLocales = [Locale('vi'), Locale('en')];
  static const Locale fallbackLocale = Locale('vi');
  static const String translationsPath = 'assets/translations';
  static const String appVersion = '1.0.0';
}
