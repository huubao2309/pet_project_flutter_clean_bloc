import 'package:benny_style/buttons/base_button_type.dart';
import 'package:benny_style/buttons/icon_button/benny_ghost_icon_button.dart';
import 'package:benny_style/generated/assets.gen.dart';
import 'package:benny_style/theme/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../di/injection.dart';
import '../../theme/app_theme_mode.dart';
import '../../theme/theme_view_model.dart';
import '../presentation.dart';

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
    // Rebuild on Light/Dark changes by listening to [ThemeViewModel] — the
    // source of truth, provided ABOVE MaterialApp so it survives the
    // theme-toggle MaterialApp recreation. We deliberately do NOT key off
    // `Theme.of(context)`: the root navigator uses a GlobalKey, so its pages
    // are preserved (reparented) on a toggle and their ambient `Theme` can lag
    // behind the swapped `getIt<ThemeState>().colors`, leaving the icon a stale
    // (dark) colour while the rest of the page is already light. Reading the
    // palette from the same `getIt<ThemeState>()` the page uses keeps them
    // consistent; the [ViewModelBuilder] guarantees this bar rebuilds after the
    // ancestor swaps the palette.
    return ViewModelBuilder<ThemeViewModel, AppThemeMode>(
      builder: (context, _) {
        final theme = getIt<ThemeState>();
        final colors = theme.colors;

        return AppBar(
          backgroundColor: backgroundColor ?? colors.surfaceBackground,
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
                border: Border.all(color: colors.neutral200),
                borderRadius:
                    BorderRadius.circular(theme.borderRadius.borderRadius8),
              ),
              clipBehavior: Clip.hardEdge,
              child: BennyGhostIconButton(
                type: BaseButtonType.neutral,
                size: 44,
                svgIconName: Assets.svg.icDirectionLeft.keyName,
                // Swappable token so the icon flips with Light/Dark mode (the
                // type-derived colour reads the package's fixed light ramp).
                iconColor: colors.neutral700,
                onPressed: () => _handleBack(context),
              ),
            ),
          ),
          actions: actions,
        );
      },
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
