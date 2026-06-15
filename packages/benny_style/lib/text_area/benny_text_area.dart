import 'package:flutter/material.dart';
import 'package:benny_style/benny_locator.dart';
import 'package:benny_style/textfields/benny_textfield.dart';
import 'package:benny_style/theme/app_colors.dart';
import 'package:benny_style/theme/theme_state.dart';

class BennyTextArea extends StatefulWidget {
  final bool enabled;
  final String? hintText;
  final TextEditingController? controller;
  final int maxLength;
  final int? maxLines;
  final int minLines;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final TextStyle? counterStyle;
  final EdgeInsetsGeometry contentPadding;
  final Color? counterTextColor;
  final Color? borderColorFocused;
  final Color? borderColorUnfocused;
  final double borderWidthFocused;
  final double borderWidthUnfocused;
  final List<BoxShadow>? boxShadowFocused;

  const BennyTextArea({
    super.key,
    this.enabled = true,
    this.controller,
    this.maxLength = 240,
    this.maxLines = 5, // Default max lines
    this.minLines = 4, // Default min lines
    this.hintText,
    this.onChanged,
    this.validator,
    this.textStyle,
    this.hintStyle,
    this.counterStyle,
    this.contentPadding = const EdgeInsets.fromLTRB(8, 8, 8, 40),
    this.counterTextColor,
    this.borderColorFocused,
    this.borderColorUnfocused,
    this.borderWidthFocused = 1,
    this.borderWidthUnfocused = 1,
    this.boxShadowFocused,
  });

  @override
  State<BennyTextArea> createState() => _BennyTextAreaState();
}

class _BennyTextAreaState extends State<BennyTextArea> {
  final AppColors _color = bennyLocator<ThemeState>().colors;

  late TextEditingController _controller;
  int _characterCount = 0;
  final _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_updateCharacterCount);
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void _updateCharacterCount() {
    setState(() {
      _characterCount = _controller.text.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !widget.enabled,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: widget.enabled ? Colors.white : _color.neutral200,
          border: Border.all(
            color: widget.enabled
                ? (_isFocused
                    ? (widget.borderColorFocused ?? _color.brand700)
                    : (widget.borderColorUnfocused ?? _color.neutral100))
                : _color.neutral300,
            width: _isFocused
                ? widget.borderWidthFocused
                : widget.borderWidthUnfocused,
          ),
          boxShadow: _isFocused
              ? widget.boxShadowFocused ??
                  [
                    BoxShadow(
                      color: _color.brand400,
                      spreadRadius: 2,
                      blurRadius: 0,
                      offset: const Offset(0, 0),
                    ),
                  ]
              : null,
        ),
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            BennyTextField(
              hasShadow: false,
              controller: _controller,
              focusNode: _focusNode,
              maxLength: widget.maxLength,
              maxLines: widget.maxLines,
              minLines: widget.minLines,
              onTextChanged: widget.onChanged,
              validator: widget.validator,
              editTextStyle: widget.textStyle,
              borderInput: InputBorder.none,
              focusedBorderInput: InputBorder.none,
              errorBorderInput: InputBorder.none,
              focusedErrorBorderInput: InputBorder.none,
              disabledBorderInput: InputBorder.none,
              enabledBorderInput: InputBorder.none,
              enableBackgroundColor: Colors.transparent,
              hintText: widget.hintText,
              hintStyle: widget.hintStyle,
              contentPadding: widget.contentPadding,
              counterText: "",
            ),
            Positioned(
              right: 8,
              bottom: 8,
              child: Text(
                "$_characterCount/${widget.maxLength}",
                style: widget.counterStyle ??
                    TextStyle(
                        color: _characterCount >= widget.maxLength
                            ? _color.error800
                            : widget.counterTextColor ?? _color.neutral600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
