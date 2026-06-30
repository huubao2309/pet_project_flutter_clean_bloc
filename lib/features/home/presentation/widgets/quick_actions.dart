import 'package:benny_style/theme/theme_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';

/// Four primary shortcuts the collaborator reaches for most: scan QR, post a
/// listing, customers and reports.
class QuickActions extends StatelessWidget {
  const QuickActions({this.onScanQr, super.key});

  final VoidCallback? onScanQr;

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();

    final actions = <_ActionData>[
      _ActionData(
        'home.action.scan',
        Icons.qr_code_scanner_rounded,
        onScanQr,
        accent: true,
      ),
      const _ActionData('home.action.post', Icons.add_home_work_outlined, null),
      const _ActionData('home.action.customers', Icons.groups_outlined, null),
      const _ActionData('home.action.reports', Icons.insights_outlined, null),
    ];

    return Row(
      children: [
        for (final action in actions)
          Expanded(child: _ActionItem(data: action, theme: theme)),
      ],
    );
  }
}

class _ActionData {
  const _ActionData(
    this.labelKey,
    this.icon,
    this.onTap, {
    this.accent = false,
  });

  final String labelKey;
  final IconData icon;
  final VoidCallback? onTap;
  final bool accent;
}

class _ActionItem extends StatelessWidget {
  const _ActionItem({required this.data, required this.theme});

  final _ActionData data;
  final ThemeState theme;

  @override
  Widget build(BuildContext context) {
    final iconColor =
        data.accent ? theme.colors.secondary600 : theme.colors.brand600;
    final bg = data.accent ? theme.colors.secondary50 : theme.colors.brand50;

    return InkWell(
      onTap: data.onTap,
      borderRadius: BorderRadius.circular(theme.borderRadius.borderRadius16),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: theme.spacing.spacing8),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: bg,
                borderRadius:
                    BorderRadius.circular(theme.borderRadius.borderRadius16),
              ),
              child: Icon(data.icon, color: iconColor, size: 26),
            ),
            SizedBox(height: theme.spacing.spacing8),
            Text(
              data.labelKey.tr(),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textStyle.captionDefault
                  .copyWith(color: theme.colors.brand800),
            ),
          ],
        ),
      ),
    );
  }
}
