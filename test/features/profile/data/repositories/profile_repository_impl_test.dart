import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_project_flutter_clean_bloc/features/profile/data/datasources/user_remote_data_source.dart';
import 'package:pet_project_flutter_clean_bloc/features/profile/data/models/request/change_password_request_dto.dart';
import 'package:pet_project_flutter_clean_bloc/features/profile/data/models/user_profile_dto.dart';
import 'package:pet_project_flutter_clean_bloc/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:pet_project_flutter_clean_bloc/features/profile/domain/entities/user_profile.dart';

class MockUserRemoteDataSource extends Mock implements UserRemoteDataSource {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const ChangePasswordRequestDto(currentPassword: '', newPassword: ''),
    );
  });

  late MockUserRemoteDataSource remote;
  late ProfileRepositoryImpl repository;

  setUp(() {
    remote = MockUserRemoteDataSource();
    repository = ProfileRepositoryImpl(remoteDataSource: remote);
  });

  group('getProfile', () {
    test('maps the DTO to a UserProfile entity', () async {
      when(() => remote.getProfile()).thenAnswer(
        (_) async => const UserProfileDto(
          id: 'u1',
          fullName: 'Jane Doe',
          phone: '0900',
          email: 'jane@example.com',
        ),
      );

      final profile = await repository.getProfile();

      expect(profile, isA<UserProfile>());
      expect(profile.id, 'u1');
      expect(profile.fullName, 'Jane Doe');
      expect(profile.phone, '0900');
      expect(profile.email, 'jane@example.com');
    });

    test('preserves a null email', () async {
      when(() => remote.getProfile()).thenAnswer(
        (_) async => const UserProfileDto(
          id: 'u2',
          fullName: 'No Email',
          phone: '0911',
        ),
      );

      final profile = await repository.getProfile();
      expect(profile.email, isNull);
    });

    test('propagates errors from the data source', () async {
      when(() => remote.getProfile()).thenThrow(Exception('network'));
      await expectLater(repository.getProfile(), throwsException);
    });
  });

  group('changePassword', () {
    test('builds the request DTO from the plain values', () async {
      when(() => remote.changePassword(any())).thenAnswer((_) async {});

      await repository.changePassword(
        currentPassword: 'old',
        newPassword: 'new',
      );

      final dto = verify(() => remote.changePassword(captureAny()))
          .captured
          .single as ChangePasswordRequestDto;
      expect(dto.currentPassword, 'old');
      expect(dto.newPassword, 'new');
    });

    test('propagates errors from the data source', () async {
      // changePassword forwards the future directly (no await), so a rejected
      // future from the data source surfaces unchanged to the caller.
      when(() => remote.changePassword(any()))
          .thenAnswer((_) async => throw Exception('bad'));
      await expectLater(
        repository.changePassword(currentPassword: 'a', newPassword: 'b'),
        throwsException,
      );
    });
  });
}
