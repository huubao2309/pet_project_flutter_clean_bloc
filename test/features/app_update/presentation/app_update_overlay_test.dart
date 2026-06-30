import 'package:benny_style/benny_locator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_project_flutter_clean_bloc/core/theme/benny_style_initializer.dart';
import 'package:pet_project_flutter_clean_bloc/core/use_case/use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/app_update/domain/entities/app_update_info.dart';
import 'package:pet_project_flutter_clean_bloc/features/app_update/domain/entities/app_update_status.dart';
import 'package:pet_project_flutter_clean_bloc/features/app_update/domain/use_cases/check_app_update_use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/app_update/domain/use_cases/dismiss_optional_update_use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/app_update/domain/use_cases/open_store_use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/app_update/presentation/app_update_overlay.dart';
import 'package:pet_project_flutter_clean_bloc/features/app_update/presentation/widgets/app_update_overlay_view.dart';

import '../../../helpers/localization_test_harness.dart';

class _MockCheck extends Mock implements CheckAppUpdateUseCase {}

class _MockDismiss extends Mock implements DismissOptionalUpdateUseCase {}

class _MockOpenStore extends Mock implements OpenStoreUseCase {}

void main() {
  late _MockCheck check;
  late _MockDismiss dismiss;
  late _MockOpenStore openStore;

  const info = AppUpdateInfo(
    latestVersion: '2.0.0',
    storeUrl: 'https://store/app',
    message: 'New stuff',
  );

  setUpAll(() async {
    await LocalizationTestHarness.useRealTranslations();
    BennyStyleInitializer.ensureInitialized();
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    check = _MockCheck();
    dismiss = _MockDismiss();
    openStore = _MockOpenStore();
    when(() => dismiss.execute(any())).thenAnswer((_) async {});
    when(() => openStore.execute(any())).thenAnswer((_) async {});
  });

  AppUpdateOverlay buildOverlay() => AppUpdateOverlay(
        checkUseCase: check,
        dismissUseCase: dismiss,
        openStoreUseCase: openStore,
      );

  /// Pumps a host app whose navigator carries [bennyNavigatorKey], so the
  /// overlay's `bennyNavigatorKey.currentState?.overlay` resolves.
  ///
  /// Uses [MaterialApp.router] (not a plain `home:`) so the inserted overlay
  /// sits under a [Router] — [AppUpdateOverlayView] wraps its content in a
  /// [BackButtonListener], which calls `Router.of` and throws without one.
  Future<void> pumpHost(WidgetTester tester) async {
    final router = GoRouter(
      navigatorKey: bennyNavigatorKey,
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => const Scaffold(body: SizedBox.shrink()),
        ),
      ],
    );
    await tester.pumpWidget(
      LocalizationTestHarness.wrap(MaterialApp.router(routerConfig: router)),
    );
    await tester.pump();
  }

  testWidgets('does nothing when up to date', (tester) async {
    when(() => check.execute(any()))
        .thenAnswer((_) async => const AppUpToDate());
    await pumpHost(tester);

    buildOverlay().check();
    await tester.pumpAndSettle();

    expect(find.byType(AppUpdateOverlayView), findsNothing);
  });

  testWidgets('fails open (shows nothing) when the check throws',
      (tester) async {
    when(() => check.execute(any())).thenThrow(Exception('network'));
    await pumpHost(tester);

    buildOverlay().check();
    await tester.pumpAndSettle();

    expect(find.byType(AppUpdateOverlayView), findsNothing);
  });

  testWidgets('shows a forced prompt and opens the store on update',
      (tester) async {
    when(() => check.execute(any()))
        .thenAnswer((_) async => const AppForcedUpdate(info));
    await pumpHost(tester);

    buildOverlay().check();
    await tester.pumpAndSettle();

    expect(find.byType(AppUpdateOverlayView), findsOneWidget);

    await tester.tap(find.text('update.update_button'.tr()));
    await tester.pumpAndSettle();

    verify(() => openStore.execute(info.storeUrl)).called(1);
  });

  testWidgets('optional update: dismiss records the version and closes',
      (tester) async {
    when(() => check.execute(any()))
        .thenAnswer((_) async => const AppOptionalUpdate(info));
    await pumpHost(tester);

    buildOverlay().check();
    await tester.pumpAndSettle();

    expect(find.byType(AppUpdateOverlayView), findsOneWidget);

    await tester.tap(find.text('update.close_button'.tr()));
    await tester.pumpAndSettle();

    verify(() => dismiss.execute(info.latestVersion)).called(1);
    verifyNever(() => openStore.execute(any()));
    expect(find.byType(AppUpdateOverlayView), findsNothing);
  });

  testWidgets('optional update: update records the version and opens store',
      (tester) async {
    when(() => check.execute(any()))
        .thenAnswer((_) async => const AppOptionalUpdate(info));
    await pumpHost(tester);

    buildOverlay().check();
    await tester.pumpAndSettle();

    await tester.tap(find.text('update.update_button'.tr()));
    await tester.pumpAndSettle();

    verify(() => dismiss.execute(info.latestVersion)).called(1);
    verify(() => openStore.execute(info.storeUrl)).called(1);
  });

  testWidgets('a second check never stacks a second prompt', (tester) async {
    when(() => check.execute(any()))
        .thenAnswer((_) async => const AppOptionalUpdate(info));
    await pumpHost(tester);

    final overlay = buildOverlay()..check();
    await tester.pumpAndSettle();
    overlay.check();
    await tester.pumpAndSettle();

    expect(find.byType(AppUpdateOverlayView), findsOneWidget);
  });
}
