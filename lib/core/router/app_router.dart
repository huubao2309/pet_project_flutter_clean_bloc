import 'package:benny_style/benny_locator.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/change_password_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/otp_page.dart';
import '../../features/auth/presentation/pages/register_password_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/auth/presentation/pages/sign_up_page.dart';
import '../../features/auth/presentation/pages/welcome_page.dart';
import '../../features/main/presentation/pages/main_page.dart';
import '../../features/onboarding/presentation/pages/billing_info_page.dart';
import '../../features/onboarding/presentation/pages/personal_info_page.dart';
import '../../features/qr_scan/presentation/pages/qr_scan_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import 'app_routes.dart';
import 'router_guard.dart';

/// Configures GoRouter: declares the route tree and wires up [RouterGuard].
///
/// [RouterGuard] is an internal implementation detail — callers only depend
/// on [AppRouter]. The initial auth state is resolved on the splash screen
/// (which clears stale keychain data first), then pushed in via [setLoggedIn].
class AppRouter {
  AppRouter() : _guard = RouterGuard();

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
      GoRoute(
        path: AppRoutes.login,
        builder: (_, state) =>
            LoginPage(prefilledPhone: state.uri.queryParameters['phone']),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        builder: (_, state) =>
            SignUpPage(prefilledPhone: state.uri.queryParameters['phone']),
      ),
      GoRoute(
        path: AppRoutes.registerPassword,
        builder: (_, __) => const RegisterPasswordPage(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (_, state) => ForgotPasswordPage(
          prefilledPhone: state.uri.queryParameters['phone'],
        ),
      ),
      GoRoute(
        path: AppRoutes.otp,
        builder: (_, state) {
          final params = state.uri.queryParameters;
          return OtpPage(
            phone: params['phone'],
            resendSecs: int.tryParse(params['resend'] ?? ''),
            enableResendSecs: int.tryParse(params['enable_resend'] ?? ''),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        builder: (_, state) =>
            ResetPasswordPage(phone: state.uri.queryParameters['phone']),
      ),
      GoRoute(
        path: AppRoutes.changePassword,
        builder: (_, __) => const ChangePasswordPage(),
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
      // Full-screen in-app QR scanner, pushed over the tabs.
      GoRoute(path: AppRoutes.qrScan, builder: (_, __) => const QrScanPage()),
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
