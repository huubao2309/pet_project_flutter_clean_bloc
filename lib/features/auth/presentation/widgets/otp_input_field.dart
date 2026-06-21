import 'package:benny_style/theme/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/di/injection.dart';

/// A fixed-length OTP entry: [length] cells driven by a single hidden field.
/// Tapping anywhere focuses the field; the cells mirror the typed digits and
/// turn red while [hasError] is set.
///
/// When [obscure] is true (the default) each filled cell shows
/// [obscuringCharacter] instead of the digit, masking the code the moment it is
/// typed.
class OtpInputField extends StatefulWidget {
  const OtpInputField({
    required this.onChanged,
    this.onCompleted,
    this.length = 6,
    this.hasError = false,
    this.autofocus = true,
    this.obscure = true,
    this.obscuringCharacter = '•',
    super.key,
  });

  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onCompleted;
  final int length;
  final bool hasError;
  final bool autofocus;

  /// Mask each filled cell instead of showing the digit.
  final bool obscure;

  /// The glyph shown in a filled cell while [obscure] is true.
  final String obscuringCharacter;

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    widget.onChanged(value);
    if (value.length == widget.length) {
      widget.onCompleted?.call(value);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();
    final text = _controller.text;

    return GestureDetector(
      onTap: () => _focusNode.requestFocus(),
      behavior: HitTestBehavior.opaque,
      child: Stack(
        children: [
          Row(
            children: [
              for (var i = 0; i < widget.length; i++) ...[
                if (i > 0) SizedBox(width: theme.spacing.spacing8),
                Expanded(
                  child: _Cell(
                    theme: theme,
                    index: i,
                    text: text,
                    hasError: widget.hasError,
                    focused: _focusNode.hasFocus,
                    obscure: widget.obscure,
                    obscuringCharacter: widget.obscuringCharacter,
                  ),
                ),
              ],
            ],
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0,
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                autofocus: widget.autofocus,
                keyboardType: TextInputType.number,
                showCursor: false,
                maxLength: widget.length,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: _onChanged,
                decoration: const InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({
    required this.theme,
    required this.index,
    required this.text,
    required this.hasError,
    required this.focused,
    required this.obscure,
    required this.obscuringCharacter,
  });

  final ThemeState theme;
  final int index;
  final String text;
  final bool hasError;
  final bool focused;
  final bool obscure;
  final String obscuringCharacter;

  @override
  Widget build(BuildContext context) {
    final filled = index < text.length;
    final isNext = focused && index == text.length;

    final Color borderColor;
    if (hasError) {
      borderColor = theme.colors.error500;
    } else if (isNext) {
      borderColor = theme.colors.brand600;
    } else if (filled) {
      borderColor = theme.colors.brand300;
    } else {
      borderColor = theme.colors.neutral200;
    }

    return Container(
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.colors.white,
        borderRadius: BorderRadius.circular(theme.borderRadius.borderRadius8),
        border: Border.all(
          color: borderColor,
          width: (isNext || hasError) ? 1.5 : 1,
        ),
      ),
      child: Text(
        filled ? (obscure ? obscuringCharacter : text[index]) : '',
        style: theme.textStyle.heading.copyWith(
          color: theme.colors.brand800,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
