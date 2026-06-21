import '../../../../core/use_case/use_case.dart';
import '../repositories/auth_repository.dart';

/// Sets the password for an OTP-verified sign-up. The session token is resolved
/// by the data layer (PreAuthSession). On success the repository persists the
/// returned auth tokens, signing the user in.
class RegisterPasswordUseCase implements UseCase<void, String> {
  const RegisterPasswordUseCase({required this.authRepository});

  final AuthRepository authRepository;

  @override
  Future<void> execute(String password) =>
      authRepository.registerPassword(password: password);
}
