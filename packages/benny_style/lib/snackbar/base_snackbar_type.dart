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
  /// Icon + message tone (the design's `-d` colour). Per the design system the
  /// icon and text share the same tone as the type.
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

  /// Light tinted card background (the design's `-bg` colour).
  Color get backgroundColor {
    switch (this) {
      case BaseSnackBarType.info:
        return _color.brand50;
      case BaseSnackBarType.success:
        return _color.success50;
      case BaseSnackBarType.warning:
        return _color.warning50;
      case BaseSnackBarType.error:
        return _color.error50;
    }
  }

  // Message text shares the icon's tone (design: "icon & chữ cùng tông").
  TextStyle get messageTextStyle => _theme.textStyle.paragraphDefault.copyWith(
        color: iconColor,
      );

  TextStyle get undoTextStyle => _theme.textStyle.paragraphLabelLink.copyWith(
        color: iconColor,
      );

  String get iconName {
    switch (this) {
      case BaseSnackBarType.success:
        return Assets.svg.icCheck.keyName;
      case BaseSnackBarType.info:
        return Assets.svg.icInfo.keyName;
      case BaseSnackBarType.warning:
        return Assets.svg.icError.keyName;
      // Alert icon (design: alert-circle), not the trash icon.
      case BaseSnackBarType.error:
        return Assets.svg.icError.keyName;
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

  /// Card border in the type's tone (the design's per-type border tint).
  Color get borderColor {
    switch (this) {
      case BaseSnackBarType.info:
        return _color.brand200;
      case BaseSnackBarType.success:
        return _color.success200;
      case BaseSnackBarType.warning:
        return _color.warning300;
      case BaseSnackBarType.error:
        return _color.error300;
    }
  }

  AppColors get _color => _theme.colors;
  ThemeState get _theme => bennyLocator<ThemeState>();
}
