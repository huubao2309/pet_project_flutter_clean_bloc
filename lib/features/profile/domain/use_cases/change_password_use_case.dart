import '../../../../core/use_case/use_case.dart';
import '../repositories/profile_repository.dart';

class ChangePasswordParams {
  const ChangePasswordParams({
    required this.currentPassword,
    required this.newPassword,
  });

  final String currentPassword;
  final String newPassword;
}

class ChangePasswordUseCase implements UseCase<void, ChangePasswordParams> {
  const ChangePasswordUseCase({required this.profileRepository});

  final ProfileRepository profileRepository;

  @override
  Future<void> execute(ChangePasswordParams params) =>
      profileRepository.changePassword(
        currentPassword: params.currentPassword,
        newPassword: params.newPassword,
      );
}
