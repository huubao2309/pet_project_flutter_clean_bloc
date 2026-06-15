import '../../domain/entities/user_entity.dart';
import '../models/request/login_request_dto.dart';

abstract class AuthRepository {
  Future<UserEntity> login(LoginRequestDto request);

  Future<void> logout();

  Future<bool> isLoggedIn();

  Future<UserEntity?> getCurrentUser();
}
