import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_project_flutter_clean_bloc/core/presentation/view_model_provider.dart';
import 'package:pet_project_flutter_clean_bloc/core/router/app_routes.dart';
import 'package:pet_project_flutter_clean_bloc/core/use_case/use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/use_cases/login_use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/use_cases/logout_use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:pet_project_flutter_clean_bloc/features/profile/domain/entities/user_profile.dart';
import 'package:pet_project_flutter_clean_bloc/features/profile/domain/use_cases/get_profile_use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/profile/presentation/pages/profile_page.dart';
import 'package:pet_project_flutter_clean_bloc/features/profile/presentation/view_model/profile_view_model.dart';
import 'package:pet_project_flutter_clean_bloc/features/profile/presentation/widgets/profile_header.dart';

import '../../../../helpers/feature_test_harness.dart';

class _MockGetProfileUseCase extends Mock implements GetProfileUseCase {}

class _MockLoginUseCase extends Mock implements LoginUseCase {}

class _MockLogoutUseCase extends Mock implements LogoutUseCase {}

void main() {
  late _MockGetProfileUseCase getProfileUseCase;
  late _MockLoginUseCase loginUseCase;
  late _MockLogoutUseCase logoutUseCase;

  const sampleProfile = UserProfile(
    id: 'u1',
    fullName: 'Bảo Nguyễn',
    phone: '0901234567',
  );

  setUpAll(() {
    FeatureTestHarness.bootstrap();
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    getProfileUseCase = _MockGetProfileUseCase();
    loginUseCase = _MockLoginUseCase();
    logoutUseCase = _MockLogoutUseCase();

    when(() => getProfileUseCase.execute(any()))
        .thenAnswer((_) async => sampleProfile);
    when(() => logoutUseCase.execute(any())).thenAnswer((_) async {});

    FeatureTestHarness.reset();
    FeatureTestHarness.registerViewModel<ProfileViewModel>(
      () => ProfileViewModel(getProfileUseCase: getProfileUseCase),
    );
    FeatureTestHarness.registerViewModel<AuthViewModel>(
      () => AuthViewModel(
        loginUseCase: loginUseCase,
        logoutUseCase: logoutUseCase,
      ),
    );
  });

  // In production `MainPage` provides the [ProfileViewModel] above the tabs;
  // standalone we replicate that wrapper (and kick off the profile load).
  Widget hostedProfile({bool load = true}) =>
      ViewModelProvider<ProfileViewModel>(
        create: (_) {
          final vm = FeatureTestHarness.getIt<ProfileViewModel>();
          if (load) {
            vm.loadProfile();
          }
          return vm;
        },
        child: const ProfilePage(),
      );

  testWidgets('renders the grouped settings sections', (tester) async {
    await FeatureTestHarness.pumpPage(tester, hostedProfile());
    await tester.pumpAndSettle();

    // Group labels are rendered upper-cased by _GroupLabel.
    expect(find.text('profile.account'.tr().toUpperCase()), findsOneWidget);
    expect(find.text('profile.support'.tr().toUpperCase()), findsOneWidget);
    expect(find.text('profile.change_password'.tr()), findsOneWidget);
    expect(find.text('profile.logout'.tr()), findsWidgets);
  });

  testWidgets('shows the loading placeholder name before the profile loads',
      (tester) async {
    when(() => getProfileUseCase.execute(any())).thenAnswer(
      (_) async => Future.delayed(
        const Duration(seconds: 1),
        () => sampleProfile,
      ),
    );

    await FeatureTestHarness.pumpPage(tester, hostedProfile());
    await tester.pump();

    final header = tester.widget<ProfileHeader>(find.byType(ProfileHeader));
    expect(header.name, 'profile.loading_name'.tr());

    // The loading UI is static (no scheduled frame), so pumpAndSettle alone
    // would leave the 1s profile-load timer pending — advance past it first.
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
  });

  testWidgets('renders the fetched profile name and masked phone once loaded',
      (tester) async {
    await FeatureTestHarness.pumpPage(tester, hostedProfile());
    await tester.pumpAndSettle();

    final header = tester.widget<ProfileHeader>(find.byType(ProfileHeader));
    expect(header.name, 'Bảo Nguyễn');
    expect(header.maskedPhone, endsWith('4567'));
  });

  testWidgets('navigates to change-password when the row is tapped',
      (tester) async {
    await FeatureTestHarness.pumpPage(tester, hostedProfile());
    await tester.pumpAndSettle();

    final row = find.text('profile.change_password'.tr());
    await tester.ensureVisible(row);
    await tester.tap(row);
    await tester.pumpAndSettle();

    expect(find.text(AppRoutes.changePassword), findsOneWidget);
  });

  testWidgets('opens the language picker when the language row is tapped',
      (tester) async {
    await FeatureTestHarness.pumpPage(tester, hostedProfile());
    await tester.pumpAndSettle();

    final row = find.text('profile.language'.tr());
    await tester.ensureVisible(row);
    await tester.tap(row);
    await tester.pumpAndSettle();

    expect(find.text('language.vi'.tr()), findsWidgets);
  });

  testWidgets('toggles the dark mode switch', (tester) async {
    await FeatureTestHarness.pumpPage(tester, hostedProfile());
    await tester.pumpAndSettle();

    final switches = find.byType(Switch);
    expect(switches, findsWidgets);
    await tester.ensureVisible(switches.first);
    await tester.tap(switches.first);
    await tester.pumpAndSettle();
  });

  testWidgets('confirms logout and calls the logout use case', (tester) async {
    // The logout row sits at the bottom of a long list; give the surface enough
    // height so ensureVisible can bring it fully on-screen for the tap.
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await FeatureTestHarness.pumpPage(tester, hostedProfile());
    await tester.pumpAndSettle();

    final logoutRow = find.text('profile.logout'.tr()).last;
    await tester.ensureVisible(logoutRow);
    await tester.tap(logoutRow);
    await tester.pumpAndSettle();

    // Confirm in the dialog (the confirm button reuses the logout label).
    final confirm = find.text('profile.logout'.tr()).last;
    await tester.tap(confirm);
    await tester.pumpAndSettle();

    verify(() => logoutUseCase.execute(any())).called(1);
  });

  testWidgets('opens the delete confirmation dialog', (tester) async {
    // The delete row sits at the bottom of a long list; give the surface enough
    // height so ensureVisible can bring it fully on-screen for the tap.
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await FeatureTestHarness.pumpPage(tester, hostedProfile());
    await tester.pumpAndSettle();

    final deleteRow = find.text('profile.delete'.tr()).first;
    await tester.ensureVisible(deleteRow);
    await tester.tap(deleteRow);
    await tester.pumpAndSettle();

    expect(find.text('profile.delete_confirm_title'.tr()), findsWidgets);
  });
}
