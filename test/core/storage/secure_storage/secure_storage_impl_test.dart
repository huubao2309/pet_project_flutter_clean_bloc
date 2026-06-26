import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_project_flutter_clean_bloc/core/storage/secure_storage/secure_storage_impl.dart';
import 'package:pet_project_flutter_clean_bloc/core/storage/secure_storage/secure_storage_wrapper/secure_key_value_storage.dart';

class MockSecureKeyValueStore extends Mock implements SecureKeyValueStore {}

void main() {
  late MockSecureKeyValueStore store;
  late SecureStorageImpl storage;

  setUp(() {
    store = MockSecureKeyValueStore();
    storage = SecureStorageImpl(store: store);
    when(() => store.write(key: any(named: 'key'), value: any(named: 'value')))
        .thenAnswer((_) async {});
    when(() => store.delete(key: any(named: 'key'))).thenAnswer((_) async {});
    when(() => store.deleteAll()).thenAnswer((_) async {});
  });

  test('saves the access token under the access_token key', () async {
    await storage.saveAccessToken('a-token');
    verify(() => store.write(key: 'access_token', value: 'a-token')).called(1);
  });

  test('saves the refresh token under the refresh_token key', () async {
    await storage.saveRefreshToken('r-token');
    verify(() => store.write(key: 'refresh_token', value: 'r-token')).called(1);
  });

  test('reads the access token from the store', () async {
    when(() => store.read(key: 'access_token')).thenAnswer((_) async => 'a');
    expect(await storage.getAccessToken(), 'a');
  });

  test('reads the refresh token from the store', () async {
    when(() => store.read(key: 'refresh_token')).thenAnswer((_) async => 'r');
    expect(await storage.getRefreshToken(), 'r');
  });

  test('clearTokens deletes both tokens (and nothing else)', () async {
    await storage.clearTokens();
    verify(() => store.delete(key: 'access_token')).called(1);
    verify(() => store.delete(key: 'refresh_token')).called(1);
    verifyNever(() => store.deleteAll());
  });

  test('clearAll wipes the whole store', () async {
    await storage.clearAll();
    verify(() => store.deleteAll()).called(1);
  });
}
