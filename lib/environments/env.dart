import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../core/di/injection.dart';
import '../main.dart';
import 'env_type.dart';

abstract class Env {
  abstract final String baseUrl;
  abstract final EnvType envType;

  Env() {
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    await EasyLocalization.ensureInitialized();

    await configureDependencies(this);

    _initStyle();
    _initProvider();
    _initServices();
    _initRepoAndUseCase();
    await _initLocalStorage();

    runApp(MyApp(envType: envType));
    FlutterNativeSplash.remove();
  }

  void _initProvider() {}

  void _initServices() {}

  void _initRepoAndUseCase() {}

  void _initStyle() {}

  Future<void> _initLocalStorage() async {}
}
