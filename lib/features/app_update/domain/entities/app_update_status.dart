import 'app_update_info.dart';

/// Outcome of an update check — `sealed` so the View handles every case.
sealed class AppUpdateStatus {
  const AppUpdateStatus();
}

/// The app is current (or newer); show nothing.
final class AppUpToDate extends AppUpdateStatus {
  const AppUpToDate();
}

/// A newer version exists; prompt but let the user dismiss it (once).
final class AppOptionalUpdate extends AppUpdateStatus {
  const AppOptionalUpdate(this.info);
  final AppUpdateInfo info;
}

/// A newer version is required; prompt with no way to dismiss.
final class AppForcedUpdate extends AppUpdateStatus {
  const AppForcedUpdate(this.info);
  final AppUpdateInfo info;
}
