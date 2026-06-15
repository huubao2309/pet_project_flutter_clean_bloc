import 'dart:ui';

import 'package:benny_style/font/font_family.dart';

class DataSourceTextStyle {
  final BennyFontFamily font;
  final double fontSizeSmall;
  final double fontSizeMedium;
  final double fontSizeLarge;
  final double lineHeightSmall;
  final double lineHeightMedium;
  final double lineHeightLarge;
  final FontWeight fontWeight;
  final String? package;

  DataSourceTextStyle(
      {required this.font,
      required this.fontSizeSmall,
      required this.fontSizeMedium,
      required this.fontSizeLarge,
      required this.lineHeightSmall,
      required this.lineHeightMedium,
      required this.lineHeightLarge,
      required this.fontWeight,
      this.package});
}
