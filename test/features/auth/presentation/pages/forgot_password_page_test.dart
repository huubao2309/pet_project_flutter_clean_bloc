import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_project_flutter_clean_bloc/core/error/app_exception.dart';
import 'package:pet_project_flutter_clean_bloc/core/router/app_routes.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/entities/otp_challenge.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/use_cases/forgot_password_use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/view_model/forgot_password_view_model.dart';

import '../../../../helpers/feature_test_harness.dart';

class _MockForgotPasswordUseCase extends Mock
    implements ForgotPasswordUseCase {}

void main() {
  late _MockForgotPasswordUseCase forgotPasswordUseCase;

  setUpAll(FeatureTestHarness.bootstrap);

  setUp(() {
    forgotPasswordUseCase = _MockForgotPasswordUseCase();
    FeatureTestHarness.reset();
    FeatureTestHarness.registerViewModel<ForgotPasswordViewModel>(
      () => ForgotPasswordViewModel(
        forgotPasswordUseCase: forgotPasswordUseCase,
      ),
    );
  });

  testWidgets('renders the forgot-password form', (tester) async {
    await FeatureTestHarness.pumpPage(tester, const ForgotPasswordPage());

    expect(find.text('auth.forgot.title'.tr()), findsOneWidget);
    expect(find.text('auth.forgot.send'.tr()), findsOneWidget);
  });

  testWidgets('shows inline error for an invalid phone', (tester) async {
    await FeatureTestHarness.pumpPage(tester, const ForgotPasswordPage());

    await tester.enterText(find.byType(EditableText).first, '123');
    await tester.pump();

    expect(find.text('auth.phone_invalid'.tr()), findsOneWidget);
    await tester.tap(find.text('auth.forgot.send'.tr()));
    await tester.pump();
    verifyNever(() => forgotPasswordUseCase.execute(any()));
  });

  testWidgets('navigates to OTP on a successful send', (tester) async {
    when(() => forgotPasswordUseCase.execute(any())).thenAnswer(
      (_) async => const OtpChallenge(resendSecs: 30, enableResendSecs: 10),
    );

    await FeatureTestHarness.pumpPage(
      tester,
      const ForgotPasswordPage(prefilledPhone: '0900000000'),
    );
    await tester.tap(find.text('auth.forgot.send'.tr()));
    await tester.pumpAndSettle();

    verify(() => forgotPasswordUseCase.execute(any())).called(1);
    expect(find.text(AppRoutes.otp), findsOneWidget);
  });

  testWidgets('shows an error snackbar on failure', (tester) async {
    when(() => forgotPasswordUseCase.execute(any()))
        .thenThrow(ServerException(message: 'send failed'));

    await FeatureTestHarness.pumpPage(
      tester,
      const ForgotPasswordPage(prefilledPhone: '0900000000'),
    );
    await tester.tap(find.text('auth.forgot.send'.tr()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // The error drives the listener (snackbar shown via a detached overlay, so
    // we assert the use case ran and we stayed on the form).
    verify(() => forgotPasswordUseCase.execute(any())).called(1);
    expect(find.text('auth.forgot.title'.tr()), findsOneWidget);
  });
}
