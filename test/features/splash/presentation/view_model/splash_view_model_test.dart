import 'dart:ui' show Locale;

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pet_project_flutter_clean_bloc/base/app_constants.dart';
import 'package:pet_project_flutter_clean_bloc/core/localization/domain/use_cases/get_language_use_case.dart';
import 'package:pet_project_flutter_clean_bloc/core/security/domain/use_cases/clear_stale_secure_storage_use_case.dart';
import 'package:pet_project_flutter_clean_bloc/core/use_case/use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/use_cases/is_logged_in_use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/splash/presentation/view_model/splash_state.dart';
import 'package:pet_project_flutter_clean_bloc/features/splash/presentation/view_model/splash_view_model.dart';

import '../../../../helpers/test_setup.dart';

class MockClearStale extends Mock
    implements ClearStaleSecureStorageUseCase {}

class MockIsLoggedIn extends Mock implements IsLoggedInUseCase {}

class MockGetLanguage extends Mock implements GetLanguageUseCase {}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await ensureTestBinding();
    registerFallbackValue(const NoParams());
  });

  late MockClearStale clearStale;
  late MockIsLoggedIn isLoggedIn;
  late MockGetLanguage getLanguage;

  setUp(() {
    clearStale = MockClearStale();
    isLoggedIn = MockIsLoggedIn();
    getLanguage = MockGetLanguage();
    when(() => clearStale.execute(any())).thenAnswer((_) async {});
  });

  SplashViewModel build() => SplashViewModel(
        clearStaleSecureStorageUseCase: clearStale,
        isLoggedInUseCase: isLoggedIn,
        getLanguageUseCase: getLanguage,
      );

  test('starts in SplashLoading', () {
    when(() => isLoggedIn.execute(any())).thenAnswer((_) async => false);
    when(() => getLanguage.execute(any())).thenAnswer((_) async => null);
    final vm = build();
    expect(vm.currentState, isA<SplashLoading>());
    vm.close();
  });

  test('bootstrap clears stale storage, resolves auth and saved locale',
      () async {
    when(() => isLoggedIn.execute(any())).thenAnswer((_) async => true);
    when(() => getLanguage.execute(any()))
        .thenAnswer((_) async => const Locale('en'));
    final vm = build();

    await vm.bootstrap();

    verify(() => clearStale.execute(any())).called(1);
    final ready = vm.currentState as SplashReady;
    expect(ready.isLoggedIn, isTrue);
    expect(ready.locale, const Locale('en'));
    await vm.close();
  });

  test('bootstrap falls back to default locale when none saved', () async {
    when(() => isLoggedIn.execute(any())).thenAnswer((_) async => false);
    when(() => getLanguage.execute(any())).thenAnswer((_) async => null);
    final vm = build();

    await vm.bootstrap();

    final ready = vm.currentState as SplashReady;
    expect(ready.locale, AppConstants.fallbackLocale);
    expect(ready.isLoggedIn, isFalse);
    await vm.close();
  });

  test('bootstrap falls back when saved locale is unsupported', () async {
    when(() => isLoggedIn.execute(any())).thenAnswer((_) async => false);
    when(() => getLanguage.execute(any()))
        .thenAnswer((_) async => const Locale('fr'));
    final vm = build();

    await vm.bootstrap();

    expect((vm.currentState as SplashReady).locale,
        AppConstants.fallbackLocale,);
    await vm.close();
  });
}
