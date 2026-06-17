import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoUtil {
  static final DeviceInfoUtil _instance = DeviceInfoUtil._();

  DeviceInfoUtil._();

  static DeviceInfoUtil get instance => _instance;

  final _deviceInfoPlugin = DeviceInfoPlugin();

  String? _deviceModel;
  String? _deviceName;
  String? _osVersion;
  String? _manufacturer;

  IosDeviceInfo? _iosInfo;
  AndroidDeviceInfo? _androidInfo;

  Future<void> setup() async {
    try {
      if (isIOS) {
        _iosInfo = await _deviceInfoPlugin.iosInfo;
      }
      if (isAndroid) {
        _androidInfo = await _deviceInfoPlugin.androidInfo;
      }
    } on Object catch (_) {
      // Device info is best-effort; ignore failures.
    }
    _initDeviceInfo();
  }

  void _initDeviceInfo() {
    _deviceModel = isAndroid ? _androidInfo?.model : _iosInfo?.utsname.machine;
    _deviceName = isAndroid ? _androidInfo?.device : _iosDeviceName;
    _osVersion =
        isAndroid ? _androidInfo?.version.release : _iosInfo?.systemVersion;
    _manufacturer = isAndroid ? _androidInfo?.manufacturer : 'Apple';
  }

  /// Prefer the OS-provided marketing name from device_info_plus
  /// (e.g. "iPhone 16 Pro"); fall back to the user-set device name. This avoids
  /// maintaining a hand-written model-identifier → name table.
  String? get _iosDeviceName {
    final info = _iosInfo;
    if (info == null) {
      return null;
    }
    return info.modelName.isNotEmpty ? info.modelName : info.name;
  }

  String? get deviceModel => _deviceModel;
  String? get deviceName => _deviceName;
  String? get osVersion => _osVersion;
  String? get manufacturer => _manufacturer;

  bool get isAndroid => Platform.isAndroid;
  bool get isIOS => Platform.isIOS;

  int? get androidSdkVersion => _androidInfo?.version.sdkInt;

  /// iOS `identifierForVendor`. Changes when the user deletes all of this
  /// vendor's apps and reinstalls — used to detect a fresh install. Null on
  /// non-iOS platforms.
  String? get iosVendorId => _iosInfo?.identifierForVendor;
}
