import 'package:flutter/material.dart';

class BennyCircleProgress extends StatefulWidget {
  final double startValue;
  final double endValue;
  final double size;
  final double strokeWidth;
  final Color backgroundColor;
  final Color progressColor;
  final Duration duration;
  final Curve curve;
  final bool showLabel;
  final bool infiniteAnimation;
  final bool resetAnimation;

  const BennyCircleProgress({
    super.key,
    required this.startValue,
    required this.endValue,
    this.size = 16,
    this.strokeWidth = 2,
    this.backgroundColor = const Color(0xFFEEEEEE),
    this.progressColor = Colors.blue,
    this.duration = const Duration(milliseconds: 1500),
    this.curve = Curves.easeInOut,
    this.showLabel = true,
    this.infiniteAnimation = false,
    this.resetAnimation = false,
  });

  @override
  State<BennyCircleProgress> createState() => _CustomCircularProgressState();
}

class _CustomCircularProgressState extends State<BennyCircleProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _setupAnimation();
    _startAnimation();
  }

  void _setupAnimation() {
    if (widget.infiniteAnimation) {
      _animation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ));
    } else {
      _animation = Tween<double>(
        begin: widget.startValue,
        end: widget.endValue,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ));
    }
  }

  void _startAnimation() {
    if (widget.infiniteAnimation) {
      _controller.repeat();
    } else if (widget.resetAnimation) {
      _controller.repeat(reverse: true);
    } else {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(BennyCircleProgress oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle changes in animation mode or reset mode
    if (oldWidget.infiniteAnimation != widget.infiniteAnimation ||
        oldWidget.resetAnimation != widget.resetAnimation) {
      _controller.stop();
      _setupAnimation();
      _startAnimation();
      return;
    }

    // Handle value changes for normal animation
    if (!widget.infiniteAnimation &&
        !widget.resetAnimation &&
        (oldWidget.endValue != widget.endValue ||
            oldWidget.startValue != widget.startValue)) {
      _animation = Tween<double>(
        begin: widget.startValue,
        end: widget.endValue,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ));
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: widget.infiniteAnimation ? null : _animation.value,
                backgroundColor: widget.backgroundColor,
                color: widget.progressColor,
                strokeWidth: widget.strokeWidth,
              ),
              if (widget.showLabel &&
                  !widget.infiniteAnimation &&
                  !widget.resetAnimation)
                Text(
                  '${(_animation.value * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: widget.size * 0.2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
