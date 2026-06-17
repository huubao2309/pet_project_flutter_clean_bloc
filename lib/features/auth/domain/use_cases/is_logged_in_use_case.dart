import '../../../../core/use_case/use_case.dart';
import '../repositories/auth_repository.dart';

/// Whether there is an active session (a stored access token).
class IsLoggedInUseCase implements UseCase<bool, NoParams> {
  const IsLoggedInUseCase({required this.authRepository});

  final AuthRepository authRepository;

  @override
  Future<bool> execute(NoParams _) => authRepository.isLoggedIn();
}
