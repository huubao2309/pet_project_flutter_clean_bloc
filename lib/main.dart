import 'package:benny_style/theme/theme_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'base/app_constants.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'environments/env_type.dart';

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
  final Locale startLocale;

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: AppConstants.supportedLocales,
      path: AppConstants.translationsPath,
      fallbackLocale: AppConstants.fallbackLocale,
      startLocale: startLocale,
      saveLocale: false,
      child: Builder(
        builder: (ctx) => MaterialApp.router(
          // Rebuild the whole app subtree when the locale changes so every
          // visible page re-runs `.tr()`.
          key: ValueKey(ctx.locale),
          localizationsDelegates: ctx.localizationDelegates,
          supportedLocales: ctx.supportedLocales,
          locale: ctx.locale,
          title: envType.displayAppName,
          debugShowCheckedModeBanner: false,
          theme: _buildTheme(),
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
        ),
      ),
    );
  }

  /// Material [ThemeData] for the app. Custom widgets use the design tokens
  /// directly; this mainly covers Material defaults (scaffold bg, dialog /
  /// bottom-sheet surfaces, ripple, default text colours).
  ThemeData _buildTheme() {
    final colors = getIt<ThemeState>().colors;
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: colors.surfaceBackground,
      colorScheme: ColorScheme.fromSeed(seedColor: colors.brand600),
    );
  }
}
