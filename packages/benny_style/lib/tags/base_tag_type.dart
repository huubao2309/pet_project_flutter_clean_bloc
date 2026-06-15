import 'package:benny_style/benny_locator.dart';
import 'package:benny_style/theme/app_colors.dart';
import 'package:benny_style/theme/theme_state.dart';

import 'base_tag_item_style.dart';
import 'base_tag_style.dart';

enum BaseTagType {
  brand,
  dark,
  success,
  warning,
  error,
}

extension BaseTagTypeStyle on BaseTagType {
  ThemeState get _style => bennyLocator<ThemeState>();
  AppColors get _color => _style.colors;
  BaseTagStyle get saturated {
    switch (this) {
      case BaseTagType.brand:
        return BaseTagStyle(
            unMono: BaseTagItemStyle(
                color: _color.brand700,
                textStyle: _style.textStyle.captionDefault,
                textColor: _color.brand25),
            mono: BaseTagItemStyle(
                color: _color.brand700,
                textStyle: _style.textStyle.captionMono,
                textColor: _color.brand25));
      case BaseTagType.dark:
        return BaseTagStyle(
            unMono: BaseTagItemStyle(
                color: _color.neutral700,
                textStyle: _style.textStyle.captionDefault,
                textColor: _color.neutral25),
            mono: BaseTagItemStyle(
                color: _color.neutral700,
                textStyle: _style.textStyle.captionMono,
                textColor: _color.neutral25));
      case BaseTagType.success:
        return BaseTagStyle(
            unMono: BaseTagItemStyle(
                color: _color.success700,
                textStyle: _style.textStyle.captionDefault,
                textColor: _color.success25),
            mono: BaseTagItemStyle(
                color: _color.success700,
                textStyle: _style.textStyle.captionMono,
                textColor: _color.success25));
      case BaseTagType.warning:
        return BaseTagStyle(
            unMono: BaseTagItemStyle(
                color: _color.warning700,
                textStyle: _style.textStyle.captionDefault,
                textColor: _color.warning25),
            mono: BaseTagItemStyle(
                color: _color.warning700,
                textStyle: _style.textStyle.captionMono,
                textColor: _color.warning25));
      case BaseTagType.error:
        return BaseTagStyle(
            unMono: BaseTagItemStyle(
                color: _color.error700,
                textStyle: _style.textStyle.captionDefault,
                textColor: _color.error25),
            mono: BaseTagItemStyle(
                color: _color.error700,
                textStyle: _style.textStyle.captionMono,
                textColor: _color.error25));
    }
  }

  BaseTagStyle get unSaturated {
    switch (this) {
      case BaseTagType.brand:
        return BaseTagStyle(
            unMono: BaseTagItemStyle(
                color: _color.brand100,
                textStyle: _style.textStyle.captionDefault,
                textColor: _color.brand700),
            mono: BaseTagItemStyle(
                color: _color.brand100,
                textStyle: _style.textStyle.captionMono,
                textColor: _color.brand700));
      case BaseTagType.dark:
        return BaseTagStyle(
            unMono: BaseTagItemStyle(
                color: _color.neutral100,
                textStyle: _style.textStyle.captionDefault,
                textColor: _color.neutral700),
            mono: BaseTagItemStyle(
                color: _color.neutral100,
                textStyle: _style.textStyle.captionMono,
                textColor: _color.neutral700));
      case BaseTagType.success:
        return BaseTagStyle(
            unMono: BaseTagItemStyle(
                color: _color.success100,
                textStyle: _style.textStyle.captionDefault,
                textColor: _color.success700),
            mono: BaseTagItemStyle(
                color: _color.success100,
                textStyle: _style.textStyle.captionMono,
                textColor: _color.success700));
      case BaseTagType.warning:
        return BaseTagStyle(
            unMono: BaseTagItemStyle(
                color: _color.warning100,
                textStyle: _style.textStyle.captionDefault,
                textColor: _color.warning700),
            mono: BaseTagItemStyle(
                color: _color.warning100,
                textStyle: _style.textStyle.captionMono,
                textColor: _color.warning700));
      case BaseTagType.error:
        return BaseTagStyle(
            unMono: BaseTagItemStyle(
                color: _color.error100,
                textStyle: _style.textStyle.captionDefault,
                textColor: _color.error700),
            mono: BaseTagItemStyle(
                color: _color.error100,
                textStyle: _style.textStyle.captionMono,
                textColor: _color.error700));
    }
  }
}
