import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:benny_style/buttons/base_button_type.dart';
import 'package:benny_style/buttons/base_button_type_style.dart';
import 'package:benny_style/buttons/benny_button_style.dart';

import 'base_icon_button.dart';

class BennyGhostIconButton extends StatelessWidget {
  const BennyGhostIconButton({
    super.key,
    this.onPressed,
    this.type = BaseButtonType.brand,
    required this.svgIconName,
    this.size,
    this.padding,
    this.iconColor,
  });

  final String svgIconName;
  final VoidCallback? onPressed;
  final BaseButtonType type;
  final double? size;
  final EdgeInsets? padding;

  /// Optional override for the (enabled) icon colour. When null the colour is
  /// derived from [type]. Callers pass a theme token (e.g. a brightness-aware
  /// `colors.*`) so the icon can flip with Light/Dark mode.
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final BennyButtonStyle buttonStyle =
        BennyButtonStyle(type: type, isIconButton: true);

    final BaseButtonTypeStyle colorStyle = _getColor();
    final Color resolvedIconColor = (onPressed == null)
        ? colorStyle.ghost.foregroundDisableColor
        : (iconColor ?? colorStyle.ghost.foregroundActiveColor);
    return BaseIconButton(
      onPressed: onPressed,
      size: size,
      style: buttonStyle.ghost(),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(2.0),
        child: SvgPicture.asset(
          svgIconName,
          colorFilter: ColorFilter.mode(resolvedIconColor, BlendMode.srcIn),
        ),
      ),
    );
  }

  _getColor() {
    switch (type) {
      case BaseButtonType.brand:
        return type.brandColor;
      case BaseButtonType.success:
        return type.successColor;
      case BaseButtonType.neutral:
        return type.neutralColor;
      case BaseButtonType.error:
        return type.errorColor;
    }
  }
}
