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
  /// Navy primary ramp. The signature brand colour `#1A3C5E` sits at `600`
  /// (the resting fill of primary buttons / headers); `400` is the medium
  /// navy used for active nav items and field labels.
  static final Map<String, String> brandColor = {
    '25': '#F3F6F9',
    '50': '#E9EFF4',
    '100': '#D2DFEA',
    '200': '#A6BFD3',
    '300': '#7A9EBD',
    '400': '#3E6B92',
    '500': '#27557D',
    '600': '#1A3C5E',
    '700': '#142F49',
    '800': '#0E2234',
    '900': '#081521',
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
