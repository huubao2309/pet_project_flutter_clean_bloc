/// Port for detecting a fresh (re)install and wiping stale secure data.
///
/// On iOS the Keychain survives an app uninstall, so credentials from a
/// previous install can linger. We compare the current `identifierForVendor`
/// with the one saved in (wipe-on-uninstall) local storage to detect this.
abstract class DeviceSessionRepository {
  /// Current iOS vendor id, or null on non-iOS platforms / when unavailable.
  String? currentVendorId();

  /// Vendor id persisted on the previous install, or null on a fresh install.
  String? savedVendorId();

  /// Remembers the current vendor id for next launches.
  Future<void> saveVendorId(String vendorId);

  /// Wipes all sensitive data kept in the OS keychain/keystore.
  Future<void> clearSecureStorage();
}
