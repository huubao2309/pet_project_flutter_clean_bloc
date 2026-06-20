import '../../../../core/use_case/use_case.dart';
import '../entities/login_result.dart';
import '../repositories/auth_repository.dart';

class LoginParams {
  const LoginParams({required this.phone, required this.password});

  final String phone;
  final String password;
}

class LoginUseCase implements UseCase<LoginResult, LoginParams> {
  const LoginUseCase({required this.authRepository});

  final AuthRepository authRepository;

  @override
  Future<LoginResult> execute(LoginParams params) =>
      authRepository.login(phone: params.phone, password: params.password);
}
