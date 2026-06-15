import 'package:flutter/material.dart';
import 'package:benny_style/benny_locator.dart';
import 'package:benny_style/theme/theme_state.dart';

class BennyChoiceChip extends StatefulWidget {
  const BennyChoiceChip({
    required this.selected,
    this.label,
    this.title,
    this.titleTextStyle,
    this.titleColor,
    this.color,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.visualDensity,
    this.onSelected,
    super.key,
  });

  final Widget? label;
  final String? title;
  final TextStyle? titleTextStyle;
  final Color? titleColor;
  final bool selected;
  final WidgetStateProperty<Color?>? color;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderRadius;
  final VisualDensity? visualDensity;
  final Function(bool)? onSelected;

  @override
  State<BennyChoiceChip> createState() => _BennyChoiceChipState();
}

class _BennyChoiceChipState extends State<BennyChoiceChip> {
  final theme = bennyLocator<ThemeState>();

  bool _isEnable = false;
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();

    _isEnable = widget.onSelected != null;
    _isSelected = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(widget.borderRadius ?? 8.0),
        ),
      ),
      side: BorderSide(
        color: widget.borderColor ??
            (_isEnable
                ? (_isSelected
                    ? theme.colors.brand700
                    : theme.colors.neutral100)
                : (_isSelected
                    ? theme.colors.neutral500
                    : theme.colors.neutral400)),
      ),
      visualDensity: widget.visualDensity ??
          const VisualDensity(horizontal: 0.0, vertical: 0.0),
      showCheckmark: false,
      label: widget.label ??
          Text(
            widget.title ?? '',
            style: widget.titleTextStyle ??
                theme.textStyle.paragraphDefault.copyWith(
                    color: widget.titleColor ??
                        (_isEnable
                            ? (_isSelected
                                ? theme.colors.brand700
                                : theme.colors.neutral800)
                            : theme.colors.neutral800)),
          ),
      selected: _isSelected,
      color: widget.color ??
          WidgetStateColor.resolveWith(
            (states) {
              if (states.contains(WidgetState.selected)) {
                return _isEnable
                    ? theme.colors.brand100
                    : theme.colors.neutral400;
              } else {
                return _isEnable ? Colors.white : theme.colors.neutral300;
              }
            },
          ),
      backgroundColor: widget.backgroundColor ?? Colors.white,
      onSelected: _isEnable
          ? (bool isSelected) {
              _isSelected = isSelected;
              widget.onSelected?.call(isSelected);
              setState(() {});
            }
          : (_) {},
    );
  }
}
