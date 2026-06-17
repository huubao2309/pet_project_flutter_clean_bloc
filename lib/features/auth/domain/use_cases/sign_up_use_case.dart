import '../../../../core/use_case/use_case.dart';
import '../repositories/auth_repository.dart';

class SignUpParams {
  const SignUpParams({
    required this.phone,
    required this.password,
    this.receiveUpdates = false,
  });

  final String phone;
  final String password;
  final bool receiveUpdates;
}

class SignUpUseCase implements UseCase<bool, SignUpParams> {
  const SignUpUseCase({required this.authRepository});

  final AuthRepository authRepository;

  @override
  Future<bool> execute(SignUpParams params) => authRepository.signUp(
        phone: params.phone,
        password: params.password,
        receiveUpdates: params.receiveUpdates,
      );
}
