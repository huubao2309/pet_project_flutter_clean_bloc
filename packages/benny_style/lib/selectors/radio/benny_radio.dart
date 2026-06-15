import 'package:flutter/material.dart';
import 'package:benny_style/benny_locator.dart';
import 'package:benny_style/theme/theme_state.dart';

class BennyRadio<T> extends StatefulWidget {
  final bool isSelected;
  final T value;
  final void Function(T)? onChange;
  final bool enable;
  final String? title;
  final Color? backgroundColor;
  final Color? centerColorSelected;
  final Color? centerColorUnSelected;
  final Color? borderColorSelected;
  final Color? borderColorUnSelected;
  final Color? outlineColorSelected;
  final Color? outlineColorUnSelected;
  final TextStyle? titleTextStyle;
  final Color? titleColor;
  final double? spacing;
  final double? borderWidth;
  final double? size;

  const BennyRadio({
    this.title,
    required this.value,
    super.key,
    this.enable = true,
    this.isSelected = false,
    this.onChange,
    this.backgroundColor,
    this.centerColorSelected,
    this.centerColorUnSelected,
    this.borderColorSelected,
    this.borderColorUnSelected,
    this.outlineColorSelected,
    this.outlineColorUnSelected,
    this.titleTextStyle,
    this.titleColor,
    this.spacing,
    this.borderWidth,
    this.size,
  });

  @override
  State<BennyRadio<T>> createState() => _BennyRadioState<T>();
}

class _BennyRadioState<T> extends State<BennyRadio<T>> {
  final theme = bennyLocator<ThemeState>();

  String? _title;
  bool _isEnable = true;
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    _title = widget.title;
    _isEnable = widget.enable;
    _isSelected = widget.isSelected;
  }

  @override
  void didUpdateWidget(covariant BennyRadio<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _isSelected = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        if (widget.enable) {
          _isSelected = !_isSelected;
          widget.onChange?.call(widget.value);
          setState(() {});
        }
      },
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 120),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _itemRadio(),
            _title == null
                ? const SizedBox.shrink()
                : Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: widget.spacing ?? 8),
                      child: Text(
                        _title!,
                        style: theme.textStyle.paragraphDefault.copyWith(
                            color:
                                widget.titleColor ?? theme.colors.neutral800),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _itemRadio() {
    return Container(
      width: widget.size ?? 16,
      height: widget.size ?? 16,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _isEnable
            ? (_isSelected
                ? (widget.outlineColorSelected ?? theme.colors.brand600)
                : Colors.white)
            : (_isSelected
                ? (widget.outlineColorUnSelected ?? theme.colors.neutral500)
                : theme.colors.neutral400),
        border: Border.all(
          color: _isEnable
              ? (_isSelected
                  ? (widget.borderColorSelected ?? theme.colors.brand900)
                  : theme.colors.neutral200)
              : (_isSelected
                  ? (widget.borderColorUnSelected ?? theme.colors.neutral200)
                  : theme.colors.neutral200),
          width: widget.borderWidth ?? 1,
        ),
        shape: BoxShape.circle,
      ),
      child: _isSelected
          ? Container(
              decoration: BoxDecoration(
                color: _isEnable
                    ? (_isSelected
                        ? (widget.centerColorSelected ?? Colors.white)
                        : Colors.transparent)
                    : (_isSelected
                        ? (widget.centerColorUnSelected ??
                            theme.colors.neutral900)
                        : Colors.transparent),
                shape: BoxShape.circle,
              ),
            )
          : null,
    );
  }
}
