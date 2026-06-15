import '../../../../core/use_case/use_case.dart';
import '../repositories/auth_repository.dart';

class ForgotPasswordUseCase implements UseCase<void, String> {
  const ForgotPasswordUseCase({required this.authRepository});

  final AuthRepository authRepository;

  /// [params] is the email address to send the reset link to.
  @override
  Future<void> execute(String params) =>
      authRepository.forgotPassword(email: params);
}
