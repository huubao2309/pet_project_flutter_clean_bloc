/// The backend's update policy, before applying the device's current version
/// or the user's dismissal history (that decision lives in
/// `CheckAppUpdateUseCase`).
class AppUpdateConfig {
  const AppUpdateConfig({
    required this.latestVersion,
    required this.minRequiredVersion,
    required this.forceUpdate,
    required this.storeUrl,
    this.message,
  });

  /// The newest version available on the store.
  final String latestVersion;

  /// Versions below this are no longer supported (a forced update).
  final String minRequiredVersion;

  /// Explicit backend flag forcing the update regardless of version math.
  final bool forceUpdate;

  /// Platform-resolved store URL (Play Store / App Store).
  final String storeUrl;

  /// Optional server-provided release notes.
  final String? message;
}
