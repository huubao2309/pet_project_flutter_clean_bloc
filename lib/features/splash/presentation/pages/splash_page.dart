import 'package:benny_style/theme/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/benny_image.dart';
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
        // Language is already applied at boot (env.dart → MyApp.startLocale), so
        // the splash only routes — calling setLocale here would recreate the
        // locale-keyed MaterialApp and flash black during the transition.
        final target =
            getIt<AppRouter>().isLoggedIn ? AppRoutes.main : AppRoutes.welcome;
        context.go(target);
      },
      child: Scaffold(
        backgroundColor: theme.colors.heroTop,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [theme.colors.heroTop, theme.colors.heroBottom],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 3),
                const _LogoBadge(),
                const Spacer(flex: 4),
                SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation(theme.colors.secondary500),
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
      BennyImage.logo,
      width: 116,
      height: 116,
    );
  }
}
