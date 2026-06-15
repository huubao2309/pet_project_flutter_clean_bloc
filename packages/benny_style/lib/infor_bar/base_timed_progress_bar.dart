import 'package:flutter/material.dart';

class BaseTimedProgressBar extends StatefulWidget {
  final Color backgroundColor;
  final Color progressColor;
  final double height;
  final VoidCallback? onComplete;
  final bool autoStart;
  final double beginValue;
  final double endValue;
  final int duration;

  const BaseTimedProgressBar({
    super.key,
    required this.backgroundColor,
    required this.progressColor,
    this.height = 4.0,
    this.onComplete,
    this.autoStart = false,
    this.beginValue = 0.5,
    this.endValue = 0,
    this.duration = 5,
  });

  @override
  State<BaseTimedProgressBar> createState() => _BaseTimedProgressBarState();
}

class _BaseTimedProgressBarState extends State<BaseTimedProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: widget.duration),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: widget.beginValue,
      end: widget.endValue,
    ).animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });

    if (widget.autoStart) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void restart() {
    _controller.reset();
    _controller.forward();
  }

  void pause() {
    _controller.stop();
  }

  void resume() {
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          height: widget.height,
          child: LinearProgressIndicator(
            value: _animation.value,
            backgroundColor: widget.backgroundColor,
            valueColor: AlwaysStoppedAnimation<Color>(widget.progressColor),
          ),
        );
      },
    );
  }
}
