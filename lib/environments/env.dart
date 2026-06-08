import 'package:flutter/material.dart';
import 'package:pet_project_flutter_clean_bloc/main.dart';
import 'env_type.dart';

abstract class Env {
  abstract final String baseUrl;
  abstract final EnvType envType;


  Env() {
    _widgetsBinding();
    _init();
  }

  _widgetsBinding() {
    WidgetsFlutterBinding.ensureInitialized();
    // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  }

  Future _init() async {
    _initStyle();
    _initProvider();
    _initServices();
    _initRepoAndUseCase();
    await _initLocalStorage();

    runApp(MyApp(baseUrl: baseUrl, envType: envType));
  }

  _initProvider() {}

  _initServices() {}

  _initRepoAndUseCase() {}

  _initStyle() {}

  Future _initLocalStorage() async {}
}
