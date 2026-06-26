import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pet_project_flutter_clean_bloc/core/storage/secure_storage/secure_storage_wrapper/hive_secure_key_value_storage_impl.dart';

/// Real Hive box (pure-Dart, temp dir). The cache / write-through logic is the
/// same whether or not the box is encrypted, so a plain box is enough to test
/// it; encryption is wired only in the production `create()`.
void main() {
  setUpAll(() {
    final dir = Directory.systemTemp.createTempSync('hive_secure_test');
    Hive.init(dir.path);
  });

  late Box<String> box;
  late HiveSecureKeyValueStoreImpl store;

  setUp(() async {
    box = await Hive.openBox<String>('secure_test');
    store = HiveSecureKeyValueStoreImpl(box);
  });

  tearDown(() async {
    await box.deleteFromDisk();
  });

  group('before loadAllDataIntoMemory', () {
    test('read falls back to the box', () async {
      await box.put('access_token', 'a');
      expect(await store.read(key: 'access_token'), 'a');
    });

    test('containsKey falls back to the box', () async {
      await box.put('access_token', 'a');
      expect(await store.containsKey(key: 'access_token'), isTrue);
      expect(await store.containsKey(key: 'missing'), isFalse);
    });
  });

  group('after loadAllDataIntoMemory', () {
    test('reads are served from the cache', () async {
      await box.put('access_token', 'a');
      await store.loadAllDataIntoMemory();

      expect(await store.read(key: 'access_token'), 'a');
      expect(await store.read(key: 'missing'), isNull);
    });

    test('write is write-through (cache + box)', () async {
      await store.loadAllDataIntoMemory();

      await store.write(key: 'refresh_token', value: 'r');

      expect(await store.read(key: 'refresh_token'), 'r');
      expect(box.get('refresh_token'), 'r');
    });

    test('writing null deletes from cache and box', () async {
      await box.put('access_token', 'a');
      await store.loadAllDataIntoMemory();

      await store.write(key: 'access_token', value: null);

      expect(await store.read(key: 'access_token'), isNull);
      expect(box.containsKey('access_token'), isFalse);
    });

    test('readAll returns an unmodifiable snapshot', () async {
      await box.put('access_token', 'a');
      await store.loadAllDataIntoMemory();

      final all = await store.readAll();
      expect(all, {'access_token': 'a'});
      expect(() => all['x'] = 'y', throwsUnsupportedError);
    });

    test('delete removes from cache and box', () async {
      await box.put('access_token', 'a');
      await store.loadAllDataIntoMemory();

      await store.delete(key: 'access_token');

      expect(await store.read(key: 'access_token'), isNull);
      expect(box.containsKey('access_token'), isFalse);
    });

    test('deleteAll clears cache and box', () async {
      await box.put('a', '1');
      await box.put('b', '2');
      await store.loadAllDataIntoMemory();

      await store.deleteAll();

      expect(await store.readAll(), isEmpty);
      expect(box.isEmpty, isTrue);
    });
  });
}
