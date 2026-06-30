import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/theme/benny_style_initializer.dart';
import 'package:pet_project_flutter_clean_bloc/features/main/presentation/main_tab.dart';
import 'package:pet_project_flutter_clean_bloc/features/main/presentation/widgets/main_bottom_nav.dart';

import '../../../../helpers/localization_test_harness.dart';

void main() {
  setUpAll(() async {
    await LocalizationTestHarness.useRealTranslations();
    BennyStyleInitializer.ensureInitialized();
  });

  const tabs = MainTab.values;

  Widget wrap(Widget child) => MaterialApp(home: Scaffold(bottomNavigationBar: child));

  testWidgets('renders a label for every tab (active + inactive items)',
      (tester) async {
    await tester.pumpWidget(
      wrap(
        MainBottomNav(tabs: tabs, currentIndex: 0, onTap: (_) {}),
      ),
    );

    for (final tab in tabs) {
      expect(find.text(tab.labelKey.tr()), findsOneWidget);
    }
  });

  testWidgets('fires onTap with the index of a side nav item', (tester) async {
    int? tapped;
    await tester.pumpWidget(
      wrap(
        MainBottomNav(tabs: tabs, currentIndex: 0, onTap: (i) => tapped = i),
      ),
    );

    await tester.tap(find.text(MainTab.profile.labelKey.tr()));
    expect(tapped, tabs.indexOf(MainTab.profile));
  });

  testWidgets('fires onTap with the index of the center QR button',
      (tester) async {
    int? tapped;
    await tester.pumpWidget(
      wrap(
        MainBottomNav(tabs: tabs, currentIndex: 0, onTap: (i) => tapped = i),
      ),
    );

    await tester.tap(find.text(MainTab.qr.labelKey.tr()));
    expect(tapped, tabs.indexOf(MainTab.qr));
  });

  testWidgets('renders the active icon for the current index', (tester) async {
    await tester.pumpWidget(
      wrap(
        MainBottomNav(
          tabs: tabs,
          currentIndex: tabs.indexOf(MainTab.profile),
          onTap: (_) {},
        ),
      ),
    );

    // Active profile tab uses its filled icon; another side tab the outlined.
    expect(find.byIcon(MainTab.profile.activeIcon), findsOneWidget);
    expect(find.byIcon(MainTab.home.icon), findsOneWidget);
  });
}
