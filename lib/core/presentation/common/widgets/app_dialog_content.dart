import 'package:flutter/material.dart';
import 'package:benny_style/theme/theme_state.dart';

import '../../../di/injection.dart';
import '../app_overlay_action.dart';
import 'app_overlay_actions.dart';
import 'app_overlay_icon.dart';

/// The white card body of a dialog (design §13): optional icon → title →
/// message / custom content → actions. Radius 16, centred text.
///
/// All fields optional — render only what is supplied.
class AppDialogContent extends StatelessWidget {
  const AppDialogContent({
    super.key,
    this.icon,
    this.iconType,
    this.title,
    this.message,
    this.content,
    this.actions,
    this.padding,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.textAlign = TextAlign.center,
  });

  /// Custom icon widget; overrides [iconType] when both are set.
  final Widget? icon;

  /// Preset icon style (tinted circle + glyph).
  final AppOverlayIconType? iconType;

  final String? title;
  final String? message;

  /// Arbitrary content shown below [message] (e.g. a form, a list).
  final Widget? content;

  final List<AppOverlayAction>? actions;
  final EdgeInsets? padding;
  final CrossAxisAlignment crossAxisAlignment;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final ThemeState theme = getIt<ThemeState>();
    final List<Widget> children = _buildChildren(theme);

    return Material(
      color: theme.colors.white,
      borderRadius: BorderRadius.circular(theme.borderRadius.borderRadius16),
      child: Padding(
        padding: padding ?? EdgeInsets.all(theme.spacing.spacing24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: crossAxisAlignment,
          children: children,
        ),
      ),
    );
  }

  List<Widget> _buildChildren(ThemeState theme) {
    final List<Widget> children = <Widget>[];

    final Widget? resolvedIcon =
        icon ?? (iconType != null ? AppOverlayIcon(type: iconType!) : null);
    if (resolvedIcon != null) {
      children.add(Center(child: resolvedIcon));
      children.add(SizedBox(height: theme.spacing.spacing16));
    }

    if (title != null) {
      children.add(
        Text(
          title!,
          textAlign: textAlign,
          style: theme.textStyle.heading.copyWith(
            color: theme.colors.brand800,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    if (message != null) {
      if (title != null) {
        children.add(SizedBox(height: theme.spacing.spacing8));
      }
      children.add(
        Text(
          message!,
          textAlign: textAlign,
          style: theme.textStyle.paragraphDefault
              .copyWith(color: theme.colors.neutral600),
        ),
      );
    }

    if (content != null) {
      if (children.isNotEmpty) {
        children.add(SizedBox(height: theme.spacing.spacing16));
      }
      children.add(content!);
    }

    final List<AppOverlayAction> acts = actions ?? const <AppOverlayAction>[];
    if (acts.isNotEmpty) {
      if (children.isNotEmpty) {
        children.add(SizedBox(height: theme.spacing.spacing24));
      }
      children.add(AppOverlayActions(actions: acts));
    }

    return children;
  }
}
