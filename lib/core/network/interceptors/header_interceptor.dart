import 'dart:io';

import 'package:dio/dio.dart';

import '../../../environments/env_type.dart';
import '../../utils/device_info_util.dart';
import '../../utils/package_info_util.dart';
import 'request_header.dart';

/// Attaches device / app / platform metadata headers to every request.
///
/// Ported from the source app and adapted: the data-source env value comes from
/// [EnvType.rawValue], and the content language from the device locale
/// ([Platform.localeName]) instead of the old GetX `LocalizationService`.
class HeaderInterceptor extends Interceptor {
  /// [deviceInfo] / [packageInfo] default to the app singletons; tests inject
  /// fakes so the interceptor can run without the device_info / package_info
  /// platform plugins.
  HeaderInterceptor({
    required this.envType,
    DeviceInfoUtil? deviceInfo,
    PackageInfoUtil? packageInfo,
  })  : _deviceInfo = deviceInfo ?? DeviceInfoUtil.instance,
        _packageInfo = packageInfo ?? PackageInfoUtil.instance;

  final EnvType envType;
  final DeviceInfoUtil _deviceInfo;
  final PackageInfoUtil _packageInfo;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers[RequestHeader.platform] =
        Platform.isAndroid ? RequestHeader.android : RequestHeader.ios;
    options.headers[RequestHeader.osVersion] = _deviceInfo.osVersion;
    options.headers[RequestHeader.device] = _deviceInfo.deviceModel;
    options.headers[RequestHeader.deviceName] = _deviceInfo.deviceName;
    options.headers[RequestHeader.appVersion] =
        await _packageInfo.getAppVersion();
    options.headers[RequestHeader.contentLanguage] = Platform.localeName;
    options.headers[RequestHeader.contentType] = 'application/json';
    options.headers[RequestHeader.xDataSource] = envType.rawValue;
    super.onRequest(options, handler);
  }
}
