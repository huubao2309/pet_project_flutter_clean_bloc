// ignore_for_file: always_put_required_named_parameters_first
// The paint() override must match RangeSliderThumbShape's parameter order.
import 'package:flutter/material.dart';

class CustomRangeThumbShape extends RangeSliderThumbShape {
  final double thumbRadius;
  final Color? borderColor;
  final Color fillColor;
  final Color? middleColor;
  final int borderWidth;
  final double padding;

  const CustomRangeThumbShape({
    required this.thumbRadius,
    required this.fillColor,
    this.middleColor,
    this.borderColor,
    this.padding = 4,
    this.borderWidth = 1,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(thumbRadius * 2, thumbRadius * 2);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool? isDiscrete,
    bool? isEnabled,
    bool? isOnTop,
    TextDirection? textDirection,
    required SliderThemeData sliderTheme,
    Thumb? thumb,
    bool? isPressed,
  }) {
    final Canvas canvas = context.canvas;

    // Outer circle (border)
    final Paint borderPaint = Paint()
      ..color = borderColor ?? Colors.transparent
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, thumbRadius, borderPaint);

    // Middle circle
    final Paint middlePaint = Paint()
      ..color = middleColor ?? Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, thumbRadius - borderWidth, middlePaint);

    // Inner circle (fill)
    final Paint fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, thumbRadius - padding - borderWidth, fillPaint);
  }
}
