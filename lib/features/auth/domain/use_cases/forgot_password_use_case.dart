import '../../../../core/use_case/use_case.dart';
import '../repositories/auth_repository.dart';

class ForgotPasswordUseCase implements UseCase<void, String> {
  const ForgotPasswordUseCase({required this.authRepository});

  final AuthRepository authRepository;

  /// [params] is the phone number to send the reset code to.
  @override
  Future<void> execute(String params) =>
      authRepository.forgotPassword(phone: params);
}
