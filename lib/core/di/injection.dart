import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../../environments/env.dart';
import '../network/dio_client.dart';
import '../router/app_router.dart';
import '../storage/local_storage.dart';
import '../storage/secure_storage.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies(Env env) async {
  // --- Storage ---
  final localStorage = await LocalStorage.create();
  getIt.registerSingleton<LocalStorage>(localStorage);

  getIt.registerSingleton<SecureStorage>(
    const SecureStorage(FlutterSecureStorage()),
  );

  // --- Network ---
  getIt.registerSingleton<DioClient>(
    DioClient(
      baseUrl: env.baseUrl,
      secureStorage: getIt<SecureStorage>(),
      envType: env.envType,
    ),
  );

  // --- Router ---
  getIt.registerSingleton<AppRouter>(
    AppRouter(secureStorage: getIt<SecureStorage>()),
  );
}
