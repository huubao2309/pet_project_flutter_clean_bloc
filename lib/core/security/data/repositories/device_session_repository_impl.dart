import '../../../storage/local_storage/local_storage.dart';
import '../../../storage/secure_storage/secure_storage.dart';
import '../../../utils/device_info_util.dart';
import '../../domain/repositories/device_session_repository.dart';

/// [DeviceSessionRepository] backed by [DeviceInfoUtil] (vendor id),
/// [LocalStorage] (persisted vendor id) and [SecureStorage] (the data to wipe).
class DeviceSessionRepositoryImpl implements DeviceSessionRepository {
  const DeviceSessionRepositoryImpl({
    required DeviceInfoUtil deviceInfo,
    required LocalStorage localStorage,
    required SecureStorage secureStorage,
  })  : _deviceInfo = deviceInfo,
        _localStorage = localStorage,
        _secureStorage = secureStorage;

  final DeviceInfoUtil _deviceInfo;
  final LocalStorage _localStorage;
  final SecureStorage _secureStorage;

  @override
  String? currentVendorId() => _deviceInfo.iosVendorId;

  @override
  String? savedVendorId() => _localStorage.getVendorId();

  @override
  Future<void> saveVendorId(String vendorId) =>
      _localStorage.setVendorId(value: vendorId);

  @override
  Future<void> clearSecureStorage() => _secureStorage.clearAll();
}
