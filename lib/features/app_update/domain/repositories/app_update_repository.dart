import '../entities/app_update_config.dart';

abstract class AppUpdateRepository {
  /// The update policy from the backend, or null when none is available
  /// (or the check failed — an update check must never block the app).
  Future<AppUpdateConfig?> fetchConfig();

  /// The running app's version, e.g. `"1.0.0"`.
  Future<String> currentVersion();

  /// The latest version the user dismissed an optional prompt for, or null.
  Future<String?> lastDismissedVersion();

  /// Remembers that the user dismissed the optional prompt for [version].
  Future<void> saveDismissedVersion(String version);

  /// Opens the platform store at [url].
  Future<void> openStore(String url);
}
