import 'package:flutter/material.dart';
import 'package:benny_style/theme/theme_state.dart';

import '../../../di/injection.dart';

/// Preset icon styles for the dialog header circle (design §13).
///
/// Each maps to a tinted circle + glyph colour pulled from the theme so the
/// look changes in one place. Pass a fully custom `Widget` instead when a
/// preset does not fit.
enum AppOverlayIconType {
  /// Navy "?" — neutral confirmation.
  confirm,

  /// Red "!" — destructive / warning.
  warning,

  /// Green "✓" — success / acknowledge.
  success,

  /// Navy "ⓘ" — informational.
  info,
}

/// The tinted circle + glyph shown at the top of a dialog. 56×56, radius full.
class AppOverlayIcon extends StatelessWidget {
  const AppOverlayIcon({required this.type, super.key});

  final AppOverlayIconType type;

  @override
  Widget build(BuildContext context) {
    final ThemeState theme = getIt<ThemeState>();
    final _IconColors c = _resolve(theme);

    return Container(
      width: 56,
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: c.background,
        shape: BoxShape.circle,
      ),
      child: Icon(c.icon, color: c.foreground, size: 28),
    );
  }

  _IconColors _resolve(ThemeState theme) {
    switch (type) {
      case AppOverlayIconType.confirm:
        return _IconColors(
          background: theme.colors.brand50,
          foreground: theme.colors.brand600,
          icon: Icons.question_mark_rounded,
        );
      case AppOverlayIconType.warning:
        return _IconColors(
          background: theme.colors.error50,
          foreground: theme.colors.error600,
          icon: Icons.priority_high_rounded,
        );
      case AppOverlayIconType.success:
        return _IconColors(
          background: theme.colors.success50,
          foreground: theme.colors.success600,
          icon: Icons.check_rounded,
        );
      case AppOverlayIconType.info:
        return _IconColors(
          background: theme.colors.brand50,
          foreground: theme.colors.brand600,
          icon: Icons.info_outline_rounded,
        );
    }
  }
}

class _IconColors {
  const _IconColors({
    required this.background,
    required this.foreground,
    required this.icon,
  });

  final Color background;
  final Color foreground;
  final IconData icon;
}
