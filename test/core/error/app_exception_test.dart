import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/error/app_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    // EasyLocalization persists the locale via shared_preferences; provide an
    // in-memory backing store so ensureInitialized() succeeds under test.
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await EasyLocalization.ensureInitialized();
  });

  group('Subtype relationships', () {
    test('every concrete exception is an AppException and an Exception', () {
      final exceptions = <AppException>[
        AuthException('a'),
        CacheException('a'),
        NetworkException('a'),
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

  group('Explicit messages', () {
    test('are carried verbatim by each exception', () {
      expect(AuthException('boom').message, 'boom');
      expect(CacheException('boom').message, 'boom');
      expect(NetworkException('boom').message, 'boom');
      expect(ValidationException('boom').message, 'boom');
      expect(ServerException(message: 'boom').message, 'boom');
      expect(PhoneBlockedException('boom').message, 'boom');
      expect(
          AccountBlockedException(BlockReason.otpLimitExceeded, 'boom').message,
          'boom',);
    });
  });

  group('Default localized messages', () {
    test('fall back to a non-empty translation key when omitted', () {
      // Without loaded translations, .tr() returns the key itself.
      expect(AuthException().message, isNotEmpty);
      expect(AuthException().message, 'errors.auth');
      expect(CacheException().message, 'errors.cache');
      expect(NetworkException().message, 'errors.network');
      expect(ValidationException().message, 'errors.validation');
      expect(ServerException().message, 'errors.server');
      expect(PhoneBlockedException().message, 'errors.unknown');
      expect(AccountBlockedException(BlockReason.accountDeleted).message,
          'errors.unknown',);
    });
  });

  group('toString', () {
    test('renders "<runtimeType>: <message>"', () {
      expect(AuthException('x').toString(), 'AuthException: x');
      expect(NetworkException('y').toString(), 'NetworkException: y');
      expect(
        AccountBlockedException(BlockReason.accountDeleted, 'z').toString(),
        'AccountBlockedException: z',
      );
    });
  });

  group('BlockReason enum', () {
    test('exposes exactly the known blocking causes', () {
      expect(BlockReason.values,
          [BlockReason.otpLimitExceeded, BlockReason.accountDeleted],);
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
    test('stores statusCode and responseData', () {
      final e = ServerException(
        statusCode: 503,
        responseData: {'error': 'down'},
        message: 'unavailable',
      );
      expect(e.statusCode, 503);
      expect(e.responseData, {'error': 'down'});
      expect(e.message, 'unavailable');
    });

    test('withCode builds an exception carrying the code', () {
      final e = ServerException.withCode(500, 'oops', {'k': 'v'});
      expect(e.statusCode, 500);
      expect(e.message, 'oops');
      expect(e.responseData, {'k': 'v'});
    });

    test('withCode falls back to a default message', () {
      final e = ServerException.withCode(500);
      expect(e.statusCode, 500);
      expect(e.message, 'errors.server');
    });
  });
}
