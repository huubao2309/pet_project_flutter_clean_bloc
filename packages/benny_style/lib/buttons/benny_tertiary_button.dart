import 'package:flutter/material.dart';

import 'base_button_type.dart';
import 'benny_button_style.dart';
import 'benny_base_button.dart';

class BennyTertiaryButton extends StatelessWidget {
  const BennyTertiaryButton({
    super.key,
    required this.title,
    this.onPressed,
    this.isWrapContent = true,
    this.type = BaseButtonType.brand,
    this.widget,
  });

  final Widget? widget;
  final String title;
  final VoidCallback? onPressed;
  final bool isWrapContent;
  final BaseButtonType type;

  @override
  Widget build(BuildContext context) {
    final BennyButtonStyle buttonStyles = BennyButtonStyle(type: type);

    return BennyBaseButton(
      onPressed: onPressed,
      isWrapContain: isWrapContent,
      style: buttonStyles.tertiary(),
      child: widget ??
          Text(
            title,
            textAlign: TextAlign.center,
          ),
    );
  }
}
