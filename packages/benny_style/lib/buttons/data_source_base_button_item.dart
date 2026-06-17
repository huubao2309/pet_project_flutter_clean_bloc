import 'package:flutter/material.dart';
import 'package:benny_style/benny_locator.dart';
import 'package:benny_style/theme/app_colors.dart';
import 'package:benny_style/theme/theme_state.dart';

class BrandDataSourceStyle {
  static AppColors get _color => bennyLocator<ThemeState>().colors;

  static final Map<String, Color> brandPrimary = {
    // Disabled = design `.cta.off`: light gray fill + gray-400 label, no border.
    "borderDisableColor": _color.neutral100,
    "borderActiveColor": _color.brand800,
    "foregroundActiveColor": _color.brand25,
    "foregroundDisableColor": _color.neutral400,
    "backgroundActiveColor": _color.brand700,
    "backgroundDisableColor": _color.neutral100,
    "overlayActiveColor": _color.brand900,
  };

  static final Map<String, Color> brandSecondary = {
    "borderDisableColor": _color.neutral500,
    "borderActiveColor": _color.brand200,
    "foregroundActiveColor": _color.brand700,
    "foregroundDisableColor": _color.neutral600,
    "backgroundActiveColor": _color.brand100,
    "backgroundDisableColor": _color.neutral400,
    "overlayActiveColor": _color.brand300,
  };

  static final Map<String, Color> brandTertiary = {
    "borderDisableColor": _color.neutral100,
    "borderActiveColor": _color.neutral100,
    "foregroundActiveColor": _color.brand700,
    "foregroundDisableColor": _color.neutral500,
    "backgroundActiveColor": _color.white,
    "backgroundDisableColor": _color.white,
    "overlayActiveColor": _color.neutral200,
  };

  static final Map<String, Color> brandGhost = {
    "borderDisableColor": _color.white,
    "borderActiveColor": _color.transparent,
    "foregroundActiveColor": _color.brand700,
    "foregroundDisableColor": _color.neutral500,
    "backgroundActiveColor": _color.white,
    "backgroundDisableColor": _color.white,
    "overlayActiveColor": _color.neutral100,
  };
}

class SuccessDataSourceStyle {
  static AppColors get _color => bennyLocator<ThemeState>().colors;
  static final Map<String, Color> successPrimary = {
    "borderDisableColor": _color.neutral700,
    "borderActiveColor": _color.success800,
    "foregroundActiveColor": _color.success25,
    "foregroundDisableColor": _color.neutral200,
    "backgroundActiveColor": _color.success700,
    "backgroundDisableColor": _color.neutral600,
    "overlayActiveColor": _color.success900,
  };

  static final Map<String, Color> successSecondary = {
    "borderDisableColor": _color.neutral500,
    "borderActiveColor": _color.success200,
    "foregroundActiveColor": _color.success700,
    "foregroundDisableColor": _color.neutral600,
    "backgroundActiveColor": _color.success100,
    "backgroundDisableColor": _color.neutral400,
    "overlayActiveColor": _color.success300,
  };

  static final Map<String, Color> successTertiary = {
    "borderDisableColor": _color.neutral100,
    "borderActiveColor": _color.neutral100,
    "foregroundActiveColor": _color.success700,
    "foregroundDisableColor": _color.neutral500,
    "backgroundActiveColor": _color.white,
    "backgroundDisableColor": _color.white,
    "overlayActiveColor": _color.neutral200,
  };

  static final Map<String, Color> successGhost = {
    "borderDisableColor": _color.white,
    "borderActiveColor": _color.transparent,
    "foregroundActiveColor": _color.success700,
    "foregroundDisableColor": _color.neutral500,
    "backgroundActiveColor": _color.white,
    "backgroundDisableColor": _color.white,
    "overlayActiveColor": _color.neutral100,
  };
}

class NeutralDataSourceStyle {
  static AppColors get _color => bennyLocator<ThemeState>().colors;
  static final Map<String, Color> neutralPrimary = {
    "borderDisableColor": _color.neutral700,
    "borderActiveColor": _color.neutral800,
    "foregroundActiveColor": _color.neutral25,
    "foregroundDisableColor": _color.neutral200,
    "backgroundActiveColor": _color.neutral700,
    "backgroundDisableColor": _color.neutral600,
    "overlayActiveColor": _color.neutral900,
  };

  static final Map<String, Color> neutralSecondary = {
    "borderDisableColor": _color.neutral500,
    "borderActiveColor": _color.neutral200,
    "foregroundActiveColor": _color.neutral700,
    "foregroundDisableColor": _color.neutral600,
    "backgroundActiveColor": _color.neutral100,
    "backgroundDisableColor": _color.neutral400,
    "overlayActiveColor": _color.neutral300,
  };

  static final Map<String, Color> neutralTertiary = {
    "borderDisableColor": _color.neutral100,
    "borderActiveColor": _color.neutral100,
    "foregroundActiveColor": _color.neutral700,
    "foregroundDisableColor": _color.neutral500,
    "backgroundActiveColor": _color.white,
    "backgroundDisableColor": _color.white,
    "overlayActiveColor": _color.neutral200,
  };

  static final Map<String, Color> neutralGhost = {
    "borderDisableColor": _color.white,
    "borderActiveColor": _color.transparent,
    "foregroundActiveColor": _color.neutral700,
    "foregroundDisableColor": _color.neutral500,
    "backgroundActiveColor": _color.white,
    "backgroundDisableColor": _color.white,
    "overlayActiveColor": _color.neutral100,
  };
}

class ErrorDataSourceStyle {
  static AppColors get _color => bennyLocator<ThemeState>().colors;
  static final Map<String, Color> errorPrimary = {
    "borderDisableColor": _color.neutral700,
    "borderActiveColor": _color.error800,
    "foregroundActiveColor": _color.error25,
    "foregroundDisableColor": _color.neutral200,
    "backgroundActiveColor": _color.error700,
    "backgroundDisableColor": _color.neutral600,
    "overlayActiveColor": _color.error900,
  };

  static final Map<String, Color> errorSecondary = {
    "borderDisableColor": _color.neutral500,
    "borderActiveColor": _color.error200,
    "foregroundActiveColor": _color.error700,
    "foregroundDisableColor": _color.neutral600,
    "backgroundActiveColor": _color.error100,
    "backgroundDisableColor": _color.neutral400,
    "overlayActiveColor": _color.error300,
  };

  static final Map<String, Color> errorTertiary = {
    "borderDisableColor": _color.neutral100,
    "borderActiveColor": _color.neutral100,
    "foregroundActiveColor": _color.error700,
    "foregroundDisableColor": _color.neutral500,
    "backgroundActiveColor": _color.white,
    "backgroundDisableColor": _color.white,
    "overlayActiveColor": _color.neutral200,
  };

  static final Map<String, Color> errorGhost = {
    "borderDisableColor": _color.white,
    "borderActiveColor": _color.transparent,
    "foregroundActiveColor": _color.error700,
    "foregroundDisableColor": _color.neutral500,
    "backgroundActiveColor": _color.white,
    "backgroundDisableColor": _color.white,
    "overlayActiveColor": _color.neutral100,
  };
}
