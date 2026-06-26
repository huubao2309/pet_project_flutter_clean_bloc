import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/router/app_routes.dart';

void main() {
  test('every route is an absolute path', () {
    final routes = <String>[
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
    for (final route in routes) {
      expect(route, startsWith('/'), reason: route);
    }
  });

  test('route paths are unique', () {
    final routes = <String>[
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
    expect(routes.toSet().length, routes.length);
  });

  test('splash is the root path', () {
    expect(AppRoutes.splash, '/');
  });
}
