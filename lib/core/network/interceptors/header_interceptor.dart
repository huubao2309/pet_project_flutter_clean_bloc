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
  HeaderInterceptor({required this.envType});

  final EnvType envType;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers[RequestHeader.platform] =
        Platform.isAndroid ? RequestHeader.android : RequestHeader.ios;
    options.headers[RequestHeader.osVersion] =
        DeviceInfoUtil.instance.osVersion;
    options.headers[RequestHeader.device] = DeviceInfoUtil.instance.deviceModel;
    options.headers[RequestHeader.deviceName] =
        DeviceInfoUtil.instance.deviceName;
    options.headers[RequestHeader.appVersion] =
        await PackageInfoUtil.instance.getAppVersion();
    options.headers[RequestHeader.contentLanguage] = Platform.localeName;
    options.headers[RequestHeader.contentType] = 'application/json';
    options.headers[RequestHeader.xDataSource] = envType.rawValue;
    super.onRequest(options, handler);
  }
}
