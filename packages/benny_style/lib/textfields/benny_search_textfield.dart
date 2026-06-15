import 'package:flutter/material.dart';
import 'package:benny_style/textfields/benny_textfield.dart';

class BennySearchTextField extends StatefulWidget {
  const BennySearchTextField({
    super.key,
    this.focusNode,
    this.controller,
    this.enabled = true,
    this.prefixPhoneText,
    this.prefixIcon,
    this.suffixIcons,
    this.defaultBorderColor,
    this.focusBorderColor,
    this.disableBorderColor,
    this.borderRadius,
    this.hintText,
    this.hintStyle,
    this.editTextStyle,
    this.validator,
    this.onTextChanged,
    this.contentPadding,
    this.prefixIconConstraints,
    this.height,
    this.suffixIconConstraints,
    this.maxLines,
  });

  final EdgeInsetsGeometry? contentPadding;
  final BoxConstraints? prefixIconConstraints;
  final BoxConstraints? suffixIconConstraints;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final bool enabled;
  final Widget? prefixPhoneText;
  final Widget? prefixIcon;
  final List<Widget>? suffixIcons;
  final Color? defaultBorderColor;
  final Color? focusBorderColor;
  final Color? disableBorderColor;
  final BorderRadiusGeometry? borderRadius;
  final TextStyle? editTextStyle;
  final String? hintText;
  final TextStyle? hintStyle;
  final FormFieldValidator? validator;
  final Function(String)? onTextChanged;
  final int? maxLines;
  final double? height;

  @override
  State<BennySearchTextField> createState() => _BennySearchTextFieldState();
}

class _BennySearchTextFieldState extends State<BennySearchTextField> {
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !widget.enabled,
      child: BennyTextField(
        focusNode: widget.focusNode,
        controller: widget.controller,
        enabled: widget.enabled,
        maxLines: widget.maxLines,
        prefixIcon: widget.prefixIcon == null
            ? null
            : Container(
                width: 20,
                height: 20,
                padding: const EdgeInsets.all(4),
                child: widget.prefixIcon!,
              ),
        validator: widget.validator,
        hintText: widget.hintText,
        contentPadding: widget.contentPadding,
        prefixIconConstraints:
            widget.prefixIconConstraints ?? const BoxConstraints(maxWidth: 64),
        hintStyle: widget.hintStyle,
        suffixIconConstraints: widget.suffixIconConstraints ??
            const BoxConstraints(
              maxHeight: 36,
            ),
        height: widget.height,
        suffixIcons: widget.suffixIcons,
        onTextChanged: (String text) {
          widget.onTextChanged?.call(text);
        },
      ),
    );
  }
}
