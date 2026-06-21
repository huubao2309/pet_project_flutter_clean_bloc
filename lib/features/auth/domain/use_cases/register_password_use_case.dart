import '../../../../core/use_case/use_case.dart';
import '../repositories/auth_repository.dart';

class RegisterPasswordParams {
  const RegisterPasswordParams({
    required this.password,
    required this.sessionToken,
  });

  final String password;

  /// Session token from the verify-otp response of the sign-up flow.
  final String sessionToken;
}

/// Sets the password for an OTP-verified sign-up. On success the repository
/// persists the returned auth tokens, signing the user in.
class RegisterPasswordUseCase implements UseCase<void, RegisterPasswordParams> {
  const RegisterPasswordUseCase({required this.authRepository});

  final AuthRepository authRepository;

  @override
  Future<void> execute(RegisterPasswordParams params) =>
      authRepository.registerPassword(
        password: params.password,
        sessionToken: params.sessionToken,
      );
}
