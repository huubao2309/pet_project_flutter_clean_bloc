import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:benny_style/benny_locator.dart';
import 'package:benny_style/theme/theme_state.dart';

class BennyTextField<T> extends StatefulWidget {
  const BennyTextField({
    super.key,
    this.focusNode,
    this.enabled = true,
    this.hintText,
    this.hintStyle,
    this.cursorColor,
    this.enableBackgroundColor,
    this.disableBackgroundColor,
    this.defaultBorderColor,
    this.enableBorderColor,
    this.disableBorderColor,
    this.errorBorder,
    this.focusedErrorBorder,
    this.editTextStyle,
    this.onTextChanged,
    this.validator,
    this.prefixIcon,
    this.suffixIcons,
    this.scrollPadding,
    this.contentPadding,
    this.prefixIconConstraints,
    this.keyboardType = TextInputType.text,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.isShowCounterText = false,
    this.counterTextStyle,
    this.counterTextColor,
    this.controller,
    this.borderRadius,
    this.suffixIconConstraints,
    this.height = 36,
    this.obscureText = false,
    this.isSupportPhone = false,
    this.counterText,
    this.textInputAction,
    this.decoration,
    this.borderInput,
    this.disabledBorderInput,
    this.enabledBorderInput,
    this.errorBorderInput,
    this.focusedBorderInput,
    this.focusedErrorBorderInput,
    this.hasShadow = true,
    this.onTap,
    this.readOnly = false,
    this.inputFormatters,
    this.errorText,
    this.errorMaxLines,
  });

  final FocusNode? focusNode;
  final bool enabled;
  final TextStyle? editTextStyle;
  final String? hintText;
  final TextStyle? hintStyle;
  final Color? cursorColor;
  final Color? enableBackgroundColor;
  final Color? disableBackgroundColor;
  final Color? defaultBorderColor;
  final Color? enableBorderColor;
  final Color? disableBorderColor;
  final Color? errorBorder;
  final Color? focusedErrorBorder;
  final Function(String)? onTextChanged;
  final FormFieldValidator<T>? validator;
  final Widget? prefixIcon;
  final List<Widget>? suffixIcons;
  final EdgeInsets? scrollPadding;
  final EdgeInsetsGeometry? contentPadding;
  final BoxConstraints? prefixIconConstraints;
  final BoxConstraints? suffixIconConstraints;
  final TextInputType keyboardType;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool isShowCounterText;
  final TextStyle? counterTextStyle;
  final Color? counterTextColor;
  final TextEditingController? controller;
  final BorderRadius? borderRadius;
  final double? height;
  final bool obscureText;
  final bool isSupportPhone;
  final String? counterText;
  final TextInputAction? textInputAction;
  final InputDecoration? decoration;
  final InputBorder? borderInput;
  final InputBorder? focusedBorderInput;
  final InputBorder? errorBorderInput;
  final InputBorder? focusedErrorBorderInput;
  final InputBorder? disabledBorderInput;
  final InputBorder? enabledBorderInput;
  final bool? hasShadow;
  final GestureTapCallback? onTap;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatters;

  /// Inline error message shown under the field (for live validation).
  final String? errorText;

  /// Max number of lines for [errorText] (e.g. listing several failed rules).
  final int? errorMaxLines;

  @override
  State<BennyTextField> createState() => _BennyTextFieldState();
}

class _BennyTextFieldState<T> extends State<BennyTextField> {
  final theme = bennyLocator<ThemeState>();
  late FocusNode _focus;
  bool _isFocused = false;

  BorderRadius get _borderRadius =>
      widget.borderRadius ?? const BorderRadius.all(Radius.circular(8));

  @override
  void initState() {
    _focus = widget.focusNode ?? FocusNode();
    super.initState();
    if (widget.readOnly == false) _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focus.hasFocus;
    });
  }

  @override
  void dispose() {
    _focus.removeListener(_onFocusChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double verticalPadding = 12; // default padding
    if (widget.height != null) {
      // Assuming text and icon have roughly 24dp height
      // (widget.height - textHeight) / 2 to center the content
      verticalPadding = (widget.height! - 24) / 2;
      // Ensure minimum padding
      verticalPadding = verticalPadding.clamp(8.0, double.infinity);
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius: (_isFocused && widget.isSupportPhone)
            ? const BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8))
            : BorderRadius.circular(8),
        boxShadow: (_isFocused && widget.hasShadow!)
            ? [
                BoxShadow(
                  color: theme.colors.brand400,
                  spreadRadius: 2,
                  blurRadius: 0,
                  offset: const Offset(0, 0),
                ),
              ]
            : null,
      ),
      child: TextFormField(
        readOnly: widget.readOnly,
        onTap: widget.onTap,
        onTapOutside: (PointerDownEvent event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        obscureText: widget.obscureText,
        focusNode: _focus,
        enabled: widget.enabled,
        controller: widget.controller,
        scrollPadding: widget.scrollPadding ?? EdgeInsets.zero,
        style: widget.editTextStyle ??
            theme.textStyle.paragraphDefault.copyWith(color: theme.colors.neutral800),
        validator: widget.validator,
        cursorColor: widget.cursorColor ?? theme.colors.brand700,
        keyboardType: widget.keyboardType,
        // Obscured (password) fields must be single-line — Flutter asserts
        // `!obscureText || maxLines == 1`.
        maxLines: widget.obscureText ? 1 : widget.maxLines,
        minLines: widget.obscureText ? null : widget.minLines,
        maxLength: widget.maxLength,
        inputFormatters: widget.inputFormatters,
        decoration: widget.decoration ??
            InputDecoration(
              isDense: true,
              contentPadding: widget.contentPadding ??
                  EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: verticalPadding,
                  ),
              prefixIconConstraints: widget.prefixIconConstraints,
              prefixIcon: widget.prefixIcon == null
                  ? null
                  : Container(
                      margin: const EdgeInsets.only(left: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [widget.prefixIcon!],
                      ),
                    ),
              suffixIconConstraints: widget.suffixIconConstraints,
              suffixIcon: widget.suffixIcons == null
                  ? null
                  : Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: widget.suffixIcons!,
                      ),
                    ),
              border: widget.borderInput ??
                  OutlineInputBorder(
                    borderSide:
                        BorderSide(color: widget.defaultBorderColor ?? theme.colors.neutral100),
                    borderRadius: _borderRadius,
                  ),
              focusedBorder: widget.focusedErrorBorderInput ??
                  OutlineInputBorder(
                    borderSide: BorderSide(
                        color: widget.enableBorderColor ??
                            (widget.readOnly == true
                                ? theme.colors.neutral100
                                : theme.colors.brand700)),
                    borderRadius: _borderRadius,
                  ),
              errorBorder: widget.errorBorderInput ??
                  OutlineInputBorder(
                    borderSide: BorderSide(color: widget.errorBorder ?? theme.colors.brand300),
                    borderRadius: _borderRadius,
                  ),
              focusedErrorBorder: widget.focusedErrorBorderInput ??
                  OutlineInputBorder(
                    borderSide:
                        BorderSide(color: widget.focusedErrorBorder ?? theme.colors.brand600),
                    borderRadius: _borderRadius,
                  ),
              disabledBorder: widget.disabledBorderInput ??
                  OutlineInputBorder(
                    borderSide:
                        BorderSide(color: widget.disableBorderColor ?? theme.colors.neutral300),
                    borderRadius: _borderRadius,
                    gapPadding: 0,
                  ),
              enabledBorder: widget.enabledBorderInput ??
                  OutlineInputBorder(
                    borderSide:
                        BorderSide(color: widget.enableBorderColor ?? theme.colors.neutral100),
                    borderRadius: _borderRadius,
                  ),
              hintText: widget.hintText,
              hintStyle: widget.hintStyle ??
                  theme.textStyle.paragraphDefault.apply(color: theme.colors.neutral500),
              filled: true,
              fillColor: widget.enabled
                  ? (widget.enableBackgroundColor ?? Colors.white)
                  : (widget.disableBorderColor ?? theme.colors.neutral200),
              counterText: widget.counterText,
              errorText: widget.errorText,
              errorMaxLines: widget.errorMaxLines,
            ),
        onChanged: widget.onTextChanged,
      ),
    );
  }
}
