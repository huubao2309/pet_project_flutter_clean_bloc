import 'package:benny_style/buttons/benny_primary_button.dart';
import 'package:benny_style/buttons/benny_secondary_button.dart';
import 'package:benny_style/theme/theme_state.dart';
import 'package:flutter/material.dart';

import '../../di/injection.dart';

/// Visual tone of an [AppErrorView] — drives the badge colours.
enum AppErrorTone { error, warning }

/// Reusable full-screen error state: a circular icon badge, a title and a
/// description. Use it for hard stops such as "too many failed login attempts"
/// or "too many wrong OTP entries" (account temporarily locked).
///
/// Both actions are optional — pass only what the situation needs.
class AppErrorView extends StatelessWidget {
  const AppErrorView({
    required this.title,
    required this.description,
    this.icon = Icons.lock_outline_rounded,
    this.tone = AppErrorTone.error,
    this.primaryLabel,
    this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
    super.key,
  });

  final String title;
  final String description;
  final IconData icon;
  final AppErrorTone tone;
  final String? primaryLabel;
  final VoidCallback? onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();
    final badgeBg = tone == AppErrorTone.warning
        ? theme.colors.secondary50
        : theme.colors.error50;
    final badgeColor = tone == AppErrorTone.warning
        ? theme.colors.secondary600
        : theme.colors.error600;

    return Scaffold(
      backgroundColor: theme.colors.surfaceBackground,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: theme.spacing.spacing32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration:
                      BoxDecoration(color: badgeBg, shape: BoxShape.circle),
                  child: Icon(icon, size: 46, color: badgeColor),
                ),
                SizedBox(height: theme.spacing.spacing24),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: theme.textStyle.heading
                      .copyWith(color: theme.colors.brand800),
                ),
                SizedBox(height: theme.spacing.spacing8),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: theme.textStyle.paragraphDefault
                      .copyWith(color: theme.colors.neutral600),
                ),
                if (primaryLabel != null) ...[
                  SizedBox(height: theme.spacing.spacing32),
                  BennyPrimaryButton(
                    title: primaryLabel!,
                    isWrapContent: false,
                    onPressed: onPrimary,
                  ),
                ],
                if (secondaryLabel != null) ...[
                  SizedBox(height: theme.spacing.spacing12),
                  BennySecondaryButton(
                    title: secondaryLabel!,
                    isWrapContent: false,
                    onPressed: onSecondary,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
