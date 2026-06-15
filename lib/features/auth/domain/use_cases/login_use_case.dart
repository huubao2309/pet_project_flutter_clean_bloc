import '../../../../core/use_case/use_case.dart';
import '../../data/models/request/login_request_dto.dart';
import '../../data/repositories/auth_repository.dart';
import '../entities/user_entity.dart';

class LoginParams {
  const LoginParams({required this.phone, required this.password});

  final String phone;
  final String password;
}

class LoginUseCase implements UseCase<UserEntity, LoginParams> {
  const LoginUseCase({required this.authRepository});

  final AuthRepository authRepository;

  @override
  Future<UserEntity> execute(LoginParams params) => authRepository.login(
        LoginRequestDto(phone: params.phone, password: params.password),
      );
}
