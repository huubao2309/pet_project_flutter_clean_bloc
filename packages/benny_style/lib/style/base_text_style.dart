import 'package:flutter/material.dart';
import 'package:benny_style/font/font_family.dart';
import 'package:benny_style/font/font_size.dart';
import 'package:benny_style/font/font_weight.dart';
import 'package:benny_style/font/line_height.dart';
import 'package:benny_style/font/benny_font.dart';

import 'data_source_text_style.dart';

class BaseTextStyle {
  late final TextStyle small;
  late final TextStyle medium;
  late final TextStyle large;

  BaseTextStyle({DataSourceTextStyle? dataSource}) {
    small = _textStyle(
        dataSource?.font ?? _defaultFont,
        dataSource?.fontSizeSmall ?? _fontSize.sm.h3Size,
        dataSource?.lineHeightSmall ?? _lineHeight.sm.h3Line,
        dataSource?.fontWeight ?? _fontWeight.w400,
        dataSource?.package);

    medium = _textStyle(
        dataSource?.font ?? _defaultFont,
        dataSource?.fontSizeMedium ?? _fontSize.md.h3Size,
        dataSource?.lineHeightMedium ?? _lineHeight.md.h3Line,
        dataSource?.fontWeight ?? _fontWeight.w400,
        dataSource?.package);

    large = _textStyle(
        dataSource?.font ?? _defaultFont,
        dataSource?.fontSizeLarge ?? _fontSize.lg.h3Size,
        dataSource?.lineHeightLarge ?? _lineHeight.lg.h3Line,
        dataSource?.fontWeight ?? _fontWeight.w600,
        dataSource?.package);
  }

  BennyFontFamily get _defaultFont => BennyFont().geistMono;
  BennyFontSize get _fontSize => BennyFontSize();
  BennyLineHeight get _lineHeight => BennyLineHeight();
  BennyFontWeight get _fontWeight => BennyFontWeight();

  TextStyle _textStyle(BennyFontFamily font, double fontSize, double lineHeight,
      FontWeight fontWeight, String? package) {
    return font.textStyle(
        fontSize: fontSize,
        height: lineHeight,
        fontWeight: fontWeight,
        package: package);
  }
}
