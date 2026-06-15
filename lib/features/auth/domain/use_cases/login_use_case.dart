import '../../../../core/use_case/use_case.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginParams {
  const LoginParams({required this.phone, required this.password});

  final String phone;
  final String password;
}

class LoginUseCase implements UseCase<UserEntity, LoginParams> {
  const LoginUseCase({required this.authRepository});

  final AuthRepository authRepository;

  @override
  Future<UserEntity> execute(LoginParams params) =>
      authRepository.login(phone: params.phone, password: params.password);
}
