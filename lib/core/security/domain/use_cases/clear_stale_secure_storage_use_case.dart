import '../../../use_case/use_case.dart';
import '../repositories/device_session_repository.dart';

/// Clears secure storage left over from a previous iOS install.
///
/// iOS keeps the Keychain after an app is deleted, so a reinstall can read a
/// stale access/refresh token. We detect a reinstall by the vendor id changing
/// (or being absent), wipe secure storage, then remember the new id.
///
/// No-op on non-iOS platforms (vendor id is null).
class ClearStaleSecureStorageUseCase implements UseCase<void, NoParams> {
  const ClearStaleSecureStorageUseCase({required this.repository});

  final DeviceSessionRepository repository;

  @override
  Future<void> execute(NoParams _) async {
    final current = repository.currentVendorId();
    if (current == null) {
      return;
    }
    if (repository.savedVendorId() != current) {
      await repository.clearSecureStorage();
      await repository.saveVendorId(current);
    }
  }
}
