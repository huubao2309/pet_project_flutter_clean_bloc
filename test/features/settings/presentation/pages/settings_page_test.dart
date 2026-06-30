import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_project_flutter_clean_bloc/core/error/app_exception.dart';
import 'package:pet_project_flutter_clean_bloc/core/router/app_routes.dart';
import 'package:pet_project_flutter_clean_bloc/core/use_case/use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/use_cases/login_use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/use_cases/logout_use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:pet_project_flutter_clean_bloc/features/settings/presentation/pages/settings_page.dart';
import 'package:pet_project_flutter_clean_bloc/core/presentation/widgets/language_switcher.dart';

import '../../../../helpers/feature_test_harness.dart';

class _MockLoginUseCase extends Mock implements LoginUseCase {}

class _MockLogoutUseCase extends Mock implements LogoutUseCase {}

void main() {
  late _MockLoginUseCase loginUseCase;
  late _MockLogoutUseCase logoutUseCase;

  setUpAll(() async {
    await FeatureTestHarness.bootstrap();
    registerFallbackValue(const NoParams());
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

  testWidgets('renders the title, language switcher and logout button',
      (tester) async {
    await FeatureTestHarness.pumpPage(tester, const SettingsPage());

    expect(find.text('settings.title'.tr()), findsOneWidget);
    expect(find.byType(LanguageSwitcher), findsOneWidget);
    expect(find.text('settings.logout'.tr()), findsWidgets);
  });

  testWidgets('logout success navigates back to welcome', (tester) async {
    when(() => logoutUseCase.execute(any())).thenAnswer((_) async {});

    await FeatureTestHarness.pumpPage(tester, const SettingsPage());

    await tester.tap(find.text('settings.logout'.tr()).first);
    await tester.pumpAndSettle();

    verify(() => logoutUseCase.execute(any())).called(1);
    expect(find.text(AppRoutes.welcome), findsOneWidget);
  });

  testWidgets('logout failure keeps the user on the settings page',
      (tester) async {
    when(() => logoutUseCase.execute(any()))
        .thenThrow(NetworkException(message: 'offline'));

    await FeatureTestHarness.pumpPage(tester, const SettingsPage());

    await tester.tap(find.text('settings.logout'.tr()).first);
    await tester.pumpAndSettle();

    verify(() => logoutUseCase.execute(any())).called(1);
    expect(find.text(AppRoutes.welcome), findsNothing);
    expect(find.text('settings.title'.tr()), findsOneWidget);
  });

  testWidgets('tapping the language switcher opens the picker sheet',
      (tester) async {
    // The picker is a benny_style bottom sheet, which resolves its context via
    // the global navigator key — attach it so the sheet actually mounts.
    await FeatureTestHarness.pumpPage(
      tester,
      const SettingsPage(),
      attachGlobalNavigatorKey: true,
    );

    await tester.tap(find.byType(LanguageSwitcher));
    await tester.pumpAndSettle();

    expect(find.text('language.title'.tr()), findsOneWidget);
  });
}
