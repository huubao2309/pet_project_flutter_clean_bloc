import 'dart:math';

import 'package:flutter/material.dart';
import 'package:benny_style/benny_locator.dart';
import 'package:benny_style/theme/theme_state.dart';

class BennySpinner extends StatefulWidget {
  final double size;
  final double strokeWidth;
  final Duration duration;
  final List<Color>? colors;

  const BennySpinner({
    super.key,
    this.size = 16.0,
    this.strokeWidth = 2.0,
    this.duration = const Duration(milliseconds: 1500),
    this.colors,
  });

  @override
  State<BennySpinner> createState() => _BennySpinnerState();
}

class _BennySpinnerState extends State<BennySpinner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Color> _colors;
  final themeColors = bennyLocator<ThemeState>().colors;
  @override
  void initState() {
    _colors = widget.colors ?? [themeColors.brand25, themeColors.brand700];
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.size,
      width: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: SpinnerPainter(
              colors: _colors,
              progress: _controller.value,
              strokeWidth: widget.strokeWidth,
            ),
          );
        },
      ),
    );
  }
}

class SpinnerPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final List<Color> colors;

  SpinnerPainter({
    required this.progress,
    required this.strokeWidth,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Create gradient that fades from blue to transparent
    final gradient = SweepGradient(
      colors: colors,
      stops: const [0.0, 0.9],
      startAngle: 0,
      endAngle: pi * 2,
      transform: GradientRotation(2 * pi * progress - pi / 2),
    );

    final paint = Paint()
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..shader = gradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      );

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(SpinnerPainter oldDelegate) =>
      progress != oldDelegate.progress ||
      strokeWidth != oldDelegate.strokeWidth;
}
