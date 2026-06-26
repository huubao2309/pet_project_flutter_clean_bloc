import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_project_flutter_clean_bloc/core/network/interceptors/logging_interceptor.dart';

class _MockRequestHandler extends Mock implements RequestInterceptorHandler {}

class _MockResponseHandler extends Mock implements ResponseInterceptorHandler {}

class _MockErrorHandler extends Mock implements ErrorInterceptorHandler {}

void main() {
  final interceptor = LoggingInterceptor();

  test('onRequest forwards the options to the next handler', () {
    final options = RequestOptions(path: '/x', data: {'a': 1});
    final handler = _MockRequestHandler();

    interceptor.onRequest(options, handler);

    verify(() => handler.next(options)).called(1);
  });

  test('onResponse forwards the response to the next handler', () {
    final response = Response<dynamic>(
      requestOptions: RequestOptions(path: '/x'),
      statusCode: 200,
    );
    final handler = _MockResponseHandler();

    interceptor.onResponse(response, handler);

    verify(() => handler.next(response)).called(1);
  });

  test('onError forwards the error to the next handler', () {
    final err = DioException(
      requestOptions: RequestOptions(path: '/x'),
      message: 'boom',
    );
    final handler = _MockErrorHandler();

    interceptor.onError(err, handler);

    verify(() => handler.next(err)).called(1);
  });
}
