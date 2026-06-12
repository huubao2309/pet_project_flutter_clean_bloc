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
    initialLocation: AppRoutes.splash,
    redirect: _guard.redirect,
    refreshListenable: _guard,
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

  /// Call after a successful login. GoRouter re-evaluates redirect automatically.
  void onLogin() => _guard.onLogin();

  /// Call after logout. GoRouter re-evaluates redirect automatically.
  void onLogout() => _guard.onLogout();
}
