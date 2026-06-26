import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_project_flutter_clean_bloc/core/error/app_exception.dart';
import 'package:pet_project_flutter_clean_bloc/core/network/api_response.dart';
import 'package:pet_project_flutter_clean_bloc/core/network/http_client.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/data/datasources/auth_api_data_source.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/data/models/request/login_request_dto.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/data/models/request/sign_up_request_dto.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/data/models/response/login_data_dto.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/data/models/response/otp_challenge_dto.dart';

import '../../../../helpers/localization_test_harness.dart';

/// Mock of the [HttpClient] port — same mocktail style as the rest of the suite.
/// Because `AuthApiDataSource` depends on the abstraction (not the concrete
/// `DioClient`), no Dio / plugins are involved.
class MockHttpClient extends Mock implements HttpClient {}

void main() {
  // The data source resolves default error messages with `.tr()`. The harness
  // loads the REAL translations so assertions can compare against `'key'.tr()`
  // — which verifies the data source used the right key AND that it localizes,
  // without hard-coding the Vietnamese copy.
  setUpAll(LocalizationTestHarness.useRealTranslations);

  late MockHttpClient http;
  late AuthApiDataSource dataSource;

  setUp(() {
    http = MockHttpClient();
    dataSource = AuthApiDataSource(httpClient: http);
  });

  const loginRequest = LoginRequestDto(phone: '0900000000', password: 'pw');
  const signUpRequest = SignUpRequestDto(phone: '0900000000', language: 'en');

  /// Stub the next `post<T>` to return [response].
  void whenPost<T>(ApiResponse<T> response) {
    when(
      () => http.post<T>(
        any(),
        data: any(named: 'data'),
        fromJson: any(named: 'fromJson'),
      ),
    ).thenAnswer((_) async => response);
  }

  /// Stub the next `post<T>` to throw [error].
  void whenPostThrows<T>(Object error) {
    when(
      () => http.post<T>(
        any(),
        data: any(named: 'data'),
        fromJson: any(named: 'fromJson'),
      ),
    ).thenThrow(error);
  }

  group('login', () {
    test('returns the data and posts to /auth/login with the request body',
        () async {
      const expected = LoginDataDto(challengeType: 'none', accessToken: 'a');
      whenPost(const ApiResponse<LoginDataDto>(success: true, data: expected));

      final result = await dataSource.login(loginRequest);

      expect(result, same(expected));
      final captured = verify(
        () => http.post<LoginDataDto>(
          captureAny(),
          data: captureAny(named: 'data'),
          fromJson: any(named: 'fromJson'),
        ),
      ).captured;
      expect(captured[0], '/auth/login');
      expect(captured[1], {'phone': '0900000000', 'password': 'pw'});
    });

    test('throws ServerException with the server message on failure', () async {
      whenPost(const ApiResponse<LoginDataDto>(success: false, message: 'bad creds'));

      await expectLater(
        () => dataSource.login(loginRequest),
        throwsA(
          isA<ServerException>().having((e) => e.message, 'message', 'bad creds'),
        ),
      );
    });

    test('falls back to the localized default message when message is null',
        () async {
      whenPost(const ApiResponse<LoginDataDto>(success: true));

      await expectLater(
        () => dataSource.login(loginRequest),
        throwsA(
          isA<ServerException>()
              .having((e) => e.message, 'message', 'errors.login_failed'.tr()),
        ),
      );
    });

    test('maps an otp_limit_exceeded envelope to AccountBlockedException',
        () async {
      whenPostThrows<LoginDataDto>(
        ServerException.withCode(403, 'blocked', {
          'verdict': 'otp_limit_exceeded',
          'data': {'user_message': 'Too many attempts'},
        }),
      );

      await expectLater(
        () => dataSource.login(loginRequest),
        throwsA(
          isA<AccountBlockedException>()
              .having((e) => e.reason, 'reason', BlockReason.otpLimitExceeded)
              .having((e) => e.message, 'message', 'Too many attempts'),
        ),
      );
    });

    test('rethrows a ServerException that is not an account block', () async {
      whenPostThrows<LoginDataDto>(
        ServerException.withCode(500, 'boom', {'verdict': 'nope'}),
      );

      await expectLater(
        () => dataSource.login(loginRequest),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('signUp', () {
    test('maps a phone_is_blocked envelope to PhoneBlockedException', () async {
      whenPostThrows<OtpChallengeDto>(
        ServerException.withCode(403, 'blocked', {
          'verdict': 'phone_is_blocked',
          'data': {'user_message': 'Phone blocked'},
        }),
      );

      await expectLater(
        () => dataSource.signUp(signUpRequest),
        throwsA(
          isA<PhoneBlockedException>()
              .having((e) => e.message, 'message', 'Phone blocked'),
        ),
      );
    });

    test('returns an empty OtpChallengeDto when data is absent', () async {
      whenPost(const ApiResponse<OtpChallengeDto>(success: true));

      final result = await dataSource.signUp(signUpRequest);

      expect(result.sessionToken, isNull);
    });
  });

  group('logout', () {
    test('completes and posts to /auth/logout on success', () async {
      whenPost(const ApiResponse<void>(success: true));

      await expectLater(dataSource.logout(), completes);
      verify(() => http.post<void>(any(), data: any(named: 'data'), fromJson: any(named: 'fromJson'))).called(1);
    });

    test('throws ServerException on failure', () async {
      whenPost(const ApiResponse<void>(success: false, message: 'nope'));

      await expectLater(dataSource.logout(), throwsA(isA<ServerException>()));
    });
  });
}
