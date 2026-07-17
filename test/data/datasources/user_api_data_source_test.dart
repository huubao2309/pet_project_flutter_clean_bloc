import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_project_flutter_clean_bloc/core/error/app_error_code.dart';
import 'package:pet_project_flutter_clean_bloc/core/error/app_exception.dart';
import 'package:pet_project_flutter_clean_bloc/core/network/api_response.dart';
import 'package:pet_project_flutter_clean_bloc/core/network/http_client.dart';
import 'package:pet_project_flutter_clean_bloc/data/datasources/user_api_data_source.dart';
import 'package:pet_project_flutter_clean_bloc/data/models/profile/request/change_password_request_dto.dart';
import 'package:pet_project_flutter_clean_bloc/data/models/profile/user_profile_dto.dart';

class MockHttpClient extends Mock implements HttpClient {}

void main() {
  late MockHttpClient http;
  late UserApiDataSource dataSource;

  setUp(() {
    http = MockHttpClient();
    dataSource = UserApiDataSource(httpClient: http);
  });

  void whenGet<T>(ApiResponse<T> response) {
    when(() => http.get<T>(any(), fromJson: any(named: 'fromJson')))
        .thenAnswer((_) async => response);
  }

  void whenPost<T>(ApiResponse<T> response) {
    when(
      () => http.post<T>(
        any(),
        data: any(named: 'data'),
        fromJson: any(named: 'fromJson'),
      ),
    ).thenAnswer((_) async => response);
  }

  group('getProfile', () {
    const dto = UserProfileDto(id: '1', fullName: 'Bảo', phone: '0900000000');

    test('returns the profile and GETs /user/me', () async {
      whenGet(const ApiResponse<UserProfileDto>(success: true, data: dto));

      final result = await dataSource.getProfile();

      expect(result, same(dto));
      final path = verify(
        () => http.get<UserProfileDto>(
          captureAny(),
          fromJson: any(named: 'fromJson'),
        ),
      ).captured.single;
      expect(path, '/user/me');
    });

    test('throws ServerException(unknown) on failure', () async {
      whenGet(
        const ApiResponse<UserProfileDto>(success: false, message: 'nope'),
      );

      await expectLater(
        dataSource.getProfile(),
        throwsA(
          isA<ServerException>()
              .having((e) => e.code, 'code', AppErrorCode.unknown)
              .having((e) => e.serverMessage, 'serverMessage', 'nope'),
        ),
      );
    });

    test('throws when success is true but data is null', () async {
      whenGet(const ApiResponse<UserProfileDto>(success: true));

      await expectLater(
        dataSource.getProfile(),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('changePassword', () {
    const request = ChangePasswordRequestDto(
      currentPassword: 'old',
      newPassword: 'new',
    );

    test('completes and POSTs to /user/change-password with the body',
        () async {
      whenPost(const ApiResponse<void>(success: true));

      await expectLater(dataSource.changePassword(request), completes);

      final captured = verify(
        () => http.post<void>(captureAny(), data: captureAny(named: 'data')),
      ).captured;
      expect(captured[0], '/user/change-password');
      expect(captured[1], request.toJson());
    });

    test('throws ServerException(changePasswordFailed) on failure', () async {
      whenPost(const ApiResponse<void>(success: false, message: 'wrong pw'));

      await expectLater(
        dataSource.changePassword(request),
        throwsA(
          isA<ServerException>()
              .having((e) => e.code, 'code', AppErrorCode.changePasswordFailed)
              .having((e) => e.serverMessage, 'serverMessage', 'wrong pw'),
        ),
      );
    });
  });
}
