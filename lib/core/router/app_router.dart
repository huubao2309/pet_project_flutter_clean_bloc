import 'package:benny_style/benny_locator.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/auth/presentation/pages/sign_up_page.dart';
import '../../features/auth/presentation/pages/welcome_page.dart';
import '../../features/main/presentation/pages/main_page.dart';
import '../../features/onboarding/presentation/pages/billing_info_page.dart';
import '../../features/onboarding/presentation/pages/personal_info_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../storage/secure_storage/secure_storage.dart';
import 'app_routes.dart';
import 'router_guard.dart';

/// Configures GoRouter: declares the route tree and wires up [RouterGuard].
///
/// [RouterGuard] is an internal implementation detail — callers only depend
/// on [AppRouter]. Use [create] to instantiate, [onLogin]/[onLogout] to
/// notify auth changes.
class AppRouter {
  AppRouter._({required RouterGuard guard}) : _guard = guard;

  /// Pre-loads auth state via [SecureStorage], then builds the router.
  ///
  /// Must be called during app bootstrap while the native splash is still
  /// visible (i.e. before [runApp]). This ensures [RouterGuard.redirect] is
  /// synchronous: GoRouter resolves the initial route on the very first frame
  /// instead of awaiting an async call, which would leave a black screen
  /// between the native splash disappearing and the first Flutter page
  /// appearing.
  static Future<AppRouter> create(SecureStorage secureStorage) async {
    final guard = await RouterGuard.create(secureStorage);
    return AppRouter._(guard: guard);
  }

  final RouterGuard _guard;

  late final GoRouter router = GoRouter(
    // Shared with benny_style so its overlays (snackbar/dialog/bottom sheet)
    // work without a BuildContext.
    navigatorKey: bennyNavigatorKey,
    initialLocation: AppRoutes.splash,
    redirect: _guard.redirect,
    refreshListenable: _guard,
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (_, __) => const SplashPage()),
      GoRoute(path: AppRoutes.welcome, builder: (_, __) => const WelcomePage()),
      GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginPage()),
      GoRoute(path: AppRoutes.signUp, builder: (_, __) => const SignUpPage()),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (_, __) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        builder: (_, state) =>
            ResetPasswordPage(token: state.uri.queryParameters['token']),
      ),
      GoRoute(
        path: AppRoutes.personalInfo,
        builder: (_, __) => const PersonalInfoPage(),
      ),
      GoRoute(
        path: AppRoutes.billingInfo,
        builder: (_, __) => const BillingInfoPage(),
      ),
      // MainPage hosts the bottom-navigation tabs.
      GoRoute(path: AppRoutes.main, builder: (_, __) => const MainPage()),
    ],
  );

  /// Notifies the router that the user has logged in.
  void onLogin() => _guard.onLogin();

  /// Notifies the router that the user has logged out.
  void onLogout() => _guard.onLogout();

  /// Marks the user as logged in.
  void setLoggedIn({required bool value}) => _guard.setLoggedIn(value: value);

  /// Checks the user as logged in.
  bool get isLoggedIn => _guard.isLoggedIn;
}
