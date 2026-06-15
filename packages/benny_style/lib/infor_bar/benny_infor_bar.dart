import 'package:flutter/material.dart';
import 'package:benny_style/infor_bar/base_timed_progress_bar.dart';

import 'info_bar_type.dart';

class BennyInfoBar extends StatelessWidget {
  final BaseInfoBarType type;
  final int? duration;
  final double? height;
  final double beginValue;
  final double endValue;
  final VoidCallback? onComplete;
  final bool? autoStart;

  const BennyInfoBar(
      {super.key,
      required this.type,
      this.duration,
      this.height,
      this.beginValue = 0.5,
      this.endValue = 0,
      this.onComplete,
      this.autoStart});

  @override
  Widget build(BuildContext context) {
    return BaseTimedProgressBar(
      backgroundColor: type.backgroundColor,
      progressColor: type.progressColor,
      beginValue: beginValue,
      endValue: endValue,
      height: height ?? type.height,
      duration: duration ?? type.duration,
      onComplete: onComplete,
      autoStart: autoStart ?? false,
    );
  }
}
