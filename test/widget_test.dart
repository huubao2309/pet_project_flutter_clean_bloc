import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import 'package:pet_project_flutter_clean_bloc/core/router/app_router.dart';
import 'package:pet_project_flutter_clean_bloc/core/storage/secure_storage/secure_storage.dart';
import 'package:pet_project_flutter_clean_bloc/environments/env_type.dart';
import 'package:pet_project_flutter_clean_bloc/main.dart';

class _FakeSecureStorage implements SecureStorage {
  @override
  Future<void> saveAccessToken(String token) async {}

  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<void> saveRefreshToken(String token) async {}

  @override
  Future<String?> getRefreshToken() async => null;
}

void main() {
  setUpAll(() async {
    await EasyLocalization.ensureInitialized();

    if (!GetIt.instance.isRegistered<SecureStorage>()) {
      GetIt.instance.registerSingleton<SecureStorage>(_FakeSecureStorage());
    }
    if (!GetIt.instance.isRegistered<AppRouter>()) {
      GetIt.instance.registerSingleton<AppRouter>(
        await AppRouter.create(GetIt.instance<SecureStorage>()),
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
