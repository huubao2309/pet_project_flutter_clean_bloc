import 'package:flutter/material.dart';
import 'package:benny_style/benny_locator.dart';
import 'package:benny_style/theme/theme_state.dart';

class BennyBaseTag extends StatelessWidget {
  const BennyBaseTag({
    super.key,
    required this.title,
    this.style,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.colorText,
    this.padding,
  });

  final String title;
  final TextStyle? style;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final double? borderRadius;
  final Color? colorText;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = bennyLocator<ThemeState>();
    return Container(
      padding: padding ??
          EdgeInsets.symmetric(
              horizontal: theme.spacing.spacing8,
              vertical: theme.spacing.spacing4),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: (borderColor == null)
            ? null
            : Border.all(
                color: borderColor!,
                width: borderWidth ?? 1,
              ),
        borderRadius:
            BorderRadius.circular(borderRadius ?? theme.spacing.spacing4),
      ),
      child: Text(
        title,
        style:
            style ?? theme.textStyle.captionDefault.copyWith(color: colorText),
      ),
    );
  }
}
