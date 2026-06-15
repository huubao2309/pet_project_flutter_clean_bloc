import "package:flutter/material.dart";
import "package:benny_style/theme/app_colors.dart";
import "package:benny_style/theme/theme_border_radius.dart";
import "package:benny_style/theme/theme_spacing.dart";
import "package:benny_style/theme/theme_text_style.dart";

abstract class ThemeState {
  late final ThemeData theme;
  final double devicePixelRatio;

  late final ThemeSpacing _themeSpacing;
  late final ThemeTextStyle _themeTextStyle;
  late final AppColors _colors;
  late final ThemeBorderRadius _borderRadius;

  ThemeTextStyle get textStyle => _themeTextStyle;
  ThemeSpacing get spacing => _themeSpacing;
  AppColors get colors => _colors;
  ThemeBorderRadius get borderRadius => _borderRadius;

  ThemeState({required this.devicePixelRatio}) {
    theme = _themeConfig;
    _themeTextStyle = ThemeTextStyle();
    _themeSpacing = ThemeSpacing();
    _colors = AppColors();
    _borderRadius = ThemeBorderRadius();
  }

  get _themeConfig => ThemeData(
        inputDecorationTheme: const InputDecorationTheme(errorMaxLines: 100),
      );
}

class AppTheme extends ThemeState {
  AppTheme()
      : super(
            devicePixelRatio: WidgetsBinding.instance.platformDispatcher.views
                .first.physicalSize.aspectRatio);
}
