import '../../domain/entities/user_entity.dart';
import '../models/request/login_request_dto.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl();

  @override
  Future<UserEntity> login(LoginRequestDto request) async {
    // TODO: implement with AuthService
    throw UnimplementedError();
  }

  @override
  Future<void> logout() async {}

  @override
  Future<bool> isLoggedIn() async => true;

  @override
  Future<UserEntity?> getCurrentUser() async => null;
}
