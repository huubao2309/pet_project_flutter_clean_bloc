import 'package:benny_style/benny_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_project_flutter_clean_bloc/core/presentation/view_model_provider.dart';
import 'package:pet_project_flutter_clean_bloc/core/router/app_router.dart';
import 'package:pet_project_flutter_clean_bloc/core/router/app_routes.dart';
import 'package:pet_project_flutter_clean_bloc/core/storage/local_storage/local_storage.dart';
import 'package:pet_project_flutter_clean_bloc/core/theme/benny_style_initializer.dart';
import 'package:pet_project_flutter_clean_bloc/core/theme/theme_view_model.dart';

import 'localization_test_harness.dart';

class _MockLocalStorage extends Mock implements LocalStorage {}

/// Shared harness for testing feature **pages** and theme-aware widgets.
///
/// ```dart
/// setUpAll(FeatureTestHarness.bootstrap);   // translations + design system, once
/// setUp(FeatureTestHarness.reset);          // fresh AppRouter + ThemeViewModel per test
/// FeatureTestHarness.registerViewModel<AuthViewModel>(() => AuthViewModel(...mocks...));
/// await FeatureTestHarness.pumpPage(tester, const LoginPage());
/// ```
abstract final class FeatureTestHarness {
  static final GetIt getIt = GetIt.instance;

  /// One-time (setUpAll): real translations + benny_style init (the latter sets
  /// a `late` palette field, so it must run exactly once per test isolate).
  static Future<void> bootstrap() async {
    await LocalizationTestHarness.useRealTranslations();
    BennyStyleInitializer.ensureInitialized();
  }

  /// Per-test (setUp): re-register the always-needed singletons WITHOUT
  /// re-initialising benny_style. [ThemeState] stays registered from [bootstrap].
  static void reset() {
    _reregisterSingleton<AppRouter>(AppRouter());

    final storage = _MockLocalStorage();
    when(() => storage.getThemeMode()).thenReturn('light');
    when(() => storage.setThemeMode(value: any(named: 'value')))
        .thenAnswer((_) async {});
    _reregisterSingleton<ThemeViewModel>(
      ThemeViewModel(localStorage: storage, systemBrightness: Brightness.light),
    );
  }

  /// Registers a page's view model as a factory (replacing any previous one).
  static void registerViewModel<T extends Object>(T Function() create) {
    if (getIt.isRegistered<T>()) {
      getIt.unregister<T>();
    }
    getIt.registerFactory<T>(create);
  }

  static void _reregisterSingleton<T extends Object>(T instance) {
    if (getIt.isRegistered<T>()) {
      getIt.unregister<T>();
    }
    getIt.registerSingleton<T>(instance);
  }

  /// Pumps [page] as the active route of a real [GoRouter] (so `context.go` /
  /// `context.push` work), under a [ThemeViewModel] provider (so [AppTopBar]'s
  /// theme builder resolves). Every [AppRoutes] target is stubbed with a Text
  /// of its path, so navigation is assertable via `find.text(AppRoutes.main)`.
  static Future<void> pumpPage(
    WidgetTester tester,
    Widget page, {
    List<GoRoute> extraRoutes = const [],
    bool attachGlobalNavigatorKey = false,
  }) async {
    const host = '/__test_host__';
    final router = GoRouter(
      initialLocation: host,
      // Match the real app router (see AppRouter) so benny_style overlays
      // (bottom sheets, dialogs, snackbars) can resolve a context in tests.
      // Opt-in: it makes overlays actually mount, which some pages aren't set
      // up to settle (e.g. snackbar auto-dismiss timers), so only enable it for
      // tests that assert on overlay content.
      navigatorKey: attachGlobalNavigatorKey ? bennyNavigatorKey : null,
      routes: [
        GoRoute(path: host, builder: (_, __) => page),
        for (final path in _stubRoutes)
          GoRoute(path: path, builder: (_, __) => _Stub(path)),
        ...extraRoutes,
      ],
    );

    await tester.pumpWidget(
      ViewModelProvider<ThemeViewModel>(
        create: (_) => getIt<ThemeViewModel>(),
        child: LocalizationTestHarness.wrap(
          MaterialApp.router(routerConfig: router),
        ),
      ),
    );
    await tester.pump();
  }

  static const List<String> _stubRoutes = [
    AppRoutes.splash,
    AppRoutes.welcome,
    AppRoutes.login,
    AppRoutes.signUp,
    AppRoutes.registerPassword,
    AppRoutes.forgotPassword,
    AppRoutes.otp,
    AppRoutes.resetPassword,
    AppRoutes.changePassword,
    AppRoutes.personalInfo,
    AppRoutes.billingInfo,
    AppRoutes.main,
    AppRoutes.qrScan,
  ];
}

class _Stub extends StatelessWidget {
  const _Stub(this.path);
  final String path;

  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text(path)));
}
