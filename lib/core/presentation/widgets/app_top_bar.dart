import 'package:benny_style/buttons/base_button_type.dart';
import 'package:benny_style/buttons/icon_button/benny_ghost_icon_button.dart';
import 'package:benny_style/generated/assets.gen.dart';
import 'package:benny_style/theme/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../di/injection.dart';

/// Shared app bar used across screens that need one: a single back button,
/// no title. Implements [PreferredSizeWidget] so it drops straight into
/// `Scaffold(appBar: const AppTopBar())`.
///
/// Inspired by the source app's `AppScaffold`, but trimmed to just the back
/// affordance and themed via the design system.
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({this.onBack, this.actions, this.backgroundColor, super.key});

  /// Custom back handler. Defaults to popping the current route.
  final VoidCallback? onBack;

  /// Optional trailing widgets (e.g. a language switcher).
  final List<Widget>? actions;

  final Color? backgroundColor;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();

    return AppBar(
      backgroundColor: backgroundColor ?? theme.colors.neutral25,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      leadingWidth: 44 + theme.spacing.spacing12,
      leading: Padding(
        padding: EdgeInsets.only(left: theme.spacing.spacing12),
        child: Container(
          // Bordered frame around the back icon.
          decoration: BoxDecoration(
            border: Border.all(color: theme.colors.neutral200),
            borderRadius:
                BorderRadius.circular(theme.borderRadius.borderRadius8),
          ),
          clipBehavior: Clip.hardEdge,
          child: BennyGhostIconButton(
            type: BaseButtonType.neutral,
            size: 44,
            svgIconName: Assets.svg.icDirectionLeft.keyName,
            onPressed: () => _handleBack(context),
          ),
        ),
      ),
      actions: actions,
    );
  }

  void _handleBack(BuildContext context) {
    if (onBack != null) {
      onBack!();
      return;
    }
    if (context.canPop()) {
      context.pop();
    }
  }
}
