import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/loan/presentation/pages/loan_apply_page.dart';
import '../../features/loan/presentation/pages/loan_detail_page.dart';
import '../../features/loan/presentation/pages/loan_list_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../storage/secure_storage.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter({required this.secureStorage});

  final SecureStorage secureStorage;

  late final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: _redirect,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, __) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (_, __) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (_, __) => const HomePage(),
      ),
      GoRoute(
        path: AppRoutes.loans,
        builder: (_, __) => const LoanListPage(),
      ),
      GoRoute(
        path: AppRoutes.loanDetail,
        builder: (_, state) => LoanDetailPage(
          loanId: state.pathParameters['loanId']!,
        ),
      ),
      GoRoute(
        path: AppRoutes.apply,
        builder: (_, __) => const LoanApplyPage(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (_, __) => const ProfilePage(),
      ),
    ],
  );

  Future<String?> _redirect(BuildContext context, GoRouterState state) async {
    final token = await secureStorage.getAccessToken();
    final isLoggedIn = token != null;
    final path = state.uri.path;

    if (path == AppRoutes.splash) {
      return isLoggedIn ? AppRoutes.home : AppRoutes.login;
    }
    if (!isLoggedIn && path != AppRoutes.login) return AppRoutes.login;
    if (isLoggedIn && path == AppRoutes.login) return AppRoutes.home;
    return null;
  }
}
