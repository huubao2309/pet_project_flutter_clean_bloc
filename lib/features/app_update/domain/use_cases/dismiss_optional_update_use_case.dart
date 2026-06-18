import '../../../../core/use_case/use_case.dart';
import '../repositories/app_update_repository.dart';

/// Records that the user dismissed the optional-update prompt for a version, so
/// it is not shown again until a newer version ships.
class DismissOptionalUpdateUseCase implements UseCase<void, String> {
  const DismissOptionalUpdateUseCase({required this.repository});

  final AppUpdateRepository repository;

  @override
  Future<void> execute(String version) =>
      repository.saveDismissedVersion(version);
}
