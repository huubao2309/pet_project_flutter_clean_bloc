import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_project_flutter_clean_bloc/core/error/app_exception.dart';
import 'package:pet_project_flutter_clean_bloc/core/router/app_routes.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/entities/verify_otp_result.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/use_cases/verify_otp_use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/pages/otp_page.dart';

import '../../../../helpers/feature_test_harness.dart';

class _MockVerifyOtpUseCase extends Mock implements VerifyOtpUseCase {}

const _code = '123456';

void main() {
  late _MockVerifyOtpUseCase verifyOtpUseCase;

  setUpAll(FeatureTestHarness.bootstrap);

  setUp(() {
    verifyOtpUseCase = _MockVerifyOtpUseCase();
    FeatureTestHarness.reset();
    FeatureTestHarness.registerViewModel<VerifyOtpUseCase>(
      () => verifyOtpUseCase,
    );
  });

  Future<void> enterCode(WidgetTester tester) async {
    await tester.enterText(find.byType(EditableText).first, _code);
    await tester.pump();
  }

  testWidgets('renders the OTP form with the countdown and resend row',
      (tester) async {
    await FeatureTestHarness.pumpPage(
      tester,
      const OtpPage(phone: '0900000000', resendSecs: 60, enableResendSecs: 5),
    );

    expect(find.text('auth.otp.title'.tr()), findsOneWidget);
    expect(find.text('auth.otp.verify'.tr()), findsOneWidget);
    expect(find.text('auth.otp.no_code'.tr()), findsOneWidget);
    // Resend disabled while the cooldown runs.
    expect(
      find.text('auth.otp.resend_in'.tr(namedArgs: {'seconds': '5'})),
      findsOneWidget,
    );
  });

  testWidgets('uses client-side defaults when no timers are supplied',
      (tester) async {
    await FeatureTestHarness.pumpPage(tester, const OtpPage(phone: '0123'));

    // With no backend timers the screen keeps the client-side default cooldown
    // (OtpTimerConfig.defaultResendCooldownSeconds), so "resend" starts disabled
    // and the countdown label shows that default.
    expect(
      find.text('auth.otp.resend_in'.tr(namedArgs: {'seconds': '30'})),
      findsOneWidget,
    );
  });

  testWidgets('register_password result routes to register-password',
      (tester) async {
    when(() => verifyOtpUseCase.execute(any()))
        .thenAnswer((_) async => const VerifyOtpRegisterPassword());

    await FeatureTestHarness.pumpPage(
      tester,
      const OtpPage(phone: '0900000000', resendSecs: 60, enableResendSecs: 5),
    );
    await enterCode(tester);
    // onCompleted fires verify automatically once 6 digits are entered.
    await tester.pump();
    await tester.pump();

    verify(() => verifyOtpUseCase.execute(_code)).called(1);
    expect(find.text(AppRoutes.registerPassword), findsOneWidget);
  });

  testWidgets('reset_password result routes to reset-password', (tester) async {
    when(() => verifyOtpUseCase.execute(any()))
        .thenAnswer((_) async => const VerifyOtpResetPassword());

    await FeatureTestHarness.pumpPage(
      tester,
      const OtpPage(phone: '0900000000', resendSecs: 60, enableResendSecs: 5),
    );
    await enterCode(tester);
    await tester.pump();
    await tester.pump();

    expect(find.text(AppRoutes.resetPassword), findsOneWidget);
  });

  testWidgets('authenticated result routes to main', (tester) async {
    when(() => verifyOtpUseCase.execute(any()))
        .thenAnswer((_) async => const VerifyOtpAuthenticated());

    await FeatureTestHarness.pumpPage(
      tester,
      const OtpPage(phone: '0900000000', resendSecs: 60, enableResendSecs: 5),
    );
    await enterCode(tester);
    await tester.pump();
    await tester.pump();

    expect(find.text(AppRoutes.main), findsOneWidget);
  });

  testWidgets('shows the invalid-code error on a wrong attempt',
      (tester) async {
    when(() => verifyOtpUseCase.execute(any()))
        .thenThrow(ServerException(message: 'nope'));

    await FeatureTestHarness.pumpPage(
      tester,
      const OtpPage(phone: '0900000000', resendSecs: 60, enableResendSecs: 5),
    );
    await tester.tap(find.text('auth.otp.no_code'.tr())); // dismiss focus
    await enterCode(tester);
    await tester.pump();
    await tester.pump();

    expect(find.text('auth.otp.error_invalid'.tr()), findsOneWidget);
  });

  testWidgets('locks the screen after too many wrong attempts',
      (tester) async {
    when(() => verifyOtpUseCase.execute(any()))
        .thenThrow(ServerException(message: 'nope'));

    await FeatureTestHarness.pumpPage(
      tester,
      const OtpPage(phone: '0900000000', resendSecs: 60, enableResendSecs: 5),
    );

    // Default maxAttempts is 5 — drive enough wrong verifies to lock.
    for (var i = 0; i < 5; i++) {
      await tester.enterText(find.byType(EditableText).first, '');
      await tester.pump();
      await tester.enterText(find.byType(EditableText).first, _code);
      await tester.pump();
      await tester.pump();
    }

    expect(find.text('auth.lock.title'.tr()), findsOneWidget);

    // The lock view's back button returns to login. The countdown timer is
    // cancelled once locked, so pumpAndSettle is safe to flush the navigation.
    await tester.tap(find.text('auth.lock.back'.tr()));
    await tester.pumpAndSettle();
    expect(find.text(AppRoutes.login), findsOneWidget);
  });

  testWidgets('counts down and expires the code', (tester) async {
    await FeatureTestHarness.pumpPage(
      tester,
      const OtpPage(phone: '0900000000', resendSecs: 1, enableResendSecs: 0),
    );

    // Tick the 1s validity down to zero → expired label appears.
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('auth.otp.expired_label'.tr()), findsOneWidget);
  });
}
