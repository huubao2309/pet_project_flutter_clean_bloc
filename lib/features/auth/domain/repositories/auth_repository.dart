import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login({
    required String phone,
    required String password,
  });

  Future<void> logout();

  Future<bool> isLoggedIn();

  Future<UserEntity?> getCurrentUser();
}
