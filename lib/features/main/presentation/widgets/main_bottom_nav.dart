import 'package:benny_style/theme/theme_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../main_tab.dart';

/// Custom 5-item bottom navigation with a prominent circular center action
/// (QR scan) that floats above the bar in the brand's amber accent. Side items
/// switch between navy (active) and neutral (inactive). Themed via [ThemeState].
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
            color: theme.colors.neutral900.withAlpha((255 * 0.08).round()),
            blurRadius: 16,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
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
    final color = isActive ? theme.colors.brand600 : theme.colors.neutral400;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(theme.borderRadius.borderRadius16),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isActive ? tab.activeIcon : tab.icon,
                color: color,
                size: 24,
              ),
              const SizedBox(height: 3),
              Text(
                tab.labelKey.tr(),
                style: theme.textStyle.captionDefault.copyWith(
                  color: color,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
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
    final accent = theme.colors.secondary500;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [theme.colors.secondary400, accent],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(color: theme.colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: accent.withAlpha((255 * 0.45).round()),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(tab.icon, color: theme.colors.onColor, size: 28),
              ),
              const SizedBox(height: 2),
              Text(
                tab.labelKey.tr(),
                style: theme.textStyle.captionDefault.copyWith(
                  color: theme.colors.secondary700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
