import 'package:flutter/material.dart';

class BennyBaseButton extends StatelessWidget {
  const BennyBaseButton(
      {super.key,
      required this.child,
      this.style,
      this.onPressed,
      this.isWrapContain = true});

  final VoidCallback? onPressed;
  final Widget child;
  final ButtonStyle? style;
  final bool isWrapContain;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isWrapContain ? null : double.infinity,
      child: TextButton(
        onPressed: onPressed,
        style: style,
        child: child,
      ),
    );
  }
}
