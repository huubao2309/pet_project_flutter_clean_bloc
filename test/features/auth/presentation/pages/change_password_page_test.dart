import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_project_flutter_clean_bloc/core/error/app_exception.dart';
import 'package:pet_project_flutter_clean_bloc/features/profile/domain/use_cases/change_password_use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/pages/change_password_page.dart';

import '../../../../helpers/feature_test_harness.dart';

class _MockChangePasswordUseCase extends Mock
    implements ChangePasswordUseCase {}

const _currentPassword = 'OldPass1!';
const _newPassword = 'Password1!';

void main() {
  late _MockChangePasswordUseCase changePasswordUseCase;

  setUpAll(() {
    FeatureTestHarness.bootstrap();
    registerFallbackValue(
      const ChangePasswordParams(currentPassword: '', newPassword: ''),
    );
  });

  setUp(() {
    changePasswordUseCase = _MockChangePasswordUseCase();
    FeatureTestHarness.reset();
    FeatureTestHarness.registerViewModel<ChangePasswordUseCase>(
      () => changePasswordUseCase,
    );
  });

  Future<void> fillValidForm(WidgetTester tester) async {
    await tester.enterText(find.byType(EditableText).at(0), _currentPassword);
    await tester.pump();
    await tester.enterText(find.byType(EditableText).at(1), _newPassword);
    await tester.pump();
    await tester.enterText(find.byType(EditableText).at(2), _newPassword);
    await tester.pump();
  }

  testWidgets('renders the change-password form', (tester) async {
    await FeatureTestHarness.pumpPage(tester, const ChangePasswordPage());

    expect(find.text('auth.change.title'.tr()), findsOneWidget);
    expect(find.text('auth.change.submit'.tr()), findsOneWidget);
  });

  testWidgets('shows the new-same-as-current error', (tester) async {
    await FeatureTestHarness.pumpPage(tester, const ChangePasswordPage());

    await tester.enterText(find.byType(EditableText).at(0), _newPassword);
    await tester.pump();
    await tester.enterText(find.byType(EditableText).at(1), _newPassword);
    await tester.pump();

    expect(find.text('auth.change.new_same_as_current'.tr()), findsOneWidget);
  });

  testWidgets('shows the confirm-mismatch error', (tester) async {
    await FeatureTestHarness.pumpPage(tester, const ChangePasswordPage());

    await tester.enterText(find.byType(EditableText).at(1), _newPassword);
    await tester.pump();
    await tester.enterText(find.byType(EditableText).at(2), 'different1!');
    await tester.pump();

    expect(find.text('auth.register.password_mismatch'.tr()), findsOneWidget);
  });

  testWidgets('does not submit while the form is invalid', (tester) async {
    await FeatureTestHarness.pumpPage(tester, const ChangePasswordPage());

    await tester.tap(find.text('auth.change.submit'.tr()));
    await tester.pump();

    verifyNever(() => changePasswordUseCase.execute(any()));
  });

  testWidgets('shows a success snackbar on success', (tester) async {
    when(() => changePasswordUseCase.execute(any())).thenAnswer((_) async {});

    // The success/error feedback is a BennySnackBar, shown via the global
    // navigator overlay — attach the key so it actually mounts.
    await FeatureTestHarness.pumpPage(
      tester,
      const ChangePasswordPage(),
      attachGlobalNavigatorKey: true,
    );
    await fillValidForm(tester);
    await tester.tap(find.text('auth.change.submit'.tr()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    verify(() => changePasswordUseCase.execute(any())).called(1);
    expect(find.text('auth.change.success'.tr()), findsOneWidget);

    // Drain the snackbar's auto-dismiss timer before the tree is disposed.
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  });

  testWidgets('shows an error snackbar on failure', (tester) async {
    when(() => changePasswordUseCase.execute(any()))
        .thenThrow(ServerException(message: 'change failed'));

    await FeatureTestHarness.pumpPage(
      tester,
      const ChangePasswordPage(),
      attachGlobalNavigatorKey: true,
    );
    await fillValidForm(tester);
    await tester.tap(find.text('auth.change.submit'.tr()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('change failed'), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  });
}
