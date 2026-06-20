import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/presentation/presentation.dart';
import '../../../../core/presentation/widgets/lazy_load_indexed_stack.dart';
import '../../../../core/router/app_routes.dart';
import '../../../commission/presentation/pages/commission_page.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../profile/presentation/view_model/profile_view_model.dart';
import '../main_tab.dart';
import '../view_model/main_view_model.dart';
import '../widgets/main_bottom_nav.dart';
import '../widgets/placeholder_tab_page.dart';

/// Main screen — entry point after login. Hosts the bottom-navigation tabs in
/// a [LazyLoadIndexedStack] so each tab keeps its state while switching.
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  static const _tabScreens = <MainTab, Widget>{
    MainTab.home: HomePage(),
    MainTab.history: PlaceholderTabPage(
      titleKey: 'nav.history',
      subtitleKey: 'placeholder.history',
      icon: Icons.history_outlined,
    ),
    // The QR tab never renders as a page — tapping its center button pushes the
    // full-screen scanner route instead (see [_MainView]). This entry is a
    // harmless stand-in to keep the IndexedStack aligned with the tab list.
    MainTab.qr: SizedBox.shrink(),
    MainTab.commission: CommissionPage(),
    MainTab.profile: ProfilePage(),
  };

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<MainViewModel>(
      create: (_) => getIt<MainViewModel>(),
      // Provided above the tabs so the Profile tab reads the same instance.
      // Loading the profile here means the API is called as soon as the main
      // screen opens, before the user reaches the Profile tab.
      child: ViewModelProvider<ProfileViewModel>(
        create: (_) => getIt<ProfileViewModel>()..loadProfile(),
        child: const _MainView(),
      ),
    );
  }
}

class _MainView extends StatelessWidget {
  const _MainView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.viewModel<MainViewModel>();
    final tabs = viewModel.tabs;

    return ViewModelBuilder<MainViewModel, int>(
      builder: (context, index) => Scaffold(
        body: LazyLoadIndexedStack(
          index: index,
          children: [
            for (final tab in tabs)
              MainPage._tabScreens[tab] ?? const SizedBox.shrink(),
          ],
        ),
        bottomNavigationBar: MainBottomNav(
          tabs: tabs,
          currentIndex: index,
          onTap: (i) => _onTabTapped(context, tabs, viewModel, i),
        ),
      ),
    );
  }

  /// The center QR tab opens the scanner as a pushed route rather than a tab;
  /// every other tab switches the IndexedStack.
  void _onTabTapped(
    BuildContext context,
    List<MainTab> tabs,
    MainViewModel viewModel,
    int index,
  ) {
    if (index < 0 || index >= tabs.length) {
      return;
    }
    if (tabs[index] == MainTab.qr) {
      context.push(AppRoutes.qrScan);
      return;
    }
    viewModel.changeTab(index);
  }
}
