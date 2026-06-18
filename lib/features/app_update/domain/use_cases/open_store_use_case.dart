import '../../../../core/use_case/use_case.dart';
import '../repositories/app_update_repository.dart';

/// Sends the user to the platform store (Play Store / App Store) to update.
class OpenStoreUseCase implements UseCase<void, String> {
  const OpenStoreUseCase({required this.repository});

  final AppUpdateRepository repository;

  @override
  Future<void> execute(String url) => repository.openStore(url);
}
