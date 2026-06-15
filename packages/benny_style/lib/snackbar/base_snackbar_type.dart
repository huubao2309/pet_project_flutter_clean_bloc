import 'package:flutter/material.dart';
import 'package:benny_style/benny_locator.dart';
import 'package:benny_style/generated/assets.gen.dart';
import 'package:benny_style/infor_bar/info_bar_type.dart';
import 'package:benny_style/theme/app_colors.dart';
import 'package:benny_style/theme/theme_state.dart';

enum BaseSnackBarType {
  info,
  success,
  error,
  warning,
}

extension BaseSnackBarTypeStyle on BaseSnackBarType {
  Color get iconColor {
    switch (this) {
      case BaseSnackBarType.info:
        return _color.brand700;
      case BaseSnackBarType.success:
        return _color.success700;
      case BaseSnackBarType.warning:
        return _color.warning700;
      case BaseSnackBarType.error:
        return _color.error700;
    }
  }

  TextStyle get messageTextStyle => _theme.textStyle.paragraphDefault.copyWith(
        color: _color.neutral800,
      );

  TextStyle get undoTextStyle => _theme.textStyle.paragraphLabelLink.copyWith(
        color: _color.neutral800,
      );

  String get iconName {
    switch (this) {
      case BaseSnackBarType.success:
        return Assets.svg.icCheck.keyName;
      case BaseSnackBarType.info:
        return Assets.svg.icInfo.keyName;
      case BaseSnackBarType.warning:
        return Assets.svg.icError.keyName;
      case BaseSnackBarType.error:
        return Assets.svg.icTrash.keyName;
    }
  }

  BaseInfoBarType get infoType {
    switch (this) {
      case BaseSnackBarType.success:
        return BaseInfoBarType.success;
      case BaseSnackBarType.info:
        return BaseInfoBarType.info;
      case BaseSnackBarType.warning:
        return BaseInfoBarType.warning;
      case BaseSnackBarType.error:
        return BaseInfoBarType.error;
    }
  }

  Color get borderColor => _color.generalBorder;
  AppColors get _color => _theme.colors;
  ThemeState get _theme => bennyLocator<ThemeState>();
}
