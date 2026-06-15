import 'package:flutter/material.dart';
import 'package:benny_style/benny_locator.dart';
import 'package:benny_style/theme/app_colors.dart';
import 'package:benny_style/theme/theme_state.dart';

enum BaseInfoBarType { warning, info, success, error }

extension InfoBarTypeStyle on BaseInfoBarType {
  double get height => 4;
  int get duration => 5;

  Color get progressColor {
    switch (this) {
      case BaseInfoBarType.info:
        return _color.brand700;
      case BaseInfoBarType.warning:
        return _color.warning700;
      case BaseInfoBarType.success:
        return _color.success700;
      case BaseInfoBarType.error:
        return _color.error700;
    }
  }

  Color get backgroundColor {
    switch (this) {
      case BaseInfoBarType.info:
        return _color.brand500;
      case BaseInfoBarType.warning:
        return _color.warning500;
      case BaseInfoBarType.success:
        return _color.success500;
      case BaseInfoBarType.error:
        return _color.error500;
    }
  }

  AppColors get _color => bennyLocator<ThemeState>().colors;
}
