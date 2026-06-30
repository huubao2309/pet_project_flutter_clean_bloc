import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_project_flutter_clean_bloc/core/error/app_exception.dart';
import 'package:pet_project_flutter_clean_bloc/core/router/app_routes.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/use_cases/register_password_use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/pages/register_password_page.dart';

import '../../../../helpers/feature_test_harness.dart';

class _MockRegisterPasswordUseCase extends Mock
    implements RegisterPasswordUseCase {}

const _strongPassword = 'Password1!';

void main() {
  late _MockRegisterPasswordUseCase registerPasswordUseCase;

  setUpAll(FeatureTestHarness.bootstrap);

  setUp(() {
    registerPasswordUseCase = _MockRegisterPasswordUseCase();
    FeatureTestHarness.reset();
    FeatureTestHarness.registerViewModel<RegisterPasswordUseCase>(
      () => registerPasswordUseCase,
    );
  });

  Future<void> fillValidForm(WidgetTester tester) async {
    await tester.enterText(find.byType(EditableText).at(0), _strongPassword);
    await tester.pump();
    await tester.enterText(find.byType(EditableText).at(1), _strongPassword);
    await tester.pump();
  }

  testWidgets('renders the register-password form', (tester) async {
    await FeatureTestHarness.pumpPage(tester, const RegisterPasswordPage());

    expect(find.text('auth.register_password.title'.tr()), findsOneWidget);
    expect(find.text('auth.register.continue'.tr()), findsOneWidget);
  });

  testWidgets('shows the confirm-mismatch error', (tester) async {
    await FeatureTestHarness.pumpPage(tester, const RegisterPasswordPage());

    await tester.enterText(find.byType(EditableText).at(0), _strongPassword);
    await tester.pump();
    await tester.enterText(find.byType(EditableText).at(1), 'different1!');
    await tester.pump();

    expect(find.text('auth.register.password_mismatch'.tr()), findsOneWidget);
  });

  testWidgets('does not submit while the form is invalid', (tester) async {
    await FeatureTestHarness.pumpPage(tester, const RegisterPasswordPage());

    await tester.tap(find.text('auth.register.continue'.tr()));
    await tester.pump();

    verifyNever(() => registerPasswordUseCase.execute(any()));
  });

  testWidgets('signs in and lands on main on success', (tester) async {
    when(() => registerPasswordUseCase.execute(any())).thenAnswer((_) async {});

    await FeatureTestHarness.pumpPage(tester, const RegisterPasswordPage());
    await fillValidForm(tester);
    await tester.tap(find.text('auth.register.continue'.tr()));
    await tester.pumpAndSettle();

    verify(() => registerPasswordUseCase.execute(_strongPassword)).called(1);
    expect(find.text(AppRoutes.main), findsOneWidget);
  });

  testWidgets('shows an error snackbar on failure', (tester) async {
    when(() => registerPasswordUseCase.execute(any()))
        .thenThrow(ServerException(message: 'register failed'));

    // The error feedback is a BennySnackBar, shown via the global navigator
    // overlay — attach the key so it actually mounts.
    await FeatureTestHarness.pumpPage(
      tester,
      const RegisterPasswordPage(),
      attachGlobalNavigatorKey: true,
    );
    await fillValidForm(tester);
    await tester.tap(find.text('auth.register.continue'.tr()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('register failed'), findsOneWidget);

    // Drain the snackbar's auto-dismiss timer before the tree is disposed.
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  });
}
