library;

import 'package:benny_style/border_radius/benny_border_radius.dart';
import 'package:benny_style/colors/benny_color.dart';
import 'package:benny_style/spacing/benny_spacing.dart';
import 'package:benny_style/style/data_source_caption_text_style.dart';
import 'package:benny_style/style/data_source_paragraph_text_style.dart';
import 'package:benny_style/style/data_source_text_style.dart';
import 'package:benny_style/style/benny_text_style.dart';

class BennyStyle {
  late final BennyColor _color;
  late final BennySpacing _spacing;
  late final BennyTextStyle _textStyle;
  late final BennyBorderRadius _borderRadius;

  static BennyStyle? _instance;
  BennyStyle._privateConstructor();
  static BennyStyle get instance =>
      _instance ??= BennyStyle._privateConstructor();

  BennyColor get color => _color;
  BennySpacing get spacing => _spacing;
  BennyTextStyle get textStyle => _textStyle;
  BennyBorderRadius get borderRadius => _borderRadius;

  void initData({
    required Map<String, String> brandSourceColor,
    required DataSourceTextStyle dataSourceHeading,
    required DataSourceParagraphTextStyle dataSourceParagraph,
    required DataSourceCaptionTextStyle dataSourceCaption,
  }) {
    _color = BennyColor(brandSourceColor: brandSourceColor);
    _spacing = BennySpacing();
    _textStyle = BennyTextStyle(
        dataSourceHeading: dataSourceHeading,
        dataSourceCaption: dataSourceCaption,
        dataSourceParagraph: dataSourceParagraph);
    _borderRadius = BennyBorderRadius();
  }
}
