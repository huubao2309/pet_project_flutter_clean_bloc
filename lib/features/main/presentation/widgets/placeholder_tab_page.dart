import 'package:benny_style/theme/theme_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';

/// Polished "coming soon" placeholder for tabs whose feature is not built yet
/// (History, QR, Commission). Shows the localized tab title, a circular icon
/// badge and a short subtitle, themed with the brand palette.
class PlaceholderTabPage extends StatelessWidget {
  const PlaceholderTabPage({
    required this.titleKey,
    required this.icon,
    this.subtitleKey,
    this.accent = false,
    super.key,
  });

  final String titleKey;
  final String? subtitleKey;
  final IconData icon;

  /// When true the badge uses the amber accent instead of navy.
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();
    final badgeColor =
        accent ? theme.colors.secondary500 : theme.colors.brand600;
    final badgeBg = accent ? theme.colors.secondary50 : theme.colors.brand50;

    return Scaffold(
      backgroundColor: theme.colors.surfaceBackground,
      appBar: AppBar(
        backgroundColor: theme.colors.surfaceBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: Text(
          titleKey.tr(),
          style: theme.textStyle.heading.copyWith(color: theme.colors.brand800),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: theme.spacing.spacing32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration:
                    BoxDecoration(color: badgeBg, shape: BoxShape.circle),
                child: Icon(icon, size: 44, color: badgeColor),
              ),
              SizedBox(height: theme.spacing.spacing20),
              Text(
                titleKey.tr(),
                textAlign: TextAlign.center,
                style: theme.textStyle.heading
                    .copyWith(color: theme.colors.brand800),
              ),
              if (subtitleKey != null) ...[
                SizedBox(height: theme.spacing.spacing8),
                Text(
                  subtitleKey!.tr(),
                  textAlign: TextAlign.center,
                  style: theme.textStyle.paragraphDefault
                      .copyWith(color: theme.colors.neutral500),
                ),
              ],
              SizedBox(height: theme.spacing.spacing20),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: theme.spacing.spacing12,
                  vertical: theme.spacing.spacing4,
                ),
                decoration: BoxDecoration(
                  color: theme.colors.secondary50,
                  borderRadius:
                      BorderRadius.circular(theme.borderRadius.borderRadius16),
                ),
                child: Text(
                  'placeholder.coming_soon'.tr(),
                  style: theme.textStyle.captionDefault
                      .copyWith(color: theme.colors.secondary700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
