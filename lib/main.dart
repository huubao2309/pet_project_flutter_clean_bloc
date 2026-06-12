import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'base/app_constants.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'environments/env_type.dart';

class MyApp extends StatelessWidget {
  const MyApp({required this.envType, super.key});

  final EnvType envType;

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: AppConstants.supportedLocales,
      path: AppConstants.translationsPath,
      fallbackLocale: AppConstants.fallbackLocale,
      child: Builder(
        builder: (ctx) => MaterialApp.router(
          localizationsDelegates: ctx.localizationDelegates,
          supportedLocales: ctx.supportedLocales,
          locale: ctx.locale,
          title: envType.displayAppName,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
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
}
