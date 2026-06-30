import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_project_flutter_clean_bloc/core/error/app_exception.dart';
import 'package:pet_project_flutter_clean_bloc/core/router/app_routes.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/entities/otp_challenge.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/entities/sign_up_result.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/pages/sign_up_page.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/view_model/sign_up_view_model.dart';

import '../../../../helpers/feature_test_harness.dart';

class _MockSignUpUseCase extends Mock implements SignUpUseCase {}

void main() {
  late _MockSignUpUseCase signUpUseCase;

  setUpAll(() {
    FeatureTestHarness.bootstrap();
    registerFallbackValue(const SignUpParams(phone: ''));
  });

  setUp(() {
    signUpUseCase = _MockSignUpUseCase();
    FeatureTestHarness.reset();
    FeatureTestHarness.registerViewModel<SignUpViewModel>(
      () => SignUpViewModel(signUpUseCase: signUpUseCase),
    );
  });

  testWidgets('renders the sign-up form', (tester) async {
    await FeatureTestHarness.pumpPage(tester, const SignUpPage());

    expect(find.text('auth.register.title'.tr()), findsOneWidget);
    expect(find.text('auth.register.continue'.tr()), findsOneWidget);
  });

  testWidgets('does not submit when phone is invalid', (tester) async {
    await FeatureTestHarness.pumpPage(tester, const SignUpPage());

    await tester.enterText(find.byType(EditableText).first, '123');
    await tester.pump();

    // Inline phone error shown, button disabled → use case never called.
    expect(find.text('auth.phone_invalid'.tr()), findsOneWidget);
    await tester.tap(find.text('auth.register.continue'.tr()));
    await tester.pump();
    verifyNever(() => signUpUseCase.execute(any()));
  });

  testWidgets('navigates to OTP when sign-up requires verification',
      (tester) async {
    when(() => signUpUseCase.execute(any())).thenAnswer(
      (_) async => const SignUpOtpRequired(
        OtpChallenge(resendSecs: 30, enableResendSecs: 10),
      ),
    );

    await FeatureTestHarness.pumpPage(
      tester,
      const SignUpPage(prefilledPhone: '0900000000'),
    );
    await tester.tap(find.text('auth.register.continue'.tr()));
    await tester.pumpAndSettle();

    verify(() => signUpUseCase.execute(any())).called(1);
    expect(find.text(AppRoutes.otp), findsOneWidget);
  });

  testWidgets('completed sign-up routes back to login', (tester) async {
    when(() => signUpUseCase.execute(any()))
        .thenAnswer((_) async => const SignUpCompleted());

    await FeatureTestHarness.pumpPage(
      tester,
      const SignUpPage(prefilledPhone: '0900000000'),
    );
    await tester.tap(find.text('auth.register.continue'.tr()));
    await tester.pumpAndSettle();

    expect(find.text(AppRoutes.login), findsOneWidget);
  });

  testWidgets('renders the full-screen blocked view', (tester) async {
    when(() => signUpUseCase.execute(any()))
        .thenThrow(PhoneBlockedException());

    await FeatureTestHarness.pumpPage(
      tester,
      const SignUpPage(prefilledPhone: '0900000000'),
    );
    await tester.tap(find.text('auth.register.continue'.tr()));
    await tester.pumpAndSettle();

    expect(find.text('auth.register.blocked.title'.tr()), findsOneWidget);

    // The blocked view's back button returns to welcome.
    await tester.tap(find.text('auth.back'.tr()));
    await tester.pumpAndSettle();
    expect(find.text(AppRoutes.welcome), findsOneWidget);
  });

  testWidgets('shows an error snackbar on failure', (tester) async {
    when(() => signUpUseCase.execute(any()))
        .thenThrow(ServerException(message: 'boom'));

    // The error feedback is a BennySnackBar, shown via the global navigator
    // overlay — attach the key so it actually mounts.
    await FeatureTestHarness.pumpPage(
      tester,
      const SignUpPage(prefilledPhone: '0900000000'),
      attachGlobalNavigatorKey: true,
    );
    await tester.tap(find.text('auth.register.continue'.tr()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('boom'), findsOneWidget);

    // Drain the snackbar's auto-dismiss timer before the tree is disposed.
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  });
}
