import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/theme/benny_style_initializer.dart';
import 'package:pet_project_flutter_clean_bloc/features/home/presentation/widgets/quick_actions.dart';

import '../../../../helpers/localization_test_harness.dart';

void main() {
  setUpAll(() async {
    await LocalizationTestHarness.useRealTranslations();
    BennyStyleInitializer.ensureInitialized();
  });

  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('renders the four action labels and icons', (tester) async {
    await tester.pumpWidget(wrap(const QuickActions()));

    expect(find.text('home.action.scan'.tr()), findsOneWidget);
    expect(find.text('home.action.post'.tr()), findsOneWidget);
    expect(find.text('home.action.customers'.tr()), findsOneWidget);
    expect(find.text('home.action.reports'.tr()), findsOneWidget);

    expect(find.byIcon(Icons.qr_code_scanner_rounded), findsOneWidget);
    expect(find.byIcon(Icons.add_home_work_outlined), findsOneWidget);
    expect(find.byIcon(Icons.groups_outlined), findsOneWidget);
    expect(find.byIcon(Icons.insights_outlined), findsOneWidget);
  });

  testWidgets('invokes onScanQr when the scan action is tapped',
      (tester) async {
    var scanned = 0;
    await tester.pumpWidget(wrap(QuickActions(onScanQr: () => scanned++)));

    await tester.tap(find.text('home.action.scan'.tr()));
    expect(scanned, 1);
  });

  testWidgets('non-accent actions with no callback are tappable safely',
      (tester) async {
    await tester.pumpWidget(wrap(const QuickActions()));

    await tester.tap(find.text('home.action.post'.tr()));
    await tester.pump();

    expect(find.text('home.action.post'.tr()), findsOneWidget);
  });
}
