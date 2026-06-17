import 'package:benny_style/textfields/benny_textfield.dart';
import 'package:benny_style/theme/theme_state.dart';
import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';

/// Password field with an inline show/hide toggle. Wraps [BennyTextField] and
/// owns the obscured state, so every auth screen gets the same eye toggle.
class AuthPasswordField extends StatefulWidget {
  const AuthPasswordField({
    required this.hintText,
    this.controller,
    this.errorText,
    this.errorMaxLines,
    this.onTextChanged,
    super.key,
  });

  final String hintText;
  final TextEditingController? controller;
  final String? errorText;
  final int? errorMaxLines;
  final ValueChanged<String>? onTextChanged;

  @override
  State<AuthPasswordField> createState() => _AuthPasswordFieldState();
}

class _AuthPasswordFieldState extends State<AuthPasswordField> {
  bool _obscured = true;

  void _toggle() => setState(() => _obscured = !_obscured);

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();

    return BennyTextField<String>(
      controller: widget.controller,
      hintText: widget.hintText,
      obscureText: _obscured,
      errorText: widget.errorText,
      errorMaxLines: widget.errorMaxLines,
      onTextChanged: widget.onTextChanged,
      suffixIcons: [
        GestureDetector(
          onTap: _toggle,
          behavior: HitTestBehavior.opaque,
          child: Icon(
            _obscured
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            size: 20,
            color: theme.colors.neutral400,
          ),
        ),
      ],
    );
  }
}
