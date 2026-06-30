import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_project_flutter_clean_bloc/core/use_case/use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/profile/domain/entities/user_profile.dart';
import 'package:pet_project_flutter_clean_bloc/features/profile/domain/repositories/profile_repository.dart';
import 'package:pet_project_flutter_clean_bloc/features/profile/domain/use_cases/change_password_use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/profile/domain/use_cases/get_profile_use_case.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late MockProfileRepository repo;

  setUp(() {
    repo = MockProfileRepository();
  });

  group('GetProfileUseCase', () {
    test('returns repository.getProfile result', () async {
      const expected = UserProfile(id: 'p1', fullName: 'A', phone: '0900');
      when(() => repo.getProfile()).thenAnswer((_) async => expected);

      final result = await GetProfileUseCase(profileRepository: repo)
          .execute(const NoParams());

      expect(result, same(expected));
      verify(() => repo.getProfile()).called(1);
    });
  });

  group('ChangePasswordUseCase', () {
    test('delegates current and new password', () async {
      when(
        () => repo.changePassword(
          currentPassword: any(named: 'currentPassword'),
          newPassword: any(named: 'newPassword'),
        ),
      ).thenAnswer((_) async {});

      await ChangePasswordUseCase(profileRepository: repo).execute(
        const ChangePasswordParams(
          currentPassword: 'old',
          newPassword: 'new',
        ),
      );

      verify(
        () => repo.changePassword(currentPassword: 'old', newPassword: 'new'),
      ).called(1);
    });
  });
}
