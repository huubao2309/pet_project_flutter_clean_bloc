import 'package:benny_style/buttons/benny_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/constants/mock_assets.dart';
import 'package:pet_project_flutter_clean_bloc/core/di/injection.dart';
import 'package:pet_project_flutter_clean_bloc/core/presentation/widgets/app_error_view.dart';
import 'package:pet_project_flutter_clean_bloc/core/storage/secure_storage/secure_storage.dart';
import 'package:pet_project_flutter_clean_bloc/environments/staging_env.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/pages/otp_page.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/pages/sign_up_page.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/pages/welcome_page.dart';

import 'helpers/login_flow_harness.dart';

/// End-to-end regression test for the Sign-up flow's **blocked-phone branch**:
/// when the backend answers with the `phone_is_blocked` verdict, sign-up is a
/// hard stop — the screen shows a full-screen [AppErrorView] instead of routing
/// to OTP.
///
/// Its own file (own process) because the design system initializes once per
/// process, so the real app is bootstrapped exactly once here.
///
///   flutter test integration_test/signup_blocked_flow_test.dart --flavor staging
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  tearDownAll(() async {
    if (getIt.isRegistered<SecureStorage>()) {
      await getIt<SecureStorage>().clearAll();
    }
  });

  testWidgets(
    'a blocked phone shows the full-screen error and never reaches OTP',
    (tester) async {
      StagingEnv();
      await pumpUntil(tester, find.byType(WelcomePage));

      // Fake backend rejects this sign-up with the phone_is_blocked verdict.
      useSignUpScenario(MockAssets.signupIsBlocked);

      await tester.tap(find.byType(BennyPrimaryButton));
      await pumpUntil(tester, find.byType(SignUpPage));

      await tester.enterText(find.byType(EditableText).first, '0901234567');
      await tester.pump();
      final button = find.byType(BennyPrimaryButton);
      await tester.ensureVisible(button);
      await tester.pump();
      await tester.tap(button);
      await tester.pump();

      // Hard stop → full-screen error, no OTP navigation.
      await pumpUntil(tester, find.byType(AppErrorView));
      expect(find.byType(AppErrorView), findsOneWidget);
      expect(find.byType(OtpPage), findsNothing);
    },
  );
}
