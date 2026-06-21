import '../../../../core/use_case/use_case.dart';
import '../repositories/auth_repository.dart';

class ChangePasswordParams {
  const ChangePasswordParams({
    required this.currentPassword,
    required this.newPassword,
  });

  final String currentPassword;
  final String newPassword;
}

class ChangePasswordUseCase implements UseCase<void, ChangePasswordParams> {
  const ChangePasswordUseCase({required this.authRepository});

  final AuthRepository authRepository;

  @override
  Future<void> execute(ChangePasswordParams params) =>
      authRepository.changePassword(
        currentPassword: params.currentPassword,
        newPassword: params.newPassword,
      );
}
