import '../../../../core/use_case/use_case.dart';
import '../repositories/auth_repository.dart';

class ResetPasswordParams {
  const ResetPasswordParams({required this.newPassword, required this.token});

  final String newPassword;
  final String token;
}

class ResetPasswordUseCase implements UseCase<void, ResetPasswordParams> {
  const ResetPasswordUseCase({required this.authRepository});

  final AuthRepository authRepository;

  @override
  Future<void> execute(ResetPasswordParams params) =>
      authRepository.resetPassword(
        newPassword: params.newPassword,
        token: params.token,
      );
}
