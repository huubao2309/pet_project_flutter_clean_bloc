import "package:flutter/material.dart";
import "package:benny_style/benny_locator.dart";
import "package:benny_style/theme/theme_state.dart";

class BennyCard extends StatelessWidget {
  final Widget? child;
  final double? borderRadius;
  final BorderRadiusGeometry? borderRadiusGeometry;
  final Color? backgroundColor;
  final String? backgroundImage;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? borderColor;
  final double borderWidth;
  final bool isExpanded;
  final Clip clipBehavior;
  final Gradient? gradient;
  final List<BoxShadow>? boxShadow;

  const BennyCard({
    super.key,
    this.child,
    this.borderRadius,
    this.borderRadiusGeometry,
    this.backgroundColor,
    this.backgroundImage,
    this.padding,
    this.margin,
    this.borderColor,
    this.borderWidth = 1,
    this.isExpanded = false,
    this.clipBehavior = Clip.none,
    this.gradient,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final theme = bennyLocator<ThemeState>();
    final radius = borderRadius ?? theme.borderRadius.borderRadius8;
    bool hasBgImage = (backgroundImage ?? "").isNotEmpty;
    bool hasBorder = borderColor != null;
    return Container(
      width: isExpanded ? double.infinity : null,
      clipBehavior: clipBehavior,
      decoration: BoxDecoration(
        borderRadius:
            borderRadiusGeometry ?? BorderRadius.all(Radius.circular(radius)),
        border: Border.all(
          color: borderColor ?? theme.colors.generalBorder,
          width: hasBorder ? borderWidth : 0,
        ),
        gradient: gradient,
        color: backgroundColor ?? theme.colors.white,
        boxShadow: boxShadow,
        image: hasBgImage
            ? DecorationImage(
                image: AssetImage(backgroundImage!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      padding: padding ?? EdgeInsets.all(theme.spacing.spacing16),
      margin: margin ?? EdgeInsets.all(theme.spacing.spacing16),
      child: child,
    );
  }
}
