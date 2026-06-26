import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/storage/local_storage/local_storage_wrapper/shared_preferences_storage_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Exercises the real wrapper against SharedPreferences' in-memory mock backend
/// (`setMockInitialValues`) — no platform channel involved.
void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });

  test('setString then getString round-trips', () async {
    final store = await SharedPreferencesStorageImpl.create();

    await store.setString('k', 'v');

    expect(store.getString('k'), 'v');
  });

  test('getString returns null for an unknown key', () async {
    final store = await SharedPreferencesStorageImpl.create();
    expect(store.getString('missing'), isNull);
  });

  test('containsKey reflects whether a key was written', () async {
    final store = await SharedPreferencesStorageImpl.create();

    expect(store.containsKey('k'), isFalse);
    await store.setString('k', 'v');
    expect(store.containsKey('k'), isTrue);
  });

  test('remove deletes a single key', () async {
    final store = await SharedPreferencesStorageImpl.create();
    await store.setString('k', 'v');

    await store.remove('k');

    expect(store.getString('k'), isNull);
  });

  test('clear wipes everything', () async {
    final store = await SharedPreferencesStorageImpl.create();
    await store.setString('a', '1');
    await store.setString('b', '2');

    await store.clear();

    expect(store.containsKey('a'), isFalse);
    expect(store.containsKey('b'), isFalse);
  });

  test('create seeds from existing preferences', () async {
    SharedPreferences.setMockInitialValues({'seed': 'value'});

    final store = await SharedPreferencesStorageImpl.create();

    expect(store.getString('seed'), 'value');
  });
}
