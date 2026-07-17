import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/constants/mock_assets.dart';
import 'package:pet_project_flutter_clean_bloc/core/error/app_error_code.dart';
import 'package:pet_project_flutter_clean_bloc/core/error/app_exception.dart';
import 'package:pet_project_flutter_clean_bloc/data/datasources/user_mock_data_source.dart';
import 'package:pet_project_flutter_clean_bloc/data/models/profile/request/change_password_request_dto.dart';

void main() {
  setUpAll(TestWidgetsFlutterBinding.ensureInitialized);

  const request = ChangePasswordRequestDto(
    currentPassword: 'old',
    newPassword: 'new',
  );

  group('getProfile', () {
    test('parses the success fixture into a UserProfileDto', () async {
      const source = UserMockDataSource(latency: Duration.zero);

      final profile = await source.getProfile();

      expect(profile.id, '1');
      expect(profile.fullName, 'Harry');
      expect(profile.phone, '0911223344');
      expect(profile.email, 'abc@gmail.com');
    });
  });

  group('changePassword', () {
    test('completes on the success fixture', () async {
      const source = UserMockDataSource(latency: Duration.zero);

      await expectLater(source.changePassword(request), completes);
    });

    test('throws ServerException on the failure fixture', () async {
      const source = UserMockDataSource(
        changePasswordScenario: MockAssets.changePasswordFailed,
        latency: Duration.zero,
      );

      await expectLater(
        source.changePassword(request),
        throwsA(
          isA<ServerException>()
              .having((e) => e.code, 'code', AppErrorCode.unknown),
        ),
      );
    });
  });
}
