import 'package:benny_style/font/font_family.dart';
import 'package:benny_style/font/font_size.dart';
import 'package:benny_style/font/font_weight.dart';
import 'package:benny_style/font/line_height.dart';
import 'package:benny_style/font/benny_font.dart';
import 'package:benny_style/style/data_source_caption_text_style.dart';
import 'package:benny_style/style/data_source_paragraph_text_style.dart';
import 'package:benny_style/style/data_source_text_style.dart';

/// Brand-specific design tokens fed into [BennyStyle.initData].
///
/// This is the single place that defines Benny's palette and typography for
/// the `benny_style` design system.
class BennyDesignData {
  static final Map<String, String> brandColor = {
    '25': '#F9F5FF',
    '50': '#F5EEFF',
    '100': '#F1E6FF',
    '200': '#E4D2FD',
    '300': '#D8BEFC',
    '400': '#AD7AF0',
    '500': '#782ADE',
    '600': '#5803C4',
    '700': '#460299',
    '800': '#35016B',
    '900': '#250040',
  };

  static final DataSourceTextStyle dataSourceHeading = _getDataSourceHeading();
  static final DataSourceParagraphTextStyle dataSourceParagraph =
      _getDataSourceParagraph();
  static final DataSourceCaptionTextStyle dataSourceCaption =
      _getDataSourceCaption();

  static DataSourceTextStyle _getDataSourceHeading() {
    final fontSize = BennyFontSize();
    final lineHeight = BennyLineHeight();
    final fontWeight = BennyFontWeight();
    final font = _getFont();
    return DataSourceTextStyle(
      font: font,
      fontSizeSmall: fontSize.sm.h3Size,
      fontSizeMedium: fontSize.md.h3Size,
      fontSizeLarge: fontSize.lg.h3Size,
      lineHeightSmall: lineHeight.sm.h3Line,
      lineHeightMedium: lineHeight.md.h3Line,
      lineHeightLarge: lineHeight.lg.h3Line,
      fontWeight: fontWeight.w600,
    );
  }

  static DataSourceParagraphTextStyle _getDataSourceParagraph() {
    final fontSize = BennyFontSize();
    final lineHeight = BennyLineHeight();
    final fontWeight = BennyFontWeight();
    final font = _getFont();
    return DataSourceParagraphTextStyle(
      labelLink: DataSourceTextStyle(
        font: font,
        fontSizeSmall: fontSize.sm.pSize,
        fontSizeMedium: fontSize.md.pSize,
        fontSizeLarge: fontSize.lg.pSize,
        lineHeightSmall: lineHeight.sm.pLine,
        lineHeightMedium: lineHeight.md.pLine,
        lineHeightLarge: lineHeight.lg.pLine,
        fontWeight: fontWeight.w500,
      ),
      label: DataSourceTextStyle(
        font: font,
        fontSizeSmall: fontSize.sm.pSize,
        fontSizeMedium: fontSize.md.pSize,
        fontSizeLarge: fontSize.lg.pSize,
        lineHeightSmall: lineHeight.sm.pLine,
        lineHeightMedium: lineHeight.md.pLine,
        lineHeightLarge: lineHeight.lg.pLine,
        fontWeight: fontWeight.w500,
      ),
      inlineLink: DataSourceTextStyle(
        font: font,
        fontSizeSmall: fontSize.sm.pSize,
        fontSizeMedium: fontSize.md.pSize,
        fontSizeLarge: fontSize.lg.pSize,
        lineHeightSmall: lineHeight.sm.pLine,
        lineHeightMedium: lineHeight.md.pLine,
        lineHeightLarge: lineHeight.lg.pLine,
        fontWeight: fontWeight.w400,
      ),
      defaultPrimary: DataSourceTextStyle(
        font: font,
        fontSizeSmall: fontSize.sm.pSize,
        fontSizeMedium: fontSize.md.pSize,
        fontSizeLarge: fontSize.lg.pSize,
        lineHeightSmall: lineHeight.sm.pLine,
        lineHeightMedium: lineHeight.md.pLine,
        lineHeightLarge: lineHeight.lg.pLine,
        fontWeight: fontWeight.w400,
      ),
    );
  }

  static DataSourceCaptionTextStyle _getDataSourceCaption() {
    final fontSize = BennyFontSize();
    final lineHeight = BennyLineHeight();
    final fontWeight = BennyFontWeight();
    final font = _getFont();
    return DataSourceCaptionTextStyle(
      inlineLink: DataSourceTextStyle(
        font: font,
        fontSizeSmall: fontSize.sm.capSize,
        fontSizeMedium: fontSize.md.capSize,
        fontSizeLarge: fontSize.lg.capSize,
        lineHeightSmall: lineHeight.sm.capLine,
        lineHeightMedium: lineHeight.md.capLine,
        lineHeightLarge: lineHeight.lg.capLine,
        fontWeight: fontWeight.w400,
      ),
      defaultPrimary: DataSourceTextStyle(
        font: font,
        fontSizeSmall: fontSize.sm.capSize,
        fontSizeMedium: fontSize.md.capSize,
        fontSizeLarge: fontSize.lg.capSize,
        lineHeightSmall: lineHeight.sm.capLine,
        lineHeightMedium: lineHeight.md.capLine,
        lineHeightLarge: lineHeight.lg.capLine,
        fontWeight: fontWeight.w400,
      ),
    );
  }

  static BennyFontFamily _getFont() {
    return BennyFont(fontFamilyPrimary: 'Figtree').primary;
  }
}
