import 'package:flutter/material.dart';
import 'package:benny_style/benny_locator.dart';
import 'package:benny_style/generated/assets.gen.dart';
import 'package:benny_style/theme/app_colors.dart';
import 'package:benny_style/theme/theme_state.dart';

enum BaseMessageType { info, success, warning, error }

extension BaseMessageTypeStyle on BaseMessageType {
  Color get headerColor {
    switch (this) {
      case BaseMessageType.info:
        return _color.brand500;
      case BaseMessageType.success:
        return _color.success500;
      case BaseMessageType.warning:
        return _color.warning500;
      case BaseMessageType.error:
        return _color.error500;
    }
  }

  Color get icColor {
    switch (this) {
      case BaseMessageType.info:
        return _color.brand700;
      case BaseMessageType.success:
        return _color.success700;
      case BaseMessageType.warning:
        return _color.warning700;
      case BaseMessageType.error:
        return _color.error700;
    }
  }

  TextStyle get titleTextStyle => _theme.textStyle.heading;
  TextStyle get messageTextStyle => _theme.textStyle.paragraphLabel;
  String get iconName {
    switch (this) {
      case BaseMessageType.success:
        return Assets.svg.icCheck.keyName;
      case BaseMessageType.info:
        return Assets.svg.icInfo.keyName;
      case BaseMessageType.warning:
        return Assets.svg.icError.keyName;
      case BaseMessageType.error:
        return Assets.svg.icTrash.keyName;
    }
  }

  Color get borderColor => _color.generalBorder;

  Color get titleColor => _color.neutral800;

  Color get messageColor => _color.neutral600;

  ThemeState get _theme => bennyLocator<ThemeState>();
  AppColors get _color => _theme.colors;
}
