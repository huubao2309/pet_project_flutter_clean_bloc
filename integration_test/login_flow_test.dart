import 'package:benny_style/buttons/benny_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/constants/mock_assets.dart';
import 'package:pet_project_flutter_clean_bloc/core/di/injection.dart';
import 'package:pet_project_flutter_clean_bloc/core/presentation/widgets/app_text_field.dart';
import 'package:pet_project_flutter_clean_bloc/core/storage/secure_storage/secure_storage.dart';
import 'package:pet_project_flutter_clean_bloc/environments/staging_env.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/pages/login_page.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/pages/welcome_page.dart';
import 'package:pet_project_flutter_clean_bloc/features/main/presentation/widgets/main_bottom_nav.dart';

import 'helpers/login_flow_harness.dart';

/// End-to-end **regression test for the Login flow** (the happy path + the
/// client-side validation guard).
///
/// Unlike the widget/unit tests under `test/` (which mock at a layer boundary),
/// this launches the REAL app — real DI graph (`configureDependencies`), real
/// `go_router`, real navigation guard, real widgets — and drives it the way a
/// user would: splash → welcome → login form → main screen. Determinism comes
/// from the app's built-in fake backend ([AuthMockDataSource], wired by default
/// in DI), re-pointed here at the success scenario with zero latency.
///
/// NOTE: the design system ([BennyStyle.initData]) can only be initialized once
/// per process, so the app is bootstrapped exactly once per test file. The OTP
/// branch lives in its own file (`login_otp_flow_test.dart`) so it gets a fresh
/// process and its own single boot.
///
/// Run on a connected device or emulator:
///   flutter test integration_test/login_flow_test.dart --flavor staging
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  tearDownAll(() async {
    // Leave the device clean: drop the token the successful login persisted.
    if (getIt.isRegistered<SecureStorage>()) {
      await getIt<SecureStorage>().clearAll();
    }
  });

  testWidgets(
    'login form blocks an empty submit, then signs in and reaches main',
    (tester) async {
      // 1. Launch the real app; a logged-out user lands on the welcome screen.
      StagingEnv();
      await pumpUntil(tester, find.byType(WelcomePage));

      // Point the fake backend at the success scenario (instant response). Safe
      // here: the login object graph is lazy and only resolved on the login page.
      useLoginScenario(MockAssets.loginSuccess);

      // 2. Welcome → login form (the only OutlinedButton is the "Login" CTA).
      await tester.tap(find.byType(OutlinedButton));
      await pumpUntil(tester, find.byType(LoginPage));

      // 3. Validation guard: an empty submit stays on the form and flags the
      //    phone field inline — the backend is never called.
      await tapLogin(tester);
      expect(find.byType(LoginPage), findsOneWidget);
      expect(find.byType(MainBottomNav), findsNothing);
      final phoneField =
          tester.widget<AppTextField>(find.byType(AppTextField).first);
      expect(phoneField.errorText, isNotNull);

      // 4. Enter valid credentials and submit (the fake backend ignores the
      //    values; the form still enforces the 10-digit phone rule).
      final fields = find.byType(EditableText);
      await tester.enterText(fields.first, '0901234567');
      await tester.enterText(fields.last, 'Password123!');
      await tester.pump();
      await tapLogin(tester);

      // 5. Login succeeded → the app navigated to the main shell.
      await pumpUntil(tester, find.byType(MainBottomNav));
      expect(find.byType(MainBottomNav), findsOneWidget);

      // Let the route transition finish, then confirm the login screen is gone.
      for (var i = 0; i < 8; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(find.byType(LoginPage), findsNothing);
    },
  );
}

/// Scrolls the login button into view and taps it.
Future<void> tapLogin(WidgetTester tester) async {
  final button = find.byType(BennyPrimaryButton);
  await tester.ensureVisible(button);
  await tester.pump();
  await tester.tap(button);
  await tester.pump();
}
