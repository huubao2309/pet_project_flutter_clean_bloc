import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/router/app_routes.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/pages/welcome_page.dart';

import '../../../../helpers/feature_test_harness.dart';

void main() {
  setUpAll(FeatureTestHarness.bootstrap);

  setUp(FeatureTestHarness.reset);

  testWidgets('renders the landing copy and CTAs', (tester) async {
    await FeatureTestHarness.pumpPage(tester, const WelcomePage());

    expect(find.text('welcome.title'.tr()), findsOneWidget);
    expect(find.text('welcome.caption'.tr()), findsOneWidget);
    expect(find.text('welcome.register'.tr()), findsOneWidget);
    expect(find.text('welcome.login'.tr()), findsOneWidget);
  });

  testWidgets('register CTA navigates to sign-up', (tester) async {
    await FeatureTestHarness.pumpPage(tester, const WelcomePage());

    await tester.tap(find.text('welcome.register'.tr()));
    await tester.pumpAndSettle();

    expect(find.text(AppRoutes.signUp), findsOneWidget);
  });

  testWidgets('login CTA navigates to login', (tester) async {
    await FeatureTestHarness.pumpPage(tester, const WelcomePage());

    await tester.tap(find.text('welcome.login'.tr()));
    await tester.pumpAndSettle();

    expect(find.text(AppRoutes.login), findsOneWidget);
  });
}
