import 'package:flutter/widgets.dart' show Brightness;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_project_flutter_clean_bloc/core/storage/local_storage/local_storage.dart';
import 'package:pet_project_flutter_clean_bloc/core/theme/app_theme_mode.dart';
import 'package:pet_project_flutter_clean_bloc/core/theme/theme_view_model.dart';

class MockLocalStorage extends Mock implements LocalStorage {}

void main() {
  late MockLocalStorage storage;

  setUp(() {
    storage = MockLocalStorage();
    when(() => storage.setThemeMode(value: any(named: 'value')))
        .thenAnswer((_) async {});
  });

  ThemeViewModel build(Brightness brightness) => ThemeViewModel(
        localStorage: storage,
        systemBrightness: brightness,
      );

  group('initial resolution', () {
    test('uses the saved mode when present', () {
      when(() => storage.getThemeMode()).thenReturn('dark');
      final vm = build(Brightness.light);
      expect(vm.currentState, AppThemeMode.dark);
      expect(vm.isDark, isTrue);
      // Already saved: should not re-persist on construction.
      verifyNever(() => storage.setThemeMode(value: any(named: 'value')));
      vm.close();
    });

    test('seeds from system brightness and persists on first launch', () {
      when(() => storage.getThemeMode()).thenReturn(null);
      final vm = build(Brightness.dark);
      expect(vm.currentState, AppThemeMode.dark);
      verify(() => storage.setThemeMode(value: 'dark')).called(1);
      vm.close();
    });

    test('seeds light from a light system on first launch', () {
      when(() => storage.getThemeMode()).thenReturn(null);
      final vm = build(Brightness.light);
      expect(vm.currentState, AppThemeMode.light);
      verify(() => storage.setThemeMode(value: 'light')).called(1);
      vm.close();
    });
  });

  group('setDark', () {
    test('switches mode, emits and persists', () async {
      when(() => storage.getThemeMode()).thenReturn('light');
      final vm = build(Brightness.light);
      final states = <AppThemeMode>[];
      final sub = vm.stream.listen(states.add);

      await vm.setDark(value: true);
      await sub.cancel();

      expect(states, [AppThemeMode.dark]);
      expect(vm.currentState, AppThemeMode.dark);
      verify(() => storage.setThemeMode(value: 'dark')).called(1);
      await vm.close();
    });

    test('is a no-op when the mode is unchanged', () async {
      when(() => storage.getThemeMode()).thenReturn('light');
      final vm = build(Brightness.light);
      final states = <AppThemeMode>[];
      final sub = vm.stream.listen(states.add);

      await vm.setDark(value: false);
      await sub.cancel();

      expect(states, isEmpty);
      verifyNever(() => storage.setThemeMode(value: any(named: 'value')));
      await vm.close();
    });
  });

  test('toggle flips the current mode', () async {
    when(() => storage.getThemeMode()).thenReturn('light');
    final vm = build(Brightness.light);

    await vm.toggle();
    expect(vm.currentState, AppThemeMode.dark);

    await vm.toggle();
    expect(vm.currentState, AppThemeMode.light);
    await vm.close();
  });
}
