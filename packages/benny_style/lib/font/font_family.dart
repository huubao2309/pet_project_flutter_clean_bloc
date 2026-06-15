import 'package:flutter/material.dart';
import 'package:benny_style/benny_constant.dart';

class BennyFontFamily {
  late final String name;
  BennyFontFamily(this.name);

  static const double letterSpacing = -2 / 100;

  TextStyle textStyle({
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    double? height,
    double? letterSpacing = letterSpacing,
    String? package,
  }) {
    final double letterSpacingDefault =
        ((fontSize ?? 0) * (letterSpacing ?? 0));
    final double lineHeight = _getLineHeight(height ?? 1, fontSize ?? 1);
    return TextStyle(
      fontFamily: name,
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      package: package ?? BennyConstant.packageName,
      height: lineHeight,
      leadingDistribution: TextLeadingDistribution.even,
      letterSpacing: letterSpacing ?? letterSpacingDefault,
    );
  }

  double _getLineHeight(double height, double size) {
    if (size <= 0) {
      return 1;
    }
    return height / size;
  }
}

extension CareFontFamilyTextStyle on TextStyle {
  TextStyle applyFont(BennyFontFamily font) => copyWith(
        fontFamily: font.name,
        package: BennyConstant.packageName,
      );
}
