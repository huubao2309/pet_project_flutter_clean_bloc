import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/error/app_error_code.dart';
import 'package:pet_project_flutter_clean_bloc/core/error/app_exception.dart';

/// The error layer is now framework-free — exceptions carry a typed [AppErrorCode]
/// and an optional raw [AppException.serverMessage], and never call `.tr()`. So
/// this test needs no EasyLocalization bootstrap at all.
void main() {
  group('Subtype relationships', () {
    test('every concrete exception is an AppException and an Exception', () {
      final exceptions = <AppException>[
        AuthException('a'),
        CacheException('a'),
        NetworkException(message: 'a'),
        ValidationException('a'),
        ServerException(message: 'a'),
        PhoneBlockedException('a'),
        AccountBlockedException(BlockReason.accountDeleted, 'a'),
      ];
      for (final e in exceptions) {
        expect(e, isA<AppException>());
        expect(e, isA<Exception>());
      }
    });
  });

  group('serverMessage', () {
    test('carries the explicit backend message verbatim', () {
      expect(AuthException('boom').serverMessage, 'boom');
      expect(CacheException('boom').serverMessage, 'boom');
      expect(NetworkException(message: 'boom').serverMessage, 'boom');
      expect(ValidationException('boom').serverMessage, 'boom');
      expect(ServerException(message: 'boom').serverMessage, 'boom');
      expect(PhoneBlockedException('boom').serverMessage, 'boom');
      expect(
        AccountBlockedException(BlockReason.otpLimitExceeded, 'boom').serverMessage,
        'boom',
      );
    });

    test('is null when omitted (presentation falls back to the code)', () {
      expect(AuthException().serverMessage, isNull);
      expect(ServerException().serverMessage, isNull);
      expect(
        AccountBlockedException(BlockReason.accountDeleted).serverMessage,
        isNull,
      );
    });
  });

  group('code', () {
    test('each exception type carries its default error code', () {
      expect(AuthException().code, AppErrorCode.auth);
      expect(CacheException().code, AppErrorCode.cache);
      expect(NetworkException().code, AppErrorCode.network);
      expect(ValidationException().code, AppErrorCode.validation);
      expect(ServerException().code, AppErrorCode.server);
      expect(PhoneBlockedException().code, AppErrorCode.phoneBlocked);
      expect(
        AccountBlockedException(BlockReason.accountDeleted).code,
        AppErrorCode.accountBlocked,
      );
    });

    test('NetworkException can carry the timeout code', () {
      expect(
        NetworkException(code: AppErrorCode.networkTimeout).code,
        AppErrorCode.networkTimeout,
      );
    });
  });

  group('toString', () {
    test('renders runtimeType with code and serverMessage', () {
      expect(
        AuthException('x').toString(),
        'AuthException(code: AppErrorCode.auth, serverMessage: x)',
      );
      expect(
        ServerException().toString(),
        'ServerException(code: AppErrorCode.server, serverMessage: null)',
      );
    });
  });

  group('BlockReason enum', () {
    test('exposes exactly the known blocking causes', () {
      expect(
        BlockReason.values,
        [BlockReason.otpLimitExceeded, BlockReason.accountDeleted],
      );
    });
  });

  group('AccountBlockedException', () {
    test('retains its block reason', () {
      expect(
        AccountBlockedException(BlockReason.otpLimitExceeded).reason,
        BlockReason.otpLimitExceeded,
      );
      expect(
        AccountBlockedException(BlockReason.accountDeleted).reason,
        BlockReason.accountDeleted,
      );
    });
  });

  group('ServerException', () {
    test('stores statusCode, responseData and serverMessage', () {
      final e = ServerException(
        statusCode: 503,
        responseData: {'error': 'down'},
        message: 'unavailable',
      );
      expect(e.statusCode, 503);
      expect(e.responseData, {'error': 'down'});
      expect(e.serverMessage, 'unavailable');
      expect(e.code, AppErrorCode.server);
    });

    test('withStatus builds a transport failure with code + status', () {
      final e = ServerException.withStatus(
        500,
        message: 'oops',
        responseData: {'k': 'v'},
      );
      expect(e.statusCode, 500);
      expect(e.code, AppErrorCode.unknown);
      expect(e.serverMessage, 'oops');
      expect(e.responseData, {'k': 'v'});
    });

    test('withStatus defaults code to unknown and message to null', () {
      final e = ServerException.withStatus(500);
      expect(e.statusCode, 500);
      expect(e.code, AppErrorCode.unknown);
      expect(e.serverMessage, isNull);
    });
  });
}
