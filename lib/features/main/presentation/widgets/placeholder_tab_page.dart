import 'package:benny_style/theme/theme_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';

/// Lightweight placeholder for tabs whose feature is not implemented yet
/// (History, QR, Promotion). Shows the localized tab title + an icon.
class PlaceholderTabPage extends StatelessWidget {
  const PlaceholderTabPage({
    required this.titleKey,
    required this.icon,
    super.key,
  });

  final String titleKey;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();

    return Scaffold(
      backgroundColor: theme.colors.neutral25,
      appBar: AppBar(
        backgroundColor: theme.colors.neutral25,
        elevation: 0,
        title: Text(titleKey.tr()),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: theme.colors.neutral400),
            const SizedBox(height: 12),
            Text(
              titleKey.tr(),
              style: theme.textStyle.paragraphDefault
                  .copyWith(color: theme.colors.neutral700),
            ),
          ],
        ),
      ),
    );
  }
}
