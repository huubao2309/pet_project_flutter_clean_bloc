import 'package:benny_style/buttons/benny_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/constants/mock_assets.dart';
import 'package:pet_project_flutter_clean_bloc/core/di/injection.dart';
import 'package:pet_project_flutter_clean_bloc/core/presentation/widgets/app_text_field.dart';
import 'package:pet_project_flutter_clean_bloc/core/storage/secure_storage/secure_storage.dart';
import 'package:pet_project_flutter_clean_bloc/environments/staging_env.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/pages/otp_page.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/pages/sign_up_page.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/pages/welcome_page.dart';
import 'package:pet_project_flutter_clean_bloc/features/main/presentation/widgets/main_bottom_nav.dart';

import 'helpers/login_flow_harness.dart';

/// End-to-end **regression test for the Sign-up flow** (the happy path + the
/// phone-validation guard).
///
/// Launches the REAL app — real DI graph, real `go_router`, real widgets — and
/// drives it like a user: welcome → "Register" → sign-up form → OTP screen.
/// Determinism comes from the app's built-in fake backend ([AuthMockDataSource]),
/// re-pointed here at the sign-up success scenario (which returns a `verify_otp`
/// challenge) with zero latency.
///
/// One app boot per process (the design system initializes once), so this file
/// holds a single `testWidgets`. The blocked-phone branch lives in
/// `signup_blocked_flow_test.dart`.
///
///   flutter test integration_test/signup_flow_test.dart --flavor staging
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  tearDownAll(() async {
    if (getIt.isRegistered<SecureStorage>()) {
      await getIt<SecureStorage>().clearAll();
    }
  });

  testWidgets(
    'sign-up form requires a valid phone, then routes to OTP verification',
    (tester) async {
      // 1. Launch the real app; a logged-out user lands on the welcome screen.
      StagingEnv();
      await pumpUntil(tester, find.byType(WelcomePage));

      // The fake backend returns a verify_otp challenge for sign-up (instant).
      useSignUpScenario(MockAssets.signupSuccess);

      // 2. Welcome → sign-up form (the filled "Register" CTA is the only
      //    BennyPrimaryButton on the welcome screen).
      await tester.tap(find.byType(BennyPrimaryButton));
      await pumpUntil(tester, find.byType(SignUpPage));

      // 3. Validation guard: an invalid phone flags the field inline and keeps
      //    the "Continue" button disabled — sign-up cannot proceed.
      await tester.enterText(find.byType(EditableText).first, '123');
      await tester.pump();
      final phoneField =
          tester.widget<AppTextField>(find.byType(AppTextField).first);
      expect(phoneField.errorText, isNotNull);
      final disabledButton =
          tester.widget<BennyPrimaryButton>(find.byType(BennyPrimaryButton));
      expect(disabledButton.onPressed, isNull);

      // 4. A valid phone enables the button; submitting calls the backend.
      await tester.enterText(find.byType(EditableText).first, '0901234567');
      await tester.pump();
      final button = find.byType(BennyPrimaryButton);
      await tester.ensureVisible(button);
      await tester.pump();
      await tester.tap(button);
      await tester.pump();

      // 5. Sign-up needs OTP verification → the app routed to the OTP screen
      //    (and definitely not into the authenticated main shell).
      await pumpUntil(tester, find.byType(OtpPage));
      expect(find.byType(OtpPage), findsOneWidget);
      expect(find.byType(MainBottomNav), findsNothing);
    },
  );
}
