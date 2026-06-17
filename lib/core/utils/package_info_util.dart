import 'package:package_info_plus/package_info_plus.dart';

class PackageInfoUtil {
  static final PackageInfoUtil _instance = PackageInfoUtil();

  static PackageInfoUtil get instance => _instance;

  String _version = '';
  String _appVersion = '';
  String _buildNumber = '';
  String _packageName = '';

  PackageInfo? _packageInfo;

  Future<PackageInfo> getPackageInfo() async {
    if (_packageInfo != null) {
      return _packageInfo!;
    }
    _packageInfo = await PackageInfo.fromPlatform();
    return _packageInfo!;
  }

  /// 4.0.0.1
  Future<String> getFullVersion() async {
    if (_version.isNotEmpty) {
      return _version;
    }
    _version = (await getPackageInfo()).version;
    return _version;
  }

  /// 4.0.0
  Future<String> getAppVersion() async {
    if (_appVersion.isNotEmpty) {
      return _appVersion;
    }
    _buildNumber = await getVersionCode();
    _appVersion = (await getFullVersion()).split('.$_buildNumber').first;
    return _appVersion;
  }

  /// 1
  Future<String> getVersionCode() async {
    if (_buildNumber.isNotEmpty) {
      return _buildNumber;
    }
    _buildNumber = (await getPackageInfo()).buildNumber;
    return _buildNumber;
  }

  Future<String> getPackageName() async {
    if (_packageName.isNotEmpty) {
      return _packageName;
    }
    _packageName = (await getPackageInfo()).packageName;
    return _packageName;
  }
}
