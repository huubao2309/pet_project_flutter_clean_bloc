import 'package:benny_style/buttons/benny_primary_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/router/app_routes.dart';
import 'package:pet_project_flutter_clean_bloc/features/onboarding/presentation/pages/personal_info_page.dart';
import 'package:pet_project_flutter_clean_bloc/features/onboarding/presentation/view_model/personal_info_view_model.dart';

import '../../../../helpers/feature_test_harness.dart';

void main() {
  setUpAll(FeatureTestHarness.bootstrap);

  setUp(() {
    FeatureTestHarness.reset();
    FeatureTestHarness.registerViewModel<PersonalInfoViewModel>(
      PersonalInfoViewModel.new,
    );
  });

  testWidgets('renders the step header and the continue button', (tester) async {
    await FeatureTestHarness.pumpPage(tester, const PersonalInfoPage());

    expect(find.text('onboarding.personal_info'.tr()), findsOneWidget);
    expect(find.text('onboarding.first_step'.tr()), findsOneWidget);
  });

  testWidgets('keeps the continue button disabled while the form is empty',
      (tester) async {
    await FeatureTestHarness.pumpPage(tester, const PersonalInfoPage());

    final button = tester.widget<BennyPrimaryButton>(
      find.byType(BennyPrimaryButton),
    );
    expect(button.onPressed, isNull);

    // Tapping a disabled button must not navigate.
    await tester.tap(find.text('onboarding.first_step'.tr()));
    await tester.pumpAndSettle();
    expect(find.text(AppRoutes.billingInfo), findsNothing);
  });

  testWidgets('enables and navigates to billing info on a valid submit',
      (tester) async {
    await FeatureTestHarness.pumpPage(tester, const PersonalInfoPage());

    final fields = find.byType(EditableText);
    // Order: first name, last name, phone, address.
    await tester.enterText(fields.at(0), 'Bao');
    await tester.enterText(fields.at(1), 'Nguyen');
    await tester.enterText(fields.at(2), '0900000000');
    await tester.enterText(fields.at(3), '123 Le Loi');
    await tester.pump();

    final button = tester.widget<BennyPrimaryButton>(
      find.byType(BennyPrimaryButton),
    );
    expect(button.onPressed, isNotNull);

    final submit = find.text('onboarding.first_step'.tr());
    await tester.ensureVisible(submit);
    await tester.pump();
    await tester.tap(submit);
    await tester.pumpAndSettle();

    expect(find.text(AppRoutes.billingInfo), findsOneWidget);
  });

  testWidgets('selects the professional plan', (tester) async {
    await FeatureTestHarness.pumpPage(tester, const PersonalInfoPage());

    await tester.tap(find.text('onboarding.professional_plan'.tr()));
    await tester.pump();

    expect(find.text('onboarding.professional_plan'.tr()), findsOneWidget);
  });
}
