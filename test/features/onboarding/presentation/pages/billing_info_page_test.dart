import 'package:benny_style/buttons/benny_primary_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/router/app_routes.dart';
import 'package:pet_project_flutter_clean_bloc/features/onboarding/presentation/pages/billing_info_page.dart';
import 'package:pet_project_flutter_clean_bloc/features/onboarding/presentation/view_model/billing_info_view_model.dart';

import '../../../../helpers/feature_test_harness.dart';

void main() {
  setUpAll(FeatureTestHarness.bootstrap);

  setUp(() {
    FeatureTestHarness.reset();
    FeatureTestHarness.registerViewModel<BillingInfoViewModel>(
      BillingInfoViewModel.new,
    );
  });

  testWidgets('renders the step header and the finish button', (tester) async {
    await FeatureTestHarness.pumpPage(tester, const BillingInfoPage());

    expect(find.text('onboarding.billing_info'.tr()), findsOneWidget);
    expect(find.text('onboarding.second_step'.tr()), findsOneWidget);
  });

  testWidgets('keeps the finish button disabled while the form is empty',
      (tester) async {
    await FeatureTestHarness.pumpPage(tester, const BillingInfoPage());

    final button = tester.widget<BennyPrimaryButton>(
      find.byType(BennyPrimaryButton),
    );
    expect(button.onPressed, isNull);

    await tester.tap(find.text('onboarding.second_step'.tr()));
    await tester.pumpAndSettle();
    expect(find.text(AppRoutes.main), findsNothing);
  });

  testWidgets('enables and navigates to main on a valid submit',
      (tester) async {
    await FeatureTestHarness.pumpPage(tester, const BillingInfoPage());

    final fields = find.byType(EditableText);
    // Order: name on card, card number, cvc, month, year.
    await tester.enterText(fields.at(0), 'BAO NGUYEN');
    await tester.enterText(fields.at(1), '4242424242424242');
    await tester.enterText(fields.at(2), '123');
    await tester.enterText(fields.at(3), '12');
    await tester.enterText(fields.at(4), '30');
    await tester.pump();

    final button = tester.widget<BennyPrimaryButton>(
      find.byType(BennyPrimaryButton),
    );
    expect(button.onPressed, isNotNull);

    final submit = find.text('onboarding.second_step'.tr());
    await tester.ensureVisible(submit);
    await tester.pump();
    await tester.tap(submit);
    await tester.pumpAndSettle();

    expect(find.text(AppRoutes.main), findsOneWidget);
  });
}
