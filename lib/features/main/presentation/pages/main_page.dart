import 'package:flutter/material.dart';

/// Main screen — entry point after login.
///
/// Hosts 5 tabs in a [BottomNavigationBar]:
///   0 Trang chủ  |  1 Lịch sử  |  2 Quét QR (center/prominent)
///   3 Khuyến mãi  |  4 Hồ sơ
///
/// [IndexedStack] keeps every tab alive while switching so state is not lost.
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0; // Start on Home tab

  static const _pages = <Widget>[
    _TabBody(label: 'Trang chủ'),
    _TabBody(label: 'Lịch sử vay'),
    _TabBody(label: 'Quét QR'),
    _TabBody(label: 'Khuyến mãi'),
    _TabBody(label: 'Hồ sơ'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

// ── Tab content ────────────────────────────────────────────────────────────

/// Placeholder widget shown in the center of each tab.
/// Replace with the real feature widget when implementing each tab.
class _TabBody extends StatelessWidget {
  const _TabBody({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(label, style: Theme.of(context).textTheme.titleLarge),
    );
  }
}

// ── Bottom navigation ──────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
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
              _NavItem(
                index: 0,
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Trang chủ',
                currentIndex: currentIndex,
                onTap: onTap,
              ),
              _NavItem(
                index: 1,
                icon: Icons.receipt_long_outlined,
                activeIcon: Icons.receipt_long,
                label: 'Lịch sử',
                currentIndex: currentIndex,
                onTap: onTap,
              ),
              _QrNavItem(
                index: 2,
                currentIndex: currentIndex,
                onTap: onTap,
              ),
              _NavItem(
                index: 3,
                icon: Icons.local_offer_outlined,
                activeIcon: Icons.local_offer,
                label: 'Khuyến mãi',
                currentIndex: currentIndex,
                onTap: onTap,
              ),
              _NavItem(
                index: 4,
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Hồ sơ',
                currentIndex: currentIndex,
                onTap: onTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Regular nav item ───────────────────────────────────────────────────────

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.index,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.currentIndex,
    required this.onTap,
  });

  final int index;
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final isActive = currentIndex == index;
    final color =
        isActive ? Theme.of(context).colorScheme.primary : Colors.grey;

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isActive ? activeIcon : icon, color: color, size: 24),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 11, color: color)),
          ],
        ),
      ),
    );
  }
}

// ── QR center nav item (prominent) ────────────────────────────────────────

/// The center tab has a circular button that is larger than the other items,
/// following the common fintech bottom-nav pattern.
class _QrNavItem extends StatelessWidget {
  const _QrNavItem({
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  final int index;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
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
                    color: primary.withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.qr_code_scanner,
                color: Colors.white,
                size: 22,
              ),
            ),
            Text(
              'Quét QR',
              style: TextStyle(fontSize: 11, color: primary),
            ),
          ],
        ),
      ),
    );
  }
}
