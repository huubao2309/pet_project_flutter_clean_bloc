import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/theme/benny_style_initializer.dart';
import 'package:pet_project_flutter_clean_bloc/features/main/presentation/widgets/placeholder_tab_page.dart';

import '../../../../helpers/localization_test_harness.dart';

void main() {
  setUpAll(() async {
    await LocalizationTestHarness.useRealTranslations();
    BennyStyleInitializer.ensureInitialized();
  });

  Widget wrap(Widget child) => MaterialApp(home: child);

  testWidgets('renders title, subtitle, icon and the coming-soon badge',
      (tester) async {
    await tester.pumpWidget(
      wrap(
        const PlaceholderTabPage(
          titleKey: 'nav.history',
          subtitleKey: 'placeholder.history',
          icon: Icons.history_outlined,
        ),
      ),
    );

    expect(find.text('nav.history'.tr()), findsWidgets);
    expect(find.text('placeholder.history'.tr()), findsOneWidget);
    expect(find.text('placeholder.coming_soon'.tr()), findsOneWidget);
    expect(find.byIcon(Icons.history_outlined), findsOneWidget);
  });

  testWidgets('omits the subtitle when subtitleKey is null', (tester) async {
    await tester.pumpWidget(
      wrap(
        const PlaceholderTabPage(
          titleKey: 'nav.qr',
          icon: Icons.qr_code_scanner_rounded,
        ),
      ),
    );

    expect(find.text('nav.qr'.tr()), findsWidgets);
    expect(find.text('placeholder.coming_soon'.tr()), findsOneWidget);
  });

  testWidgets('uses the amber accent when accent is true', (tester) async {
    await tester.pumpWidget(
      wrap(
        const PlaceholderTabPage(
          titleKey: 'nav.commission',
          subtitleKey: 'placeholder.commission',
          icon: Icons.payments_outlined,
          accent: true,
        ),
      ),
    );

    expect(find.text('nav.commission'.tr()), findsWidgets);
    expect(find.byIcon(Icons.payments_outlined), findsOneWidget);
  });
}
