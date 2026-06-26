import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_project_flutter_clean_bloc/core/storage/secure_storage/secure_storage_wrapper/flutter_secure_key_value_storage_impl.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockFlutterSecureStorage plugin;
  late FlutterSecureKeyValueStoreImpl store;

  setUp(() {
    plugin = MockFlutterSecureStorage();
    store = FlutterSecureKeyValueStoreImpl(plugin);
    when(() => plugin.write(key: any(named: 'key'), value: any(named: 'value')))
        .thenAnswer((_) async {});
    when(() => plugin.delete(key: any(named: 'key'))).thenAnswer((_) async {});
    when(() => plugin.deleteAll()).thenAnswer((_) async {});
  });

  group('after loadAllDataIntoMemory', () {
    setUp(() {
      when(() => plugin.readAll()).thenAnswer((_) async => {'access_token': 'a'});
    });

    test('reads are served from the in-memory cache (no channel read)',
        () async {
      await store.loadAllDataIntoMemory();

      expect(await store.read(key: 'access_token'), 'a');
      expect(await store.read(key: 'missing'), isNull);
      verifyNever(() => plugin.read(key: any(named: 'key')));
    });

    test('containsKey checks the cache', () async {
      await store.loadAllDataIntoMemory();

      expect(await store.containsKey(key: 'access_token'), isTrue);
      expect(await store.containsKey(key: 'missing'), isFalse);
    });

    test('write is write-through: cache updated and plugin persisted', () async {
      await store.loadAllDataIntoMemory();

      await store.write(key: 'refresh_token', value: 'r');

      expect(await store.read(key: 'refresh_token'), 'r');
      verify(() => plugin.write(key: 'refresh_token', value: 'r')).called(1);
    });

    test('writing null deletes from cache and plugin', () async {
      await store.loadAllDataIntoMemory();

      await store.write(key: 'access_token', value: null);

      expect(await store.read(key: 'access_token'), isNull);
      verify(() => plugin.delete(key: 'access_token')).called(1);
    });

    test('readAll returns an unmodifiable snapshot of the cache', () async {
      await store.loadAllDataIntoMemory();

      final all = await store.readAll();
      expect(all, {'access_token': 'a'});
      expect(() => all['x'] = 'y', throwsUnsupportedError);
    });

    test('delete removes from cache and plugin', () async {
      await store.loadAllDataIntoMemory();

      await store.delete(key: 'access_token');

      expect(await store.read(key: 'access_token'), isNull);
      verify(() => plugin.delete(key: 'access_token')).called(1);
    });

    test('deleteAll clears cache and plugin', () async {
      await store.loadAllDataIntoMemory();

      await store.deleteAll();

      expect(await store.readAll(), isEmpty);
      verify(() => plugin.deleteAll()).called(1);
    });
  });

  group('before loadAllDataIntoMemory', () {
    test('read falls back to the plugin', () async {
      when(() => plugin.read(key: 'access_token')).thenAnswer((_) async => 'a');

      expect(await store.read(key: 'access_token'), 'a');
      verify(() => plugin.read(key: 'access_token')).called(1);
    });

    test('containsKey falls back to the plugin', () async {
      when(() => plugin.containsKey(key: 'access_token'))
          .thenAnswer((_) async => true);

      expect(await store.containsKey(key: 'access_token'), isTrue);
      verify(() => plugin.containsKey(key: 'access_token')).called(1);
    });
  });
}
