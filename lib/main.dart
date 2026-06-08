import 'package:flutter/material.dart';

import 'environments/env_type.dart';
import 'features/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.envType, required this.baseUrl});

  final EnvType envType;
  final String baseUrl;

  void onInit() {
    // TODO: init LocalizationService and Deeplink
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: envType.displayAapName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      // A corner banner makes the active flavor obvious for non-prod builds.
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
      home: HomePage(baseUrl: baseUrl, envType: envType),
    );
  }
}
