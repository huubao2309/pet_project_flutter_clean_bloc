import 'package:benny_style/theme/theme_state.dart';
import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';

/// White rounded surface that wraps the auth form fields on the gray
/// `surfaceBackground`, matching the card style used across the app.
class AuthCard extends StatelessWidget {
  const AuthCard({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(theme.spacing.spacing20),
      decoration: BoxDecoration(
        color: theme.colors.white,
        borderRadius: BorderRadius.circular(theme.borderRadius.borderRadius16),
        border: Border.all(color: theme.colors.neutral100),
        boxShadow: [
          BoxShadow(
            color: theme.colors.brand900.withAlpha((255 * 0.05).round()),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}
