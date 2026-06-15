import 'package:benny_style/font/font_family.dart';

class BennyFont {
  late BennyFontFamily geistMono;
  late BennyFontFamily primary;

  late String? fontFamilyPrimary;

  BennyFont({String? fontFamilyPrimary}) {
    const String geistMonoFontName = "geistMono";
    geistMono = BennyFontFamily(geistMonoFontName);
    primary = BennyFontFamily(fontFamilyPrimary ?? geistMonoFontName);
  }
}
