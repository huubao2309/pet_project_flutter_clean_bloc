import 'package:flutter/material.dart';
import 'package:benny_style/theme/theme_state.dart';

import '../../../di/injection.dart';
import '../app_overlay_action.dart';

/// Lays out a list of [AppOverlayAction]s using the design-system rules shared
/// by dialogs and bottom-sheet footers:
///
/// * 0 actions → nothing.
/// * 1 action  → single full-width button.
/// * 2 actions → side-by-side row, each half-width (secondary on the left).
/// * 3+ actions → full-width buttons stacked vertically.
class AppOverlayActions extends StatelessWidget {
  const AppOverlayActions({required this.actions, super.key});

  final List<AppOverlayAction> actions;

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) {
      return const SizedBox.shrink();
    }

    final ThemeState theme = getIt<ThemeState>();
    final double gap = theme.spacing.spacing12;

    if (actions.length == 1) {
      return actions.first.build(context, expand: true);
    }

    if (actions.length == 2) {
      return Row(
        children: [
          Expanded(child: actions[0].build(context, expand: true)),
          SizedBox(width: gap),
          Expanded(child: actions[1].build(context, expand: true)),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < actions.length; i++) ...[
          if (i > 0) SizedBox(height: gap),
          actions[i].build(context, expand: true),
        ],
      ],
    );
  }
}
