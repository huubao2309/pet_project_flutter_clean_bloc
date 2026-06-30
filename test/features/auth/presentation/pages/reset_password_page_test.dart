import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_project_flutter_clean_bloc/core/error/app_exception.dart';
import 'package:pet_project_flutter_clean_bloc/core/router/app_routes.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/use_cases/reset_password_use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/pages/reset_password_page.dart';

import '../../../../helpers/feature_test_harness.dart';

class _MockResetPasswordUseCase extends Mock implements ResetPasswordUseCase {}

const _strongPassword = 'Password1!';

void main() {
  late _MockResetPasswordUseCase resetPasswordUseCase;

  setUpAll(FeatureTestHarness.bootstrap);

  setUp(() {
    resetPasswordUseCase = _MockResetPasswordUseCase();
    FeatureTestHarness.reset();
    FeatureTestHarness.registerViewModel<ResetPasswordUseCase>(
      () => resetPasswordUseCase,
    );
  });

  Future<void> fillValidForm(WidgetTester tester) async {
    await tester.enterText(find.byType(EditableText).at(0), _strongPassword);
    await tester.pump();
    await tester.enterText(find.byType(EditableText).at(1), _strongPassword);
    await tester.pump();
  }

  testWidgets('renders the reset-password form', (tester) async {
    await FeatureTestHarness.pumpPage(tester, const ResetPasswordPage());

    expect(find.text('auth.reset.title'.tr()), findsWidgets);
    expect(find.text('auth.reset.submit'.tr()), findsWidgets);
  });

  testWidgets('shows the confirm-mismatch error', (tester) async {
    await FeatureTestHarness.pumpPage(tester, const ResetPasswordPage());

    await tester.enterText(find.byType(EditableText).at(0), _strongPassword);
    await tester.pump();
    await tester.enterText(find.byType(EditableText).at(1), 'different1!');
    await tester.pump();

    expect(find.text('auth.register.password_mismatch'.tr()), findsOneWidget);
  });

  testWidgets('does not submit while the form is invalid', (tester) async {
    await FeatureTestHarness.pumpPage(tester, const ResetPasswordPage());

    await tester.tap(find.text('auth.reset.submit'.tr()).last);
    await tester.pump();

    verifyNever(() => resetPasswordUseCase.execute(any()));
  });

  testWidgets('resets and returns to login on success', (tester) async {
    when(() => resetPasswordUseCase.execute(any())).thenAnswer((_) async {});

    await FeatureTestHarness.pumpPage(
      tester,
      const ResetPasswordPage(phone: '0900000000'),
    );
    await fillValidForm(tester);
    await tester.tap(find.text('auth.reset.submit'.tr()).last);
    await tester.pumpAndSettle();

    verify(() => resetPasswordUseCase.execute(_strongPassword)).called(1);
    expect(find.text(AppRoutes.login), findsOneWidget);
  });

  testWidgets('shows an error snackbar on failure', (tester) async {
    when(() => resetPasswordUseCase.execute(any()))
        .thenThrow(ServerException(message: 'reset failed'));

    // The error feedback is a BennySnackBar, shown via the global navigator
    // overlay — attach the key so it actually mounts.
    await FeatureTestHarness.pumpPage(
      tester,
      const ResetPasswordPage(),
      attachGlobalNavigatorKey: true,
    );
    await fillValidForm(tester);
    await tester.tap(find.text('auth.reset.submit'.tr()).last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('reset failed'), findsOneWidget);

    // Drain the snackbar's auto-dismiss timer before the tree is disposed.
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  });
}
