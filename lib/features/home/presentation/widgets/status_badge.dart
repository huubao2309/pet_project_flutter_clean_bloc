import 'package:benny_style/theme/theme_state.dart';
import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';

/// Small rounded pill used to flag a property or deal status. Caller supplies
/// the resolved foreground/background so the mapping lives next to the data.
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    required this.label,
    required this.color,
    required this.background,
    this.icon,
    super.key,
  });

  final String label;
  final Color color;
  final Color background;

  /// Optional leading icon (e.g. a flame for an urgent-sell status).
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing.spacing8,
        vertical: theme.spacing.spacing2,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(theme.borderRadius.borderRadius16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 3),
          ],
          Text(
            label,
            style: theme.textStyle.captionDefault
                .copyWith(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
