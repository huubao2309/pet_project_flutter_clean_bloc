import 'package:flutter/material.dart';

/// The bottom-navigation tabs hosted by `MainPage`.
///
/// Mirrors the original 5-tab fintech layout: Home, History, a prominent
/// center QR action, Promotion and Profile.
enum MainTab {
  home(
    labelKey: 'nav.home',
    icon: Icons.home_outlined,
    activeIcon: Icons.home,
  ),
  history(
    labelKey: 'nav.history',
    icon: Icons.receipt_long_outlined,
    activeIcon: Icons.receipt_long,
  ),
  qr(
    labelKey: 'nav.qr',
    icon: Icons.qr_code_scanner,
    activeIcon: Icons.qr_code_scanner,
    isCenter: true,
  ),
  promotion(
    labelKey: 'nav.promotion',
    icon: Icons.local_offer_outlined,
    activeIcon: Icons.local_offer,
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
