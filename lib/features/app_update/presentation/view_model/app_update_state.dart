import '../../domain/entities/app_update_info.dart';

/// Immutable UI state for the app-update check. Library-agnostic.
sealed class AppUpdateState {
  const AppUpdateState();
}

final class AppUpdateInitial extends AppUpdateState {
  const AppUpdateInitial();
}

/// No update to prompt (current, dismissed, or the check failed silently).
final class AppUpdateNotRequired extends AppUpdateState {
  const AppUpdateNotRequired();
}

/// A newer version exists; show a dismissible prompt (once per version).
final class AppUpdateOptional extends AppUpdateState {
  const AppUpdateOptional(this.info);
  final AppUpdateInfo info;
}

/// A newer version is required; show a non-dismissible prompt.
final class AppUpdateForced extends AppUpdateState {
  const AppUpdateForced(this.info);
  final AppUpdateInfo info;
}
