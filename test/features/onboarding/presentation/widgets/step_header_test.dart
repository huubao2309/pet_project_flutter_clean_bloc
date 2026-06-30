import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/theme/benny_style_initializer.dart';
import 'package:pet_project_flutter_clean_bloc/features/onboarding/presentation/widgets/step_header.dart';

import '../../../../helpers/localization_test_harness.dart';

void main() {
  setUpAll(() async {
    await LocalizationTestHarness.useRealTranslations();
    BennyStyleInitializer.ensureInitialized();
  });

  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('renders the title and the current/total step badge',
      (tester) async {
    await tester.pumpWidget(
      wrap(
        const StepHeader(title: 'Personal info', currentStep: 1, totalStep: 2),
      ),
    );

    expect(find.text('Personal info'), findsOneWidget);
    expect(find.text('1/2'), findsOneWidget);
  });

  testWidgets('reflects a different step position', (tester) async {
    await tester.pumpWidget(
      wrap(
        const StepHeader(title: 'Billing', currentStep: 2, totalStep: 2),
      ),
    );

    expect(find.text('Billing'), findsOneWidget);
    expect(find.text('2/2'), findsOneWidget);
  });
}
