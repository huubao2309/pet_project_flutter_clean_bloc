import 'package:benny_style/theme/theme_state.dart';
import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';

/// White rounded card that groups [ProfileTile]s, separating them with thin
/// dividers.
class ProfileGroup extends StatelessWidget {
  const ProfileGroup({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();

    return Container(
      decoration: BoxDecoration(
        color: theme.colors.white,
        borderRadius: BorderRadius.circular(theme.borderRadius.borderRadius16),
        border: Border.all(color: theme.colors.neutral100),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            children[i],
            if (i != children.length - 1)
              Divider(height: 1, thickness: 1, color: theme.colors.neutral100),
          ],
        ],
      ),
    );
  }
}
