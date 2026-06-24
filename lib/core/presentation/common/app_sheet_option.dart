import 'package:flutter/material.dart';
import 'package:benny_style/theme/theme_state.dart';

import '../../di/injection.dart';

/// A single row inside an "options" or "list" bottom sheet (design §14).
///
/// Immutable value object. Use [leadingIcon] for a quick menu entry, or
/// [selected] to render a radio (single-select list). [isDestructive] tints the
/// row red. All fields optional except [label].
@immutable
class AppSheetOption {
  const AppSheetOption({
    required this.label,
    this.onTap,
    this.leadingIcon,
    this.leading,
    this.trailing,
    this.selected,
    this.isDestructive = false,
  });

  final String label;
  final VoidCallback? onTap;

  /// Quick leading glyph; ignored when [leading] is provided.
  final IconData? leadingIcon;

  /// Full custom leading widget.
  final Widget? leading;

  final Widget? trailing;

  /// When non-null the row renders a radio indicator reflecting this value
  /// (single-select list mode).
  final bool? selected;

  final bool isDestructive;

  /// Builds the tappable row. [onTapOverride] lets the host sheet intercept the
  /// tap (e.g. to pop with a result) while still running [onTap].
  Widget build(BuildContext context, {VoidCallback? onTapOverride}) {
    final ThemeState theme = getIt<ThemeState>();
    final Color foreground =
        isDestructive ? theme.colors.error600 : theme.colors.neutral700;

    return InkWell(
      onTap: (onTap == null && onTapOverride == null)
          ? null
          : () {
              onTapOverride?.call();
              onTap?.call();
            },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: theme.spacing.spacing4,
          vertical: theme.spacing.spacing12,
        ),
        child: Row(
          children: <Widget>[
            ..._buildLeading(theme, foreground),
            Expanded(
              child: Text(
                label,
                style: theme.textStyle.paragraphDefault
                    .copyWith(color: foreground),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }

  List<Widget> _buildLeading(ThemeState theme, Color foreground) {
    final Widget? resolved = leading ??
        (selected != null
            ? _Radio(selected: selected!)
            : (leadingIcon != null
                ? Icon(leadingIcon, size: 20, color: foreground)
                : null));
    if (resolved == null) {
      return const <Widget>[];
    }
    return <Widget>[resolved, SizedBox(width: theme.spacing.spacing12)];
  }
}

class _Radio extends StatelessWidget {
  const _Radio({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final ThemeState theme = getIt<ThemeState>();
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? theme.colors.brand600 : theme.colors.neutral300,
          width: 2,
        ),
      ),
      alignment: Alignment.center,
      child: selected
          ? Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colors.brand600,
              ),
            )
          : null,
    );
  }
}
