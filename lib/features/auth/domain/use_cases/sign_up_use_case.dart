import '../../../../core/use_case/use_case.dart';
import '../repositories/auth_repository.dart';

class SignUpParams {
  const SignUpParams({
    required this.email,
    required this.password,
    this.receiveUpdates = false,
  });

  final String email;
  final String password;
  final bool receiveUpdates;
}

class SignUpUseCase implements UseCase<bool, SignUpParams> {
  const SignUpUseCase({required this.authRepository});

  final AuthRepository authRepository;

  @override
  Future<bool> execute(SignUpParams params) => authRepository.signUp(
        email: params.email,
        password: params.password,
        receiveUpdates: params.receiveUpdates,
      );
}
