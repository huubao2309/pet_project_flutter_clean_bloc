import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:benny_style/benny_locator.dart';
import 'package:benny_style/generated/assets.gen.dart';
import 'package:benny_style/textfields/benny_textfield.dart';
import 'package:benny_style/theme/app_colors.dart';
import 'package:benny_style/theme/theme_state.dart';

class BennyPhoneTextField extends StatefulWidget {
  const BennyPhoneTextField({
    super.key,
    this.controller,
    this.phoneText,
    this.prefixIcon,
    this.suffixIcons,
    this.borderColor,
    this.borderRadius,
    this.hintText,
    this.hintStyle,
    this.editTextStyle,
    this.enableBorderColor,
    this.validator,
    this.onTextChanged,
    this.onTapPrefix,
    this.height = 36,
    this.suffixIconConstraints,
    this.prefixIconConstraints,
    this.inputFormatters,
  });

  final TextEditingController? controller;
  final String? phoneText;
  final Widget? prefixIcon;
  final List<Widget>? suffixIcons;
  final Color? borderColor;
  final double? borderRadius;
  final TextStyle? editTextStyle;
  final String? hintText;
  final TextStyle? hintStyle;
  final Color? enableBorderColor;
  final FormFieldValidator? validator;
  final Function(String)? onTextChanged;
  final GestureTapCallback? onTapPrefix;
  final double? height;
  final BoxConstraints? suffixIconConstraints;
  final BoxConstraints? prefixIconConstraints;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<BennyPhoneTextField> createState() => _BennyPhoneTextFieldState();
}

class _BennyPhoneTextFieldState extends State<BennyPhoneTextField> {
  final ThemeState theme = bennyLocator<ThemeState>();

  AppColors get _color => theme.colors;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Center(child: _buildPhonePrefix(widget.onTapPrefix)),
          Expanded(
            child: BennyTextField(
              controller: widget.controller,
              height: widget.height,
              suffixIcons: widget.suffixIcons,
              keyboardType: TextInputType.phone,
              maxLines: 1,
              hintText: widget.hintText,
              hintStyle: widget.hintStyle,
              prefixIconConstraints: widget.prefixIconConstraints,
              isSupportPhone: true,
              suffixIconConstraints: const BoxConstraints(
                maxHeight: 36,
              ),
              borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(widget.borderRadius ?? 8)),
              onTextChanged: (String text) {
                widget.onTextChanged?.call(text);
              },
              validator: widget.validator,
              inputFormatters: widget.inputFormatters,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhonePrefix(GestureTapCallback? onTap) {
    const double horizontalPadding = 12;
    double verticalPadding = 12;
    if (widget.height != null) {
      // Assuming text and icon have roughly 24dp height
      // (widget.height - textHeight) / 2 to center the content
      verticalPadding = (widget.height! - 24) / 2;
      // Ensure minimum padding
      verticalPadding = verticalPadding.clamp(8.0, double.infinity);
    }
    final Color borderColor = widget.enableBorderColor ?? _color.neutral100;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding, vertical: verticalPadding - 1)
            .copyWith(left: 8),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: borderColor),
            left: BorderSide(color: borderColor),
            bottom: BorderSide(color: borderColor),
            right: BorderSide.none,
          ),
          borderRadius: BorderRadius.horizontal(
              left: Radius.circular(widget.borderRadius ?? 8)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 44,
              alignment: Alignment.center,
              child: Text(
                widget.phoneText ?? "",
                maxLines: 1,
                textAlign: TextAlign.left,
                style: theme.textStyle.paragraphDefault
                    .apply(color: _color.neutral800),
              ),
            ),
            Container(
              height: 20,
              width: 20,
              alignment: Alignment.center,
              child: widget.prefixIcon ??
                  SvgPicture.asset(
                    Assets.svg.icTriangleBottom.keyName,
                    width: 16,
                    height: 16,
                  ),
            )
          ],
        ),
      ),
    );
  }
}
