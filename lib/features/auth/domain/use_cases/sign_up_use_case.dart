import '../../../../core/use_case/use_case.dart';
import '../entities/sign_up_result.dart';
import '../repositories/auth_repository.dart';

class SignUpParams {
  const SignUpParams({
    required this.phone,
    this.receiveUpdates = false,
  });

  final String phone;
  final bool receiveUpdates;
}

class SignUpUseCase implements UseCase<SignUpResult, SignUpParams> {
  const SignUpUseCase({required this.authRepository});

  final AuthRepository authRepository;

  @override
  Future<SignUpResult> execute(SignUpParams params) => authRepository.signUp(
        phone: params.phone,
        receiveUpdates: params.receiveUpdates,
      );
}
