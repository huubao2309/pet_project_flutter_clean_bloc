import 'package:benny_style/buttons/benny_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/constants/mock_assets.dart';
import 'package:pet_project_flutter_clean_bloc/core/di/injection.dart';
import 'package:pet_project_flutter_clean_bloc/core/storage/secure_storage/secure_storage.dart';
import 'package:pet_project_flutter_clean_bloc/environments/staging_env.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/pages/login_page.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/pages/otp_page.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/pages/welcome_page.dart';
import 'package:pet_project_flutter_clean_bloc/features/main/presentation/widgets/main_bottom_nav.dart';

import 'helpers/login_flow_harness.dart';

/// End-to-end regression test for the Login flow's **OTP branch**: when the
/// backend answers a login with `challenge_type: "verify_otp"`, the user must
/// pass an OTP step before a session is granted — so they are routed to the OTP
/// screen rather than straight to main.
///
/// Lives in its own file (and therefore its own test process) because the
/// design system can only be initialized once per process, so the real app is
/// bootstrapped exactly once here.
///
///   flutter test integration_test/login_otp_flow_test.dart --flavor staging
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  tearDownAll(() async {
    if (getIt.isRegistered<SecureStorage>()) {
      await getIt<SecureStorage>().clearAll();
    }
  });

  testWidgets(
    'an OTP challenge routes the user to the OTP screen, not to main',
    (tester) async {
      StagingEnv();
      await pumpUntil(tester, find.byType(WelcomePage));

      // Fake backend returns a verify_otp challenge for this login.
      useLoginScenario(MockAssets.loginNeedVerifyOtp);

      await tester.tap(find.byType(OutlinedButton));
      await pumpUntil(tester, find.byType(LoginPage));

      final fields = find.byType(EditableText);
      await tester.enterText(fields.first, '0901234567');
      await tester.enterText(fields.last, 'Password123!');
      await tester.pump();

      final button = find.byType(BennyPrimaryButton);
      await tester.ensureVisible(button);
      await tester.pump();
      await tester.tap(button);
      await tester.pump();

      // challenge_type "verify_otp" → stop at the OTP screen; never reach main.
      await pumpUntil(tester, find.byType(OtpPage));
      expect(find.byType(OtpPage), findsOneWidget);
      expect(find.byType(MainBottomNav), findsNothing);
    },
  );
}
