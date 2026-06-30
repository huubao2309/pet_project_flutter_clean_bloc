import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_project_flutter_clean_bloc/core/error/app_exception.dart';
import 'package:pet_project_flutter_clean_bloc/core/router/app_routes.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/entities/login_result.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/entities/otp_challenge.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/use_cases/login_use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/use_cases/logout_use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/pages/login_page.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/view_model/auth_view_model.dart';

import '../../../../helpers/feature_test_harness.dart';

class _MockLoginUseCase extends Mock implements LoginUseCase {}

class _MockLogoutUseCase extends Mock implements LogoutUseCase {}

void main() {
  late _MockLoginUseCase loginUseCase;
  late _MockLogoutUseCase logoutUseCase;

  setUpAll(() {
    FeatureTestHarness.bootstrap();
    registerFallbackValue(const LoginParams(phone: '', password: ''));
  });

  setUp(() {
    loginUseCase = _MockLoginUseCase();
    logoutUseCase = _MockLogoutUseCase();
    FeatureTestHarness.reset();
    FeatureTestHarness.registerViewModel<AuthViewModel>(
      () => AuthViewModel(
        loginUseCase: loginUseCase,
        logoutUseCase: logoutUseCase,
      ),
    );
  });

  testWidgets('renders the login form', (tester) async {
    await FeatureTestHarness.pumpPage(tester, const LoginPage());

    expect(find.text('auth.welcome'.tr()), findsWidgets);
    expect(find.text('auth.login_button'.tr()), findsOneWidget);
  });

  testWidgets('shows inline errors when submitting an empty form',
      (tester) async {
    await FeatureTestHarness.pumpPage(tester, const LoginPage());

    await tester.tap(find.text('auth.login_button'.tr()));
    await tester.pump();

    expect(find.text('auth.phone_invalid'.tr()), findsOneWidget);
    expect(find.text('auth.password_required'.tr()), findsOneWidget);
    verifyNever(() => loginUseCase.execute(any()));
  });

  testWidgets('calls the login use case with valid input', (tester) async {
    when(() => loginUseCase.execute(any()))
        .thenAnswer((_) async => const LoginAuthenticated());

    await FeatureTestHarness.pumpPage(
      tester,
      const LoginPage(prefilledPhone: '0900000000'),
    );

    await tester.enterText(
      find.byType(EditableText).last,
      'password123',
    );
    await tester.tap(find.text('auth.login_button'.tr()));
    await tester.pump();

    verify(() => loginUseCase.execute(any())).called(1);
  });

  testWidgets('navigates to OTP when the backend requires it', (tester) async {
    when(() => loginUseCase.execute(any())).thenAnswer(
      (_) async => const LoginOtpRequired(
        OtpChallenge(resendSecs: 30, enableResendSecs: 10),
      ),
    );

    await FeatureTestHarness.pumpPage(
      tester,
      const LoginPage(prefilledPhone: '0900000000'),
    );
    await tester.enterText(find.byType(EditableText).last, 'password123');
    await tester.tap(find.text('auth.login_button'.tr()));
    await tester.pumpAndSettle();

    expect(find.text(AppRoutes.otp), findsOneWidget);
  });

  testWidgets('renders the full-screen lock on otpLimitExceeded',
      (tester) async {
    when(() => loginUseCase.execute(any()))
        .thenThrow(AccountBlockedException(BlockReason.otpLimitExceeded));

    await FeatureTestHarness.pumpPage(
      tester,
      const LoginPage(prefilledPhone: '0900000000'),
    );
    await tester.enterText(find.byType(EditableText).last, 'password123');
    await tester.tap(find.text('auth.login_button'.tr()));
    await tester.pumpAndSettle();

    expect(find.text('auth.lock.title'.tr()), findsOneWidget);
  });
}
