import 'package:benny_style/font/font_family.dart';
import 'package:benny_style/font/font_size.dart';
import 'package:benny_style/font/font_weight.dart';
import 'package:benny_style/font/line_height.dart';
import 'package:benny_style/font/benny_font.dart';
import 'package:benny_style/style/base_text_style.dart';
import 'package:benny_style/style/data_source_paragraph_text_style.dart';
import 'package:benny_style/style/data_source_text_style.dart';

import 'data_source_caption_text_style.dart';

class BennyTextStyle {
  late final BaseTextStyle heading;
  late final BaseParagraphTextStyle paragraph;
  late final BaseCaptionTextStyle caption;
  late final DataSourceTextStyle? dataSourceHeading;
  late final DataSourceParagraphTextStyle? dataSourceParagraph;
  late final DataSourceCaptionTextStyle? dataSourceCaption;

  BennyTextStyle(
      {required this.dataSourceHeading,
      required this.dataSourceParagraph,
      required this.dataSourceCaption}) {
    heading = BaseTextStyle(dataSource: dataSourceHeading);
    paragraph = BaseParagraphTextStyle(dataSource: dataSourceParagraph);
    caption = BaseCaptionTextStyle(dataSource: dataSourceCaption);
  }
}

abstract class BaseParaCapTextStyle {
  late final BaseTextStyle defaultPrimary;
  late final BaseTextStyle inlineLink;
  late final BaseTextStyle mono;
}

class BaseParagraphTextStyle implements BaseParaCapTextStyle {
  late final BaseTextStyle label;
  late final BaseTextStyle labelLink;

  @override
  late final BaseTextStyle defaultPrimary;
  @override
  late final BaseTextStyle inlineLink;
  @override
  late BaseTextStyle mono;

  late final BennyFontFamily? font;
  late final BennyFontSize? fontSize;
  late final BennyLineHeight? lineHeight;
  late final DataSourceParagraphTextStyle? dataSource;

  BaseParagraphTextStyle({this.dataSource}) {
    final geistMonoFont = BennyFont().geistMono;
    final monoFontSize = BennyFontSize();
    final monoLineHeight = BennyLineHeight();
    final fontWeight = BennyFontWeight();

    labelLink = BaseTextStyle(dataSource: dataSource?.labelLink);
    label = BaseTextStyle(dataSource: dataSource?.label);
    mono = BaseTextStyle(
        dataSource: DataSourceTextStyle(
            font: geistMonoFont,
            fontSizeSmall: monoFontSize.sm.pSize,
            fontSizeMedium: monoFontSize.md.pSize,
            fontSizeLarge: monoFontSize.lg.pSize,
            lineHeightSmall: monoLineHeight.sm.pLine,
            lineHeightMedium: monoLineHeight.md.pLine,
            lineHeightLarge: monoLineHeight.lg.pLine,
            fontWeight: fontWeight.w400));
    inlineLink = BaseTextStyle(dataSource: dataSource?.inlineLink);
    defaultPrimary = BaseTextStyle(dataSource: dataSource?.defaultPrimary);
  }
}

class BaseCaptionTextStyle implements BaseParaCapTextStyle {
  @override
  late final BaseTextStyle defaultPrimary;
  @override
  late final BaseTextStyle inlineLink;
  @override
  late final BaseTextStyle mono;
  late final DataSourceCaptionTextStyle? dataSource;

  BaseCaptionTextStyle({this.dataSource}) {
    final geistMonoFont = BennyFont().geistMono;
    final monoFontSize = BennyFontSize();
    final monoLineHeight = BennyLineHeight();
    final fontWeight = BennyFontWeight();
    mono = BaseTextStyle(
        dataSource: DataSourceTextStyle(
            font: geistMonoFont,
            fontSizeSmall: monoFontSize.sm.capSize,
            fontSizeMedium: monoFontSize.md.capSize,
            fontSizeLarge: monoFontSize.lg.capSize,
            lineHeightSmall: monoLineHeight.sm.capLine,
            lineHeightMedium: monoLineHeight.md.capLine,
            lineHeightLarge: monoLineHeight.lg.capLine,
            fontWeight: fontWeight.w400));
    inlineLink = BaseTextStyle(dataSource: dataSource?.inlineLink);
    defaultPrimary = BaseTextStyle(dataSource: dataSource?.defaultPrimary);
  }
}
