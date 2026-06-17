import 'package:benny_style/textfields/benny_textfield.dart';
import 'package:benny_style/theme/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../di/injection.dart';

/// The single text-field component used across every screen, so every input has
/// the same height regardless of whether it carries a suffix icon (e.g. the
/// password show/hide eye). It wraps [BennyTextField] and:
///
/// * pins the input box to [fieldHeight] and constrains the suffix icon so it
///   never inflates the row (the root cause of mismatched field heights),
/// * renders validation errors the way the design system defines them — a red
///   border plus a small caption below the field — instead of Material's
///   default error styling,
/// * optionally manages an obscured password with a built-in eye toggle.
///
/// All colours come from theme tokens, so it adapts to Light and Dark mode.
class AppTextField extends StatefulWidget {
  const AppTextField({
    required this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.errorText,
    this.obscure = false,
    this.prefixIcon,
    this.prefixIconConstraints,
    this.textInputAction,
    this.inputFormatters,
    this.enabled = true,
    super.key,
  });

  /// Unified input-box height for the whole app.
  static const double fieldHeight = 48;

  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final bool obscure;
  final Widget? prefixIcon;
  final BoxConstraints? prefixIconConstraints;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
    final errorColor = theme.colors.error500;

    final suffixIcons = widget.obscure
        ? <Widget>[
            GestureDetector(
              onTap: () => setState(() => _obscured = !_obscured),
              behavior: HitTestBehavior.opaque,
              child: Icon(
                _obscured
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 20,
                color: theme.colors.neutral400,
              ),
            ),
          ]
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        BennyTextField<String>(
          controller: widget.controller,
          enabled: widget.enabled,
          hintText: widget.hintText,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscure && _obscured,
          height: AppTextField.fieldHeight,
          onTextChanged: widget.onChanged,
          textInputAction: widget.textInputAction,
          inputFormatters: widget.inputFormatters,
          prefixIcon: widget.prefixIcon,
          prefixIconConstraints: widget.prefixIconConstraints,
          suffixIcons: suffixIcons,
          // Keep the suffix from forcing the Material default 48dp min height,
          // so suffixed and plain fields stay exactly the same height.
          suffixIconConstraints: const BoxConstraints(minWidth: 40),
          // Drive the border red in every state when invalid (the design's
          // `.inp.bad`); leave null otherwise to keep the default + focus glow.
          defaultBorderColor: hasError ? errorColor : null,
          enableBorderColor: hasError ? errorColor : null,
          // We render the message ourselves below, so suppress Material's.
        ),
        if (hasError) ...[
          SizedBox(height: theme.spacing.spacing4),
          Text(
            widget.errorText!,
            style: theme.textStyle.captionDefault.copyWith(
              color: errorColor,
              fontSize: 12,
              height: 1.2,
            ),
          ),
        ],
      ],
    );
  }
}
