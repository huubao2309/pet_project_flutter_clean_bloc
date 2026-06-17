import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../base/app_constants.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/presentation/presentation.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/router/app_routes.dart';
import '../view_model/splash_state.dart';
import '../view_model/splash_view_model.dart';

/// First screen shown on launch. Resolves the saved language, applies it, then
/// routes to main or welcome depending on the auth state.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<SplashViewModel>(
      create: (_) => getIt<SplashViewModel>()..bootstrap(),
      child: const _SplashView(),
    );
  }
}

class _SplashView extends StatelessWidget {
  const _SplashView();

  @override
  Widget build(BuildContext context) {
    return ViewModelListener<SplashViewModel, SplashState>(
      listenWhen: (_, current) => current is SplashReady,
      listener: (context, state) {
        if (state is! SplashReady) {
          return;
        }
        // Apply the saved language (async; the keyed MaterialApp rebuilds), then
        // route to the right entry point based on auth.
        context.setLocale(state.locale);
        final target =
            getIt<AppRouter>().isLoggedIn ? AppRoutes.main : AppRoutes.welcome;
        context.go(target);
      },
      child: const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image(
                image: AssetImage('assets/images/splash_logo.png'),
                width: 120,
                height: 120,
              ),
              SizedBox(height: 24),
              Text(
                kAppName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
