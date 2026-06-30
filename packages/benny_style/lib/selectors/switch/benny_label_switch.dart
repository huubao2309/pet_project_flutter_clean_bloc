import 'package:flutter/material.dart';
import 'package:benny_style/benny_locator.dart';
import 'package:benny_style/selectors/switch/benny_switch.dart';
import 'package:benny_style/theme/theme_state.dart';

class BennyLabelSwitch extends StatefulWidget {
  const BennyLabelSwitch({
    super.key,
    this.value = false,
    this.enable = true,
    this.width,
    this.height,
    this.prefixTitle,
    this.prefixPadding,
    this.prefixTextStyle,
    this.prefixColor,
    this.suffixTitle,
    this.suffixPadding,
    this.suffixTextStyle,
    this.suffixColor,
    this.scale = 1.0,
    this.onChange,
  });

  final double? width;
  final double? height;
  final String? prefixTitle;
  final EdgeInsetsGeometry? prefixPadding;
  final TextStyle? prefixTextStyle;
  final Color? prefixColor;
  final String? suffixTitle;
  final EdgeInsetsGeometry? suffixPadding;
  final TextStyle? suffixTextStyle;
  final Color? suffixColor;
  final bool value;
  final bool enable;
  final double scale;
  final Function(bool)? onChange;

  @override
  State<BennyLabelSwitch> createState() => _BennyLabelSwitchState();
}

class _BennyLabelSwitchState extends State<BennyLabelSwitch> {
  final theme = bennyLocator<ThemeState>();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        widget.prefixTitle != null
            ? Flexible(
                child: Padding(
                  padding: widget.prefixPadding ??
                      EdgeInsets.only(right: theme.spacing.spacing4),
                  child: Text(
                    widget.prefixTitle!,
                    style: widget.prefixTextStyle ??
                        theme.textStyle.paragraphDefault.copyWith(
                          color: theme.colors.neutral800,
                        ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
        BennySwitch(
          width: widget.width,
          height: widget.height,
          value: widget.value,
          enable: widget.enable,
          onChange: widget.onChange,
        ),
        widget.suffixTitle != null
            ? Flexible(
                child: Padding(
                  padding: widget.suffixPadding ??
                      EdgeInsets.only(left: theme.spacing.spacing4),
                  child: Text(
                    widget.suffixTitle!,
                    style: widget.suffixTextStyle ??
                        theme.textStyle.paragraphDefault.copyWith(
                          color: theme.colors.neutral800,
                        ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
