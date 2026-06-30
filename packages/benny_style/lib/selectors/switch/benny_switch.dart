import 'package:flutter/material.dart';
import 'package:benny_style/benny_locator.dart';
import 'package:benny_style/theme/theme_state.dart';
import 'wrap_switch_flutter.dart' as switch_widget;

class BennySwitch extends StatefulWidget {
  const BennySwitch({
    super.key,
    this.value = false,
    this.enable = true,
    this.width,
    this.height,
    this.trackOutlineWidth,
    this.thumbEnableActiveColor,
    this.thumbEnableInActiveColor,
    this.thumbDisableActiveColor,
    this.thumbDisableInActiveColor,
    this.trackEnableActiveColor,
    this.trackEnableInActiveColor,
    this.trackDisableActiveColor,
    this.trackDisableInActiveColor,
    this.trackOutlineEnableActiveColor,
    this.trackOutlineEnableInActiveColor,
    this.trackOutlineDisableActiveColor,
    this.trackOutlineDisableInActiveColor,
    this.onChange,
  });

  final bool value;
  final bool enable;
  final double? width;
  final double? height;
  final WidgetStateProperty<double?>? trackOutlineWidth;
  final Color? thumbEnableActiveColor;
  final Color? thumbEnableInActiveColor;
  final Color? thumbDisableActiveColor;
  final Color? thumbDisableInActiveColor;
  final Color? trackEnableActiveColor;
  final Color? trackEnableInActiveColor;
  final Color? trackDisableActiveColor;
  final Color? trackDisableInActiveColor;
  final Color? trackOutlineEnableActiveColor;
  final Color? trackOutlineEnableInActiveColor;
  final Color? trackOutlineDisableActiveColor;
  final Color? trackOutlineDisableInActiveColor;
  final Function(bool)? onChange;

  @override
  State<BennySwitch> createState() => _BennySwitchState();
}

class _BennySwitchState extends State<BennySwitch> {
  bool _value = false;
  final colors = bennyLocator<ThemeState>().colors;

  @override
  void initState() {
    _value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !widget.enable,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: FittedBox(
          fit: BoxFit.fill,
          child: switch_widget.Switch(
            padding: EdgeInsets.zero,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            value: _value,
            thumbColor: WidgetStateColor.resolveWith(
              (states) {
                if (states.contains(WidgetState.selected)) {
                  return widget.enable
                      ? (widget.thumbEnableActiveColor ?? Colors.white)
                      : (widget.thumbDisableActiveColor ?? colors.neutral600);
                } else {
                  return widget.enable
                      ? (widget.thumbEnableInActiveColor ?? colors.neutral800)
                      : (widget.thumbDisableInActiveColor ?? colors.neutral500);
                }
              },
            ),
            trackColor: WidgetStateColor.resolveWith(
              (states) {
                if (states.contains(WidgetState.selected)) {
                  return widget.enable
                      ? (widget.trackEnableActiveColor ?? colors.brand700)
                      : (widget.trackDisableActiveColor ?? colors.neutral500);
                } else {
                  return widget.enable
                      ? (widget.trackEnableInActiveColor ?? Colors.white)
                      : (widget.trackDisableInActiveColor ?? colors.neutral400);
                }
              },
            ),
            trackOutlineColor: WidgetStateColor.resolveWith(
              (states) {
                if (states.contains(WidgetState.selected)) {
                  return widget.enable
                      ? (widget.trackOutlineEnableActiveColor ??
                          colors.brand800)
                      : (widget.trackOutlineDisableActiveColor ??
                          colors.neutral300);
                } else {
                  return widget.enable
                      ? (widget.trackOutlineEnableInActiveColor ??
                          colors.neutral100)
                      : (widget.trackOutlineDisableInActiveColor ??
                          colors.neutral300);
                }
              },
            ),
            trackOutlineWidth: widget.trackOutlineWidth ??
                WidgetStateProperty.resolveWith<double?>(
                    (Set<WidgetState> states) {
                  return 1.0;
                }),
            onChanged: (bool value) {
              setState(() {
                _value = value;
              });
              widget.onChange?.call(value);
            },
          ),
        ),
      ),
    );
  }
}
