import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/presentation/widgets/language_switcher.dart';

import '../../../helpers/localization_test_harness.dart';

void main() {
  setUpAll(LocalizationTestHarness.useRealTranslations);

  testWidgets('renders a language button with the globe icon', (tester) async {
    await tester.pumpWidget(
      LocalizationTestHarness.wrap(
        const MaterialApp(home: Scaffold(body: LanguageSwitcher())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(LanguageSwitcher), findsOneWidget);
    expect(find.byIcon(Icons.language), findsOneWidget);
    // The label resolves the current locale via `.tr()` ('vi' under the harness).
    expect(find.text('language.vi'.tr()), findsOneWidget);
  });
}
