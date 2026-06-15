import '../../../../core/use_case/use_case.dart';
import '../entities/user_entity.dart';
import '../../data/repositories/auth_repository.dart';

/// Returns the currently authenticated user, or null if not logged in.
class GetCurrentUserUseCase implements UseCase<UserEntity?, NoParams> {
  const GetCurrentUserUseCase({required this.authRepository});

  final AuthRepository authRepository;

  @override
  Future<UserEntity?> execute(NoParams _) => authRepository.getCurrentUser();
}
