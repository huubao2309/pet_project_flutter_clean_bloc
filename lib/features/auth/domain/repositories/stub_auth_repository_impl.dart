import '../entities/user_entity.dart';
import 'auth_repository.dart';

/// Hardcoded implementation of [AuthRepository] for UI development.
///
/// Use this while the real data layer is not yet implemented.
/// Replace with the GetIt-registered [AuthRepositoryImpl] when ready.
///
/// ── Stub vs Mock ──────────────────────────────────────────────────────────
/// This is a *stub* (fixed return values, no interaction verification).
/// A *mock* (e.g. from mockito/mocktail) belongs only in test files.
class StubAuthRepositoryImpl implements AuthRepository {
  const StubAuthRepositoryImpl();

  @override
  Future<UserEntity> login({
    required String phone,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    return UserEntity(id: '1', fullName: 'Nguyen Van A', phone: phone);
  }

  @override
  Future<void> logout() async {}

  @override
  Future<bool> isLoggedIn() async => true;

  @override
  Future<UserEntity?> getCurrentUser() async => null;
}
