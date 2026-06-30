import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:benny_style/benny_locator.dart';
import 'package:benny_style/generated/assets.gen.dart';
import 'package:benny_style/theme/theme_state.dart';

class BennyCheckbox extends StatefulWidget {
  const BennyCheckbox({
    super.key,
    this.size,
    this.title,
    this.value,
    this.onChange,
    this.spacing,
    this.fillColorSelected,
    this.fillColorUnSelected,
    this.checkColorSelected,
    this.borderColorSelected,
    this.borderColorUnSelected,
    this.titleColor,
    this.borderWidth,
    this.enable = false,
    this.iconCheck,
    this.iconUnknown,
    this.iconColor,
    this.borderRadius = 4,
    this.tristate = false,
  });

  final double? size;
  final String? title;
  final bool? value;
  final bool enable;
  final double? spacing;
  final Color? fillColorSelected;
  final Color? fillColorUnSelected;
  final Color? checkColorSelected;
  final Color? borderColorSelected;
  final Color? borderColorUnSelected;
  final Color? titleColor;
  final double? borderWidth;
  final void Function(bool?)? onChange;
  final Widget? iconCheck;
  final Widget? iconUnknown;
  final Color? iconColor;
  final double? borderRadius;
  final bool tristate;

  @override
  State<BennyCheckbox> createState() => _BennyCheckboxState();
}

class _BennyCheckboxState extends State<BennyCheckbox> {
  bool? _isChecked;
  final theme = bennyLocator<ThemeState>();

  final double _defaultSizeCheckbox = 16;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !widget.enable,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _checkBoxWidget(),
          widget.title == null
              ? const SizedBox.shrink()
              : Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(left: widget.spacing ?? 8),
                    child: Text(
                      widget.title!,
                      style: theme.textStyle.paragraphDefault.copyWith(
                          color: widget.titleColor ?? theme.colors.neutral800),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _checkBoxWidget() {
    return GestureDetector(
      onTap: !widget.enable
          ? null
          : () {
              setState(() {
                _isChecked = _changeValueChecked(_isChecked);
                widget.onChange?.call(_isChecked);
              });
            },
      child: AnimatedContainer(
        height: widget.size ?? _defaultSizeCheckbox,
        width: widget.size ?? _defaultSizeCheckbox,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastLinearToSlowEaseIn,
        decoration: BoxDecoration(
          color: _buildFillColor(_isChecked),
          border: _buildBorderColor(_isChecked),
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 1),
        ),
        child: Center(
          child: _buildIcon(_isChecked),
        ),
      ),
    );
  }

  BoxBorder _buildBorderColor(bool? currentCheckedValue) {
    final bool isChecked = widget.tristate
        ? (currentCheckedValue == null || currentCheckedValue == true)
        : (currentCheckedValue == true);

    if (isChecked) {
      return Border.all(
        color: widget.enable
            ? (widget.borderColorSelected ?? theme.colors.brand900)
            : theme.colors.neutral200,
        width: widget.borderWidth ?? 1,
      );
    } else {
      return Border.all(
        color: widget.enable
            ? (widget.borderColorUnSelected ?? theme.colors.neutral200)
            : theme.colors.neutral200,
        width: widget.borderWidth ?? 1,
      );
    }
  }

  Color _buildFillColor(bool? currentCheckedValue) {
    final bool isChecked = widget.tristate
        ? (currentCheckedValue == null || currentCheckedValue == true)
        : (currentCheckedValue == true);

    if (isChecked) {
      return widget.enable
          ? (widget.fillColorSelected ?? theme.colors.brand700)
          : theme.colors.neutral400;
    } else {
      return widget.enable
          ? (widget.fillColorUnSelected ?? theme.colors.white)
          : theme.colors.neutral300;
    }
  }

  Widget _buildIcon(bool? currentCheckedValue) {
    final size = (widget.size ?? _defaultSizeCheckbox) * 12 / 16;

    if (currentCheckedValue == null && widget.tristate) {
      return widget.iconUnknown ??
          SvgPicture.asset(
            Assets.svg.icMinusSmall.keyName,
            height: size,
            width: size,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          );
    }

    if (currentCheckedValue == false) {
      return const SizedBox.shrink();
    }

    if (currentCheckedValue == true) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        child: widget.iconCheck ??
            SvgPicture.asset(
              Assets.svg.icCheckSmall.keyName,
              height: size,
              width: size,
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
      );
    }

    return const SizedBox.shrink();
  }

  bool? _changeValueChecked(bool? currentCheckedValue) {
    if (widget.tristate) {
      // 3-state logic
      if (currentCheckedValue == null) {
        return false;
      }
      if (currentCheckedValue == false) {
        return true;
      }
      if (currentCheckedValue == true) {
        return null;
      }
    } else {
      // 2-state logic
      return currentCheckedValue != true;
    }
    return false;
  }
}
