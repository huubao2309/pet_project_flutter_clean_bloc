import 'package:flutter/material.dart';

import '../../../../core/presentation/widgets/app_text_field.dart';

/// Password input for the auth screens. A thin alias over [AppTextField] with
/// the obscure/eye toggle enabled, so every password field shares the app-wide
/// field height and error styling.
class AuthPasswordField extends StatelessWidget {
  const AuthPasswordField({
    required this.hintText,
    this.controller,
    this.errorText,
    this.onTextChanged,
    super.key,
  });

  final String hintText;
  final TextEditingController? controller;
  final String? errorText;
  final ValueChanged<String>? onTextChanged;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      hintText: hintText,
      controller: controller,
      errorText: errorText,
      onChanged: onTextChanged,
      obscure: true,
    );
  }
}
