import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_project_flutter_clean_bloc/core/router/app_routes.dart';
import 'package:pet_project_flutter_clean_bloc/core/router/router_guard.dart';

class _MockGoRouterState extends Mock implements GoRouterState {}

class _FakeBuildContext extends Fake implements BuildContext {}

void main() {
  late RouterGuard guard;
  final context = _FakeBuildContext();

  setUp(() => guard = RouterGuard());

  GoRouterState stateFor(String path) {
    final state = _MockGoRouterState();
    when(() => state.uri).thenReturn(Uri.parse(path));
    return state;
  }

  group('auth state', () {
    test('starts logged out', () {
      expect(guard.isLoggedIn, isFalse);
    });

    test('onLogin/onLogout flip the flag and notify listeners', () {
      var notified = 0;
      guard.addListener(() => notified++);

      guard.onLogin();
      expect(guard.isLoggedIn, isTrue);

      guard.onLogout();
      expect(guard.isLoggedIn, isFalse);

      expect(notified, 2);
    });

    test('setLoggedIn updates the flag WITHOUT notifying', () {
      var notified = 0;
      guard.addListener(() => notified++);

      guard.setLoggedIn(value: true);

      expect(guard.isLoggedIn, isTrue);
      expect(notified, 0);
    });
  });

  group('redirect', () {
    test('splash always renders (returns null) regardless of auth', () {
      expect(guard.redirect(context, stateFor(AppRoutes.splash)), isNull);
      guard.setLoggedIn(value: true);
      expect(guard.redirect(context, stateFor(AppRoutes.splash)), isNull);
    });

    test('logged out: protected route redirects to welcome', () {
      expect(
        guard.redirect(context, stateFor(AppRoutes.main)),
        AppRoutes.welcome,
      );
      expect(
        guard.redirect(context, stateFor(AppRoutes.qrScan)),
        AppRoutes.welcome,
      );
    });

    test('logged out: public auth routes pass through', () {
      for (final route in [
        AppRoutes.welcome,
        AppRoutes.login,
        AppRoutes.signUp,
        AppRoutes.registerPassword,
        AppRoutes.forgotPassword,
        AppRoutes.resetPassword,
        AppRoutes.otp,
      ]) {
        expect(guard.redirect(context, stateFor(route)), isNull, reason: route);
      }
    });

    test('logged in: public auth route redirects to main', () {
      guard.setLoggedIn(value: true);
      expect(
        guard.redirect(context, stateFor(AppRoutes.login)),
        AppRoutes.main,
      );
    });

    test('logged in: protected route passes through', () {
      guard.setLoggedIn(value: true);
      expect(guard.redirect(context, stateFor(AppRoutes.main)), isNull);
    });
  });
}
