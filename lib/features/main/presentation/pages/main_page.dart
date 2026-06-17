import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/presentation/presentation.dart';
import '../../../../core/presentation/widgets/lazy_load_indexed_stack.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../settings/presentation/pages/settings_page.dart';
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
    MainTab.qr: PlaceholderTabPage(
      titleKey: 'nav.qr',
      subtitleKey: 'placeholder.qr',
      icon: Icons.qr_code_scanner_rounded,
      accent: true,
    ),
    MainTab.commission: PlaceholderTabPage(
      titleKey: 'nav.commission',
      subtitleKey: 'placeholder.commission',
      icon: Icons.payments_outlined,
    ),
    MainTab.profile: SettingsPage(),
  };

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<MainViewModel>(
      create: (_) => getIt<MainViewModel>(),
      child: const _MainView(),
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
          onTap: viewModel.changeTab,
        ),
      ),
    );
  }
}
