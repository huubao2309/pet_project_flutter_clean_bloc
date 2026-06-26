import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pet_project_flutter_clean_bloc/core/storage/local_storage/local_storage_wrapper/hive_storage_impl.dart';

/// Exercises the real wrapper against a real (pure-Dart) Hive box in a temp
/// directory — `Hive.init` needs no platform plugin (unlike `initFlutter`).
void main() {
  setUpAll(() {
    final dir = Directory.systemTemp.createTempSync('hive_local_test');
    Hive.init(dir.path);
  });

  late Box<String> box;
  late HiveStorageImpl store;

  setUp(() async {
    box = await Hive.openBox<String>('local_test');
    store = HiveStorageImpl(box);
  });

  tearDown(() async {
    await box.deleteFromDisk();
  });

  test('setString then getString round-trips', () async {
    await store.setString('k', 'v');
    expect(store.getString('k'), 'v');
  });

  test('getString returns null for a missing key', () {
    expect(store.getString('missing'), isNull);
  });

  test('containsKey reflects writes', () async {
    expect(store.containsKey('k'), isFalse);
    await store.setString('k', 'v');
    expect(store.containsKey('k'), isTrue);
  });

  test('remove deletes a single key', () async {
    await store.setString('k', 'v');
    await store.remove('k');
    expect(store.getString('k'), isNull);
  });

  test('clear wipes everything', () async {
    await store.setString('a', '1');
    await store.setString('b', '2');
    await store.clear();
    expect(store.containsKey('a'), isFalse);
    expect(store.containsKey('b'), isFalse);
  });
}
