import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_project_flutter_clean_bloc/core/error/app_error_code.dart';
import 'package:pet_project_flutter_clean_bloc/core/error/app_exception.dart';
import 'package:pet_project_flutter_clean_bloc/core/network/dio_client.dart';
import 'package:pet_project_flutter_clean_bloc/environments/env_type.dart';
import 'package:pet_project_flutter_clean_bloc/core/storage/secure_storage/secure_storage.dart';

class _MockDio extends Mock implements Dio {}

class _MockSecureStorage extends Mock implements SecureStorage {}

void main() {
  late _MockDio dio;
  late DioClient client;

  setUp(() {
    dio = _MockDio();
    // SecureStorage is unused when a Dio is injected (the interceptor chain in
    // _build is skipped), but the constructor still requires one.
    client = DioClient(
      baseUrl: 'https://api',
      secureStorage: _MockSecureStorage(),
      envType: EnvType.staging,
      dio: dio,
    );
  });

  Response<Map<String, dynamic>> response({
    int? statusCode,
    Map<String, dynamic>? data,
  }) =>
      Response<Map<String, dynamic>>(
        requestOptions: RequestOptions(path: '/x'),
        statusCode: statusCode,
        data: data,
      );

  DioException dioError({int? statusCode, DioExceptionType? type, String? message}) =>
      DioException(
        requestOptions: RequestOptions(path: '/x'),
        type: type ?? DioExceptionType.unknown,
        message: message,
        response: statusCode == null
            ? null
            : Response(
                requestOptions: RequestOptions(path: '/x'),
                statusCode: statusCode,
              ),
      );

  group('_parse (via post)', () {
    test('success: status < 400, maps data via fromJson and the envelope fields',
        () async {
      when(() => dio.post<Map<String, dynamic>>(any(), data: any(named: 'data')))
          .thenAnswer(
        (_) async => response(
          statusCode: 200,
          data: {
            'data': {'name': 'Bao'},
            'message': 'ok',
            'verdict': 'success',
            'meta': {'page': 1},
          },
        ),
      );

      final res = await client.post<String>(
        '/x',
        data: {'a': 1},
        fromJson: (json) => (json! as Map)['name'] as String,
      );

      expect(res.success, isTrue);
      expect(res.data, 'Bao');
      expect(res.message, 'ok');
      expect(res.verdict, 'success');
      expect(res.statusCode, 200);
      expect(res.meta, {'page': 1});
    });

    test('failure status (>=400) yields success=false', () async {
      when(() => dio.post<Map<String, dynamic>>(any(), data: any(named: 'data')))
          .thenAnswer((_) async => response(statusCode: 422, data: {}));

      final res = await client.post<String>('/x');

      expect(res.success, isFalse);
      expect(res.data, isNull);
    });
  });

  group('_mapDioError (via get)', () {
    void stubGetThrows(DioException err) {
      when(() => dio.get<Map<String, dynamic>>(any(),
          queryParameters: any(named: 'queryParameters'),),).thenThrow(err);
    }

    test('401 → AuthException', () async {
      stubGetThrows(dioError(statusCode: 401));
      await expectLater(
        client.get<void>('/x'),
        throwsA(
          isA<AuthException>().having((e) => e.code, 'code', AppErrorCode.auth),
        ),
      );
    });

    test('connection/receive timeout → NetworkException(networkTimeout)',
        () async {
      stubGetThrows(dioError(type: DioExceptionType.connectionTimeout));
      await expectLater(
        client.get<void>('/x'),
        throwsA(
          isA<NetworkException>()
              .having((e) => e.code, 'code', AppErrorCode.networkTimeout),
        ),
      );
    });

    test('connectionError → NetworkException(network)', () async {
      stubGetThrows(dioError(type: DioExceptionType.connectionError));
      await expectLater(
        client.get<void>('/x'),
        throwsA(
          isA<NetworkException>()
              .having((e) => e.code, 'code', AppErrorCode.network),
        ),
      );
    });

    test('other errors → ServerException carrying status + dio message', () async {
      stubGetThrows(dioError(statusCode: 503, message: 'down'));
      await expectLater(
        client.get<void>('/x'),
        throwsA(
          isA<ServerException>()
              .having((e) => e.statusCode, 'statusCode', 503)
              .having((e) => e.serverMessage, 'serverMessage', 'down'),
        ),
      );
    });
  });
}
