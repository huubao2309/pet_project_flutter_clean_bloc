import 'package:benny_style/theme/theme_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    final theme = getIt<ThemeState>();

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
      child: Scaffold(
        body: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [theme.colors.brand600, theme.colors.brand800],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 3),
                const _LogoBadge(),
                SizedBox(height: theme.spacing.spacing24),
                Text(
                  kAppName,
                  style: theme.textStyle.heading.copyWith(
                    color: theme.colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(flex: 4),
                SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor:
                        AlwaysStoppedAnimation(theme.colors.secondary500),
                  ),
                ),
                SizedBox(height: theme.spacing.spacing32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The navy/amber house-mark rendered directly on the navy gradient. The light
/// variant (white walls, amber roof) reads cleanly without a backing plate.
class _LogoBadge extends StatelessWidget {
  const _LogoBadge();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/logo_mark.svg',
      width: 116,
      height: 116,
    );
  }
}
