import 'package:benny_style/theme/theme_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'base/app_constants.dart';
import 'core/di/injection.dart';
import 'core/presentation/presentation.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme_mode.dart';
import 'core/theme/theme_view_model.dart';
import 'environments/env_type.dart';

/// App-wide scroll behavior that removes the overscroll indicator (Android's
/// Material stretch / glow). The stretch indicator is known to schedule a
/// rebuild during layout, crashing scroll views with "Build scheduled during
/// frame".
class _AppScrollBehavior extends MaterialScrollBehavior {
  const _AppScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({required this.envType, required this.startLocale, super.key});

  final EnvType envType;

  /// Language resolved at boot (saved language or fallback). Passed to
  /// EasyLocalization so the app starts in the right language — avoids applying
  /// it later on the splash, which would recreate the locale-keyed MaterialApp.
  final Locale startLocale;

  @override
  Widget build(BuildContext context) {
    // The theme controller lives above MaterialApp so the whole app rebuilds
    // (and routed pages can read/toggle it) when Light/Dark mode changes.
    return ViewModelProvider<ThemeViewModel>(
      create: (_) => getIt<ThemeViewModel>(),
      child: EasyLocalization(
        supportedLocales: AppConstants.supportedLocales,
        path: AppConstants.translationsPath,
        fallbackLocale: AppConstants.fallbackLocale,
        startLocale: startLocale,
        // LocalStorage is our single source of truth for the language; disable
        // easy_localization's own persistence. The saved language is loaded and
        // applied on the splash screen (SplashViewModel + GetLanguageUseCase).
        saveLocale: false,
        child: Builder(
          builder: (ctx) => ViewModelBuilder<ThemeViewModel, AppThemeMode>(
            builder: (context, mode) {
              // Drive the brightness-aware design tokens for this frame; the
              // whole subtree below re-reads `theme.colors.*` with this mode.
              getIt<ThemeState>().colors.brightness = mode.brightness;
              return MaterialApp.router(
                // Rebuild the whole app subtree when locale OR theme changes so
                // every visible page re-runs `.tr()` and re-reads colours.
                key: ValueKey('${ctx.locale}-${mode.name}'),
                localizationsDelegates: ctx.localizationDelegates,
                supportedLocales: ctx.supportedLocales,
                locale: ctx.locale,
                title: envType.displayAppName,
                debugShowCheckedModeBanner: false,
                theme: _buildTheme(mode),
                // Disable Android's stretch overscroll indicator: it schedules a
                // rebuild during layout at scroll-end, throwing "Build scheduled
                // during frame" inside scroll views.
                scrollBehavior: const _AppScrollBehavior(),
                routerConfig: getIt<AppRouter>().router,
                builder: (context, child) {
                  if (envType.isProduction || child == null) {
                    return child ?? const SizedBox.shrink();
                  }
                  return Banner(
                    location: BannerLocation.topEnd,
                    message: envType.name.toUpperCase(),
                    color: envType.isStaging ? Colors.green : Colors.orange,
                    child: child,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  /// Material [ThemeData] for the given mode. Custom widgets use the design
  /// tokens directly; this mainly covers Material defaults (scaffold bg, dialog
  /// / bottom-sheet surfaces, ripple, default text colours).
  ThemeData _buildTheme(AppThemeMode mode) {
    final colors = getIt<ThemeState>().colors;
    return ThemeData(
      useMaterial3: true,
      brightness: mode.brightness,
      scaffoldBackgroundColor: colors.surfaceBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: colors.brand600,
        brightness: mode.brightness,
      ),
    );
  }
}
