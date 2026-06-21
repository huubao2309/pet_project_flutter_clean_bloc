import '../../../../core/use_case/use_case.dart';
import '../repositories/auth_repository.dart';

/// Sets a new password for an OTP-verified forgot-password flow. The session
/// token is resolved by the data layer (PreAuthSession).
class ResetPasswordUseCase implements UseCase<void, String> {
  const ResetPasswordUseCase({required this.authRepository});

  final AuthRepository authRepository;

  @override
  Future<void> execute(String newPassword) =>
      authRepository.resetPassword(newPassword: newPassword);
}
