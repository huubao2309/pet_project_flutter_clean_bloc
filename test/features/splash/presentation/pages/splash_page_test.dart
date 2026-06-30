import 'dart:ui' show Locale;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_project_flutter_clean_bloc/core/localization/domain/use_cases/get_language_use_case.dart';
import 'package:pet_project_flutter_clean_bloc/core/security/domain/use_cases/clear_stale_secure_storage_use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/use_cases/is_logged_in_use_case.dart';
import 'package:pet_project_flutter_clean_bloc/core/use_case/use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/app_update/domain/entities/app_update_status.dart';
import 'package:pet_project_flutter_clean_bloc/features/app_update/domain/use_cases/check_app_update_use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/app_update/domain/use_cases/dismiss_optional_update_use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/app_update/domain/use_cases/open_store_use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/app_update/presentation/app_update_overlay.dart';
import 'package:pet_project_flutter_clean_bloc/core/router/app_routes.dart';
import 'package:pet_project_flutter_clean_bloc/features/splash/presentation/pages/splash_page.dart';
import 'package:pet_project_flutter_clean_bloc/features/splash/presentation/view_model/splash_view_model.dart';

import '../../../../helpers/feature_test_harness.dart';

class _MockClearStale extends Mock implements ClearStaleSecureStorageUseCase {}

class _MockIsLoggedIn extends Mock implements IsLoggedInUseCase {}

class _MockGetLanguage extends Mock implements GetLanguageUseCase {}

class _MockCheck extends Mock implements CheckAppUpdateUseCase {}

class _MockDismiss extends Mock implements DismissOptionalUpdateUseCase {}

class _MockOpenStore extends Mock implements OpenStoreUseCase {}

void main() {
  late _MockClearStale clearStale;
  late _MockIsLoggedIn isLoggedIn;
  late _MockGetLanguage getLanguage;
  late _MockCheck check;

  setUpAll(() async {
    await FeatureTestHarness.bootstrap();
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    clearStale = _MockClearStale();
    isLoggedIn = _MockIsLoggedIn();
    getLanguage = _MockGetLanguage();
    check = _MockCheck();

    when(() => clearStale.execute(any())).thenAnswer((_) async {});
    when(() => check.execute(any()))
        .thenAnswer((_) async => const AppUpToDate());

    FeatureTestHarness.reset();
    FeatureTestHarness.registerViewModel<AppUpdateOverlay>(
      () => AppUpdateOverlay(
        checkUseCase: check,
        dismissUseCase: _MockDismiss(),
        openStoreUseCase: _MockOpenStore(),
      ),
    );
    FeatureTestHarness.registerViewModel<SplashViewModel>(
      () => SplashViewModel(
        clearStaleSecureStorageUseCase: clearStale,
        isLoggedInUseCase: isLoggedIn,
        getLanguageUseCase: getLanguage,
      ),
    );
  });

  testWidgets('renders the splash spinner while bootstrapping', (tester) async {
    when(() => isLoggedIn.execute(any())).thenAnswer((_) async => false);
    when(() => getLanguage.execute(any())).thenAnswer((_) async => null);

    await FeatureTestHarness.pumpPage(tester, const SplashPage());
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text(AppRoutes.welcome), findsNothing);

    // bootstrap() holds the splash with a 2s delay before navigating — drain it
    // so the timer isn't left pending when the tree is disposed.
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
  });

  testWidgets('routes to welcome when not logged in', (tester) async {
    when(() => isLoggedIn.execute(any())).thenAnswer((_) async => false);
    when(() => getLanguage.execute(any()))
        .thenAnswer((_) async => const Locale('en'));

    await FeatureTestHarness.pumpPage(tester, const SplashPage());
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text(AppRoutes.welcome), findsOneWidget);
    verify(() => clearStale.execute(any())).called(1);
  });

  testWidgets('routes to main when already logged in', (tester) async {
    when(() => isLoggedIn.execute(any())).thenAnswer((_) async => true);
    when(() => getLanguage.execute(any()))
        .thenAnswer((_) async => const Locale('vi'));

    await FeatureTestHarness.pumpPage(tester, const SplashPage());
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text(AppRoutes.main), findsOneWidget);
  });
}
