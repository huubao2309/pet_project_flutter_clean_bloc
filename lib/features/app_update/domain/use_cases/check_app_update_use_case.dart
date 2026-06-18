import '../../../../core/use_case/use_case.dart';
import '../../../../core/utils/version_comparator.dart';
import '../entities/app_update_info.dart';
import '../entities/app_update_status.dart';
import '../repositories/app_update_repository.dart';

/// Decides what update prompt (if any) to show, combining the backend policy
/// with the device's current version and the user's dismissal history.
class CheckAppUpdateUseCase implements UseCase<AppUpdateStatus, NoParams> {
  const CheckAppUpdateUseCase({required this.repository});

  final AppUpdateRepository repository;

  @override
  Future<AppUpdateStatus> execute(NoParams params) async {
    final config = await repository.fetchConfig();
    if (config == null) {
      return const AppUpToDate();
    }

    final current = await repository.currentVersion();
    // Already on the latest (or newer) build → nothing to prompt.
    if (!VersionComparator.isLower(current, config.latestVersion)) {
      return const AppUpToDate();
    }

    final info = AppUpdateInfo(
      latestVersion: config.latestVersion,
      storeUrl: config.storeUrl,
      message: config.message,
    );

    // Forced when the backend says so, or the build is below the minimum.
    final forced = config.forceUpdate ||
        VersionComparator.isLower(current, config.minRequiredVersion);
    if (forced) {
      return AppForcedUpdate(info);
    }

    // Optional: suppress if the user already dismissed this (or a newer)
    // version — re-prompt only when something newer ships.
    final dismissed = await repository.lastDismissedVersion();
    if (dismissed != null &&
        !VersionComparator.isLower(dismissed, config.latestVersion)) {
      return const AppUpToDate();
    }
    return AppOptionalUpdate(info);
  }
}
