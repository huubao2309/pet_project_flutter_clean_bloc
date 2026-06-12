import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/loan/presentation/pages/loan_apply_page.dart';
import '../../features/loan/presentation/pages/loan_detail_page.dart';
import '../../features/loan/presentation/pages/loan_list_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../storage/secure_storage/secure_storage.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter._({required this.secureStorage, required bool isLoggedIn})
      : _authNotifier = ValueNotifier<bool>(isLoggedIn);

  /// Pre-loads the access token to determine initial auth state.
  /// Called during app bootstrap while the native splash is still visible,
  /// so [_redirect] can be synchronous — no black frame on first navigation.
  static Future<AppRouter> create(SecureStorage secureStorage) async {
    final isLoggedIn = (await secureStorage.getAccessToken()) != null;
    return AppRouter._(secureStorage: secureStorage, isLoggedIn: isLoggedIn);
  }

  final SecureStorage secureStorage;

  // Dual-purpose: holds current auth state for sync redirect checks, and acts
  // as refreshListenable so GoRouter re-evaluates redirect on login/logout.
  final ValueNotifier<bool> _authNotifier;

  late final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: _redirect,
    refreshListenable: _authNotifier,
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (_, __) => const SplashPage()),
      GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginPage()),
      GoRoute(path: AppRoutes.home, builder: (_, __) => const HomePage()),
      GoRoute(path: AppRoutes.loans, builder: (_, __) => const LoanListPage()),
      GoRoute(
        path: AppRoutes.loanDetail,
        builder: (_, state) => LoanDetailPage(loanId: state.pathParameters['loanId']!),
      ),
      GoRoute(path: AppRoutes.apply, builder: (_, __) => const LoanApplyPage()),
      GoRoute(path: AppRoutes.profile, builder: (_, __) => const ProfilePage()),
    ],
  );

  // Called by the auth BLoC/Cubit after a successful login.
  // GoRouter automatically re-runs _redirect() and navigates to home.
  void onLogin() => _authNotifier.value = true;

  // Called by the auth BLoC/Cubit after logout.
  // GoRouter automatically re-runs _redirect() and navigates to login.
  void onLogout() => _authNotifier.value = false;

  // Sync redirect: resolves on the very first frame — no async gap, no black screen.
  String? _redirect(BuildContext context, GoRouterState state) {
    final isLoggedIn = _authNotifier.value;
    final path = state.uri.path;

    if (path == AppRoutes.splash) {
      return isLoggedIn ? AppRoutes.home : AppRoutes.login;
    }
    if (!isLoggedIn && path != AppRoutes.login) return AppRoutes.login;
    if (isLoggedIn && path == AppRoutes.login) return AppRoutes.home;
    return null;
  }
}
