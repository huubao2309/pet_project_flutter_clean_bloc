import 'package:flutter/material.dart';
import 'package:benny_style/buttons/benny_button_style.dart';

import 'base_button_type.dart';
import 'benny_base_button.dart';

class BennyGhostButton extends StatelessWidget {
  const BennyGhostButton({
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
    final BennyButtonStyle buttonStyle = BennyButtonStyle(type: type);

    return BennyBaseButton(
      onPressed: onPressed,
      isWrapContain: isWrapContent,
      style: buttonStyle.ghost(),
      child: widget ??
          Text(
            title,
            textAlign: TextAlign.center,
          ),
    );
  }
}
