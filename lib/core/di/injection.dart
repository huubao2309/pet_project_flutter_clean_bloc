import 'package:get_it/get_it.dart';

import '../../environments/env.dart';
import '../network/dio_client.dart';
import '../router/app_router.dart';
import '../storage/local_storage/local_storage.dart';
import '../storage/local_storage/local_storage_impl.dart';
import '../storage/secure_storage/secure_storage.dart';
import '../storage/secure_storage/secure_storage_impl.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies(Env env) async {
  // --- Storage ---
  getIt.registerSingleton<LocalStorage>(await LocalStorageImpl.create());
  getIt.registerSingleton<SecureStorage>(await SecureStorageImpl.create());

  // --- Network ---
  getIt.registerSingleton<DioClient>(
    DioClient(baseUrl: env.baseUrl, secureStorage: getIt<SecureStorage>(), envType: env.envType),
  );

  // --- Router ---
  getIt.registerSingleton<AppRouter>(await AppRouter.create(getIt<SecureStorage>()));
}
