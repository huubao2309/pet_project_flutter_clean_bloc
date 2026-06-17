import 'package:flutter/material.dart';

/// The bottom-navigation tabs hosted by `MainPage`.
///
/// Real-estate sales (CTV) layout: Home, History, a prominent center QR-scan
/// action, Commission (Hoa hồng) and Profile.
enum MainTab {
  home(
    labelKey: 'nav.home',
    icon: Icons.home_outlined,
    activeIcon: Icons.home,
  ),
  history(
    labelKey: 'nav.history',
    icon: Icons.history_outlined,
    activeIcon: Icons.history,
  ),
  qr(
    labelKey: 'nav.qr',
    icon: Icons.qr_code_scanner_rounded,
    activeIcon: Icons.qr_code_scanner_rounded,
    isCenter: true,
  ),
  commission(
    labelKey: 'nav.commission',
    icon: Icons.payments_outlined,
    activeIcon: Icons.payments,
  ),
  profile(
    labelKey: 'nav.profile',
    icon: Icons.person_outline,
    activeIcon: Icons.person,
  );

  const MainTab({
    required this.labelKey,
    required this.icon,
    required this.activeIcon,
    this.isCenter = false,
  });

  /// easy_localization key for the tab label.
  final String labelKey;
  final IconData icon;
  final IconData activeIcon;

  /// When true the tab is rendered as a prominent circular center button.
  final bool isCenter;
}
