import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../storage/secure_storage/secure_storage.dart';
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
  RouterGuard._({required bool isLoggedIn}) : _isLoggedIn = isLoggedIn;

  /// Reads the stored access token to determine the initial auth state.
  ///
  /// Call this during app bootstrap while the native splash is still visible,
  /// so [redirect] can run synchronously — no black screen on first navigation.
  static Future<RouterGuard> create(SecureStorage secureStorage) async {
    final isLoggedIn = (await secureStorage.getAccessToken()) != null;
    return RouterGuard._(isLoggedIn: isLoggedIn);
  }

  bool _isLoggedIn;

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

  /// Returns the redirect target for a navigation, or null to allow it through.
  ///
  /// Rules:
  /// - Splash always redirects: main if logged in, login if not.
  /// - Any protected route redirects to login when not logged in.
  /// - Login redirects to main when already logged in.
  String? redirect(BuildContext context, GoRouterState state) {
    final path = state.uri.path;

    if (path == AppRoutes.splash) {
      return _isLoggedIn ? AppRoutes.main : AppRoutes.login;
    }
    if (!_isLoggedIn && path != AppRoutes.login) {
      return AppRoutes.login;
    }
    if (_isLoggedIn && path == AppRoutes.login) {
      return AppRoutes.main;
    }
    return null;
  }
}
