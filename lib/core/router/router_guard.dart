import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'app_routes.dart';

/// Owns auth state and decides whether a navigation is allowed.
///
/// Registered as a [ChangeNotifier] so GoRouter automatically re-evaluates
/// [redirect] whenever [onLogin] or [onLogout] is called — no manual refresh
/// needed anywhere in the app.
///
/// Usage after login/logout:
/// ```dart
/// getIt<RouterGuard>().onLogin();
/// getIt<RouterGuard>().onLogout();
/// ```
class RouterGuard extends ChangeNotifier {
  /// Starts logged-out; the splash screen resolves the real auth state (after
  /// clearing any stale keychain data) and calls [setLoggedIn] before routing.
  RouterGuard();

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  /// Notifies the router that the user has logged in.
  void onLogin() {
    _isLoggedIn = true;
    notifyListeners();
  }

  /// Notifies the router that the user has logged out.
  void onLogout() {
    _isLoggedIn = false;
    notifyListeners();
  }

  /// Marks the user as logged in.
  void setLoggedIn({required bool value}) {
    _isLoggedIn = value;
  }

  /// Routes reachable without being logged in (the welcome/auth flow).
  static const _publicRoutes = <String>{
    AppRoutes.welcome,
    AppRoutes.login,
    AppRoutes.signUp,
    AppRoutes.forgotPassword,
    AppRoutes.resetPassword,
  };

  /// Returns the redirect target for a navigation, or null to allow it through.
  ///
  /// Rules:
  /// - Splash always redirects: main if logged in, login if not.
  /// - Any protected route redirects to login when not logged in.
  /// - Public auth routes redirect to main when already logged in.
  String? redirect(BuildContext context, GoRouterState state) {
    final path = state.uri.path;

    // Splash is the bootstrap screen: let it render so it can resolve the
    // saved language and then navigate to main/welcome itself.
    if (path == AppRoutes.splash) {
      return null;
    }
    if (!_isLoggedIn && !_publicRoutes.contains(path)) {
      return AppRoutes.welcome;
    }
    if (_isLoggedIn && _publicRoutes.contains(path)) {
      return AppRoutes.main;
    }
    return null;
  }
}
