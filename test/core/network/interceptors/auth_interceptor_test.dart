import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_project_flutter_clean_bloc/core/network/interceptors/auth_interceptor.dart';
import 'package:pet_project_flutter_clean_bloc/core/storage/secure_storage/secure_storage.dart';

class _MockSecureStorage extends Mock implements SecureStorage {}

class _MockRequestHandler extends Mock implements RequestInterceptorHandler {}

class _MockErrorHandler extends Mock implements ErrorInterceptorHandler {}

void main() {
  late _MockSecureStorage storage;
  late AuthInterceptor interceptor;

  setUp(() {
    storage = _MockSecureStorage();
    interceptor = AuthInterceptor(secureStorage: storage);
  });

  group('onRequest', () {
    test('attaches the Bearer token when present, then continues', () async {
      when(() => storage.getAccessToken()).thenAnswer((_) async => 'tok');
      final options = RequestOptions(path: '/x');
      final handler = _MockRequestHandler();

      await interceptor.onRequest(options, handler);

      expect(options.headers['Authorization'], 'Bearer tok');
      verify(() => handler.next(options)).called(1);
    });

    test('adds no Authorization header when there is no token', () async {
      when(() => storage.getAccessToken()).thenAnswer((_) async => null);
      final options = RequestOptions(path: '/x');
      final handler = _MockRequestHandler();

      await interceptor.onRequest(options, handler);

      expect(options.headers.containsKey('Authorization'), isFalse);
      verify(() => handler.next(options)).called(1);
    });
  });

  group('onError', () {
    test('passes a 401 through to the next handler', () {
      final err = DioException(
        requestOptions: RequestOptions(path: '/x'),
        response: Response(
          requestOptions: RequestOptions(path: '/x'),
          statusCode: 401,
        ),
      );
      final handler = _MockErrorHandler();

      interceptor.onError(err, handler);

      verify(() => handler.next(err)).called(1);
    });

    test('passes a non-401 through to the next handler', () {
      final err = DioException(
        requestOptions: RequestOptions(path: '/x'),
        response: Response(
          requestOptions: RequestOptions(path: '/x'),
          statusCode: 500,
        ),
      );
      final handler = _MockErrorHandler();

      interceptor.onError(err, handler);

      verify(() => handler.next(err)).called(1);
    });
  });
}
