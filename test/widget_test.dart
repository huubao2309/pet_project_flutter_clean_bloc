import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import 'package:pet_project_flutter_clean_bloc/core/router/app_router.dart';
import 'package:pet_project_flutter_clean_bloc/core/storage/secure_storage.dart';
import 'package:pet_project_flutter_clean_bloc/environments/env_type.dart';
import 'package:pet_project_flutter_clean_bloc/main.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  setUpAll(() async {
    await EasyLocalization.ensureInitialized();

    // Register minimum GetIt dependencies needed for MyApp.
    if (!GetIt.instance.isRegistered<SecureStorage>()) {
      GetIt.instance.registerSingleton<SecureStorage>(
        const SecureStorage(FlutterSecureStorage()),
      );
    }
    if (!GetIt.instance.isRegistered<AppRouter>()) {
      GetIt.instance.registerSingleton<AppRouter>(
        AppRouter(secureStorage: GetIt.instance<SecureStorage>()),
      );
    }
  });

  testWidgets('MyApp renders without crashing', (tester) async {
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('vi'), Locale('en')],
        path: 'assets/translations',
        fallbackLocale: const Locale('vi'),
        child: const MyApp(envType: EnvType.staging),
      ),
    );
    await tester.pump();
    // Splash → redirect handled by router; app must render a MaterialApp.
    expect(find.byType(MaterialApp), findsNothing); // MaterialApp.router, not MaterialApp
    expect(find.byType(Router), findsOneWidget);
  });
}
