import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:benny_style/buttons/base_button_type.dart';
import 'package:benny_style/buttons/base_button_type_style.dart';
import 'package:benny_style/buttons/benny_button_style.dart';

import 'base_icon_button.dart';

class BennyTertiaryIconButton extends StatelessWidget {
  const BennyTertiaryIconButton({
    super.key,
    this.onPressed,
    this.type = BaseButtonType.brand,
    required this.svgIconName,
    this.size,
    this.padding,
  });

  final String svgIconName;
  final VoidCallback? onPressed;
  final BaseButtonType type;
  final double? size;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final BennyButtonStyle buttonStyle =
        BennyButtonStyle(type: type, isIconButton: true);
    final BaseButtonTypeStyle colorStyle = _getColor();
    Color iconColor = (onPressed == null)
        ? colorStyle.tertiary.foregroundDisableColor
        : colorStyle.tertiary.foregroundActiveColor;
    return BaseIconButton(
      onPressed: onPressed,
      size: size,
      style: buttonStyle.tertiary(),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(2.0),
        child: SvgPicture.asset(
          svgIconName,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
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
