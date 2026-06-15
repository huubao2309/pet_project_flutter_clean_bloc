import '../../../../core/use_case/use_case.dart';
import '../repositories/auth_repository.dart';

/// Clears the current session.
///
/// The repository implementation handles token deletion from secure storage.
class LogoutUseCase implements UseCase<void, NoParams> {
  const LogoutUseCase({required this.authRepository});

  final AuthRepository authRepository;

  @override
  Future<void> execute(NoParams _) => authRepository.logout();
}
