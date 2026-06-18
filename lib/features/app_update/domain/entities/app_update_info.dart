/// What the View needs to render an update prompt and route to the store.
class AppUpdateInfo {
  const AppUpdateInfo({
    required this.latestVersion,
    required this.storeUrl,
    this.message,
  });

  final String latestVersion;

  /// Platform-resolved store URL (Play Store / App Store).
  final String storeUrl;

  /// Optional server-provided release notes; the UI falls back to localized
  /// copy when this is null/empty.
  final String? message;
}
