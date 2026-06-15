import 'package:flutter/material.dart';

class BaseIconButton extends StatelessWidget {
  const BaseIconButton(
      {super.key,
      required this.child,
      this.style,
      this.onPressed,
      this.size = 36});

  final VoidCallback? onPressed;
  final Widget child;
  final ButtonStyle? style;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: IconButton(
        onPressed: onPressed,
        icon: child,
        style: style,
      ),
    );
  }
}
