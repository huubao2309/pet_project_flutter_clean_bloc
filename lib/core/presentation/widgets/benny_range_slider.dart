import 'package:benny_style/theme/theme_state.dart';
import 'package:flutter/material.dart';

import '../../di/injection.dart';
import 'custom_range_thumb_shape.dart';

/// Themed range slider. De-GetX'd port of the source `SNDQRangeSlider`
/// (theme resolved via the registered [ThemeState]).
class BennyRangeSlider extends StatefulWidget {
  const BennyRangeSlider({
    required this.values,
    this.trackHeight = 4,
    this.max = 1,
    this.min = 0,
    this.divisions,
    this.onChanged,
    this.thumbSize,
    this.activeThumbColor,
    this.inactiveThumbColor,
    this.borderThumbColor,
    this.middleThumbColor,
    this.middleThumbSize,
    this.thumbRadius,
    this.inactiveTickMarkColor,
    this.valueIndicatorColor,
    this.valueIndicatorTextStyle,
    super.key,
  });

  final RangeValues values;
  final double max;
  final double min;
  final ValueChanged<RangeValues>? onChanged;
  final Size? thumbSize;
  final Color? activeThumbColor;
  final Color? inactiveThumbColor;
  final Color? borderThumbColor;
  final Color? middleThumbColor;
  final double? middleThumbSize;
  final double? thumbRadius;
  final int? divisions;
  final double trackHeight;
  final Color? inactiveTickMarkColor;
  final Color? valueIndicatorColor;
  final TextStyle? valueIndicatorTextStyle;

  @override
  State<BennyRangeSlider> createState() => _BennyRangeSliderState();
}

class _BennyRangeSliderState extends State<BennyRangeSlider> {
  final ThemeState _theme = getIt<ThemeState>();

  late final bool _enable = widget.onChanged != null;
  late RangeValues _currentRangeValues = widget.values;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: widget.trackHeight,
        thumbColor: widget.activeThumbColor ?? _theme.colors.brand500,
        activeTrackColor: widget.activeThumbColor ?? _theme.colors.brand500,
        inactiveTrackColor:
            widget.inactiveThumbColor ?? _theme.colors.neutral200,
        activeTickMarkColor: widget.inactiveThumbColor ?? Colors.transparent,
        inactiveTickMarkColor:
            widget.inactiveTickMarkColor ?? Colors.transparent,
        rangeThumbShape: CustomRangeThumbShape(
          thumbRadius: widget.thumbRadius ?? _theme.spacing.spacing16,
          fillColor: widget.activeThumbColor ?? _theme.colors.brand500,
          borderColor: widget.borderThumbColor ?? _theme.colors.neutral300,
          middleColor: widget.middleThumbColor,
          padding: widget.middleThumbSize ?? 5,
        ),
        valueIndicatorColor:
            widget.valueIndicatorColor ?? _theme.colors.neutral900,
        valueIndicatorTextStyle: widget.valueIndicatorTextStyle ??
            TextStyle(color: _theme.colors.white),
      ),
      child: RangeSlider(
        values: _currentRangeValues,
        min: widget.min,
        max: widget.max,
        overlayColor: WidgetStateColor.resolveWith((_) => Colors.transparent),
        labels: RangeLabels(
          _currentRangeValues.start.round().toString(),
          _currentRangeValues.end.round().toString(),
        ),
        divisions: widget.divisions ?? 10,
        onChanged: _enable
            ? (newValues) {
                setState(() => _currentRangeValues = newValues);
                widget.onChanged?.call(newValues);
              }
            : null,
      ),
    );
  }
}
