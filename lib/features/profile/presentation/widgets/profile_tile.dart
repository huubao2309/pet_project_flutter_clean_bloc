import 'package:benny_style/theme/theme_state.dart';
import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';

/// One row in the Profile settings list: leading icon badge + title, with an
/// optional value, custom trailing (e.g. a switch) or a chevron. Brightness-
/// aware via the design tokens.
///
/// Every row is pinned to [_minRowHeight] so rows stay visually even no matter
/// how tall the trailing widget is — a [Switch] (with its 48px tap target)
/// would otherwise make its row taller than the icon-only rows.
class ProfileTile extends StatelessWidget {
  /// Uniform row height (Material single-line list item with a leading icon).
  /// Comfortably contains the 34px icon badge and a switch's tap target.
  static const double _minRowHeight = 56;

  const ProfileTile({
    required this.icon,
    required this.title,
    this.value,
    this.trailing,
    this.onTap,
    this.destructive = false,
    this.showChevron = true,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? value;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool destructive;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();
    final titleColor =
        destructive ? theme.colors.error600 : theme.colors.brand800;
    final iconColor =
        destructive ? theme.colors.error600 : theme.colors.brand600;
    final iconBg = destructive ? theme.colors.error50 : theme.colors.brand50;

    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: _minRowHeight),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: theme.spacing.spacing12),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, size: 18, color: iconColor),
              ),
              SizedBox(width: theme.spacing.spacing12),
              Expanded(
                child: Text(
                  title,
                  style: theme.textStyle.paragraphDefault
                      .copyWith(color: titleColor, fontWeight: FontWeight.w500),
                ),
              ),
              if (value != null)
                Padding(
                  padding: EdgeInsets.only(right: theme.spacing.spacing8),
                  child: Text(
                    value!,
                    style: theme.textStyle.captionDefault
                        .copyWith(color: theme.colors.neutral500),
                  ),
                ),
              if (trailing != null)
                trailing!
              else if (showChevron && onTap != null)
                Icon(
                  Icons.chevron_right,
                  color: theme.colors.neutral300,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
