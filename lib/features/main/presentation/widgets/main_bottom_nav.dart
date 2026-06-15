import 'package:benny_style/theme/theme_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../main_tab.dart';

/// Custom 5-item bottom navigation with a prominent circular center action
/// (QR), following the original fintech layout. Themed via [ThemeState].
class MainBottomNav extends StatelessWidget {
  const MainBottomNav({
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final List<MainTab> tabs;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colors.white,
        boxShadow: [
          BoxShadow(
            color: theme.colors.neutral900.withAlpha((255.0 * 0.08).round()),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              for (var i = 0; i < tabs.length; i++)
                if (tabs[i].isCenter)
                  _CenterItem(
                    tab: tabs[i],
                    onTap: () => onTap(i),
                    theme: theme,
                  )
                else
                  _NavItem(
                    tab: tabs[i],
                    isActive: i == currentIndex,
                    onTap: () => onTap(i),
                    theme: theme,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.tab,
    required this.isActive,
    required this.onTap,
    required this.theme,
  });

  final MainTab tab;
  final bool isActive;
  final VoidCallback onTap;
  final ThemeState theme;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? theme.colors.brand400 : theme.colors.neutral400;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isActive ? tab.activeIcon : tab.icon, color: color, size: 24),
            const SizedBox(height: 2),
            Text(tab.labelKey.tr(), style: TextStyle(fontSize: 11, color: color)),
          ],
        ),
      ),
    );
  }
}

class _CenterItem extends StatelessWidget {
  const _CenterItem({
    required this.tab,
    required this.onTap,
    required this.theme,
  });

  final MainTab tab;
  final VoidCallback onTap;
  final ThemeState theme;

  @override
  Widget build(BuildContext context) {
    final primary = theme.colors.brand400;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primary.withAlpha((255.0 * 0.35).round()),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(tab.icon, color: theme.colors.white, size: 22),
            ),
            Text(
              tab.labelKey.tr(),
              style: TextStyle(fontSize: 11, color: primary),
            ),
          ],
        ),
      ),
    );
  }
}
