import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_project_flutter_clean_bloc/core/network/interceptors/header_interceptor.dart';
import 'package:pet_project_flutter_clean_bloc/core/network/interceptors/request_header.dart';
import 'package:pet_project_flutter_clean_bloc/core/utils/device_info_util.dart';
import 'package:pet_project_flutter_clean_bloc/core/utils/package_info_util.dart';
import 'package:pet_project_flutter_clean_bloc/environments/env_type.dart';

class _MockDeviceInfo extends Mock implements DeviceInfoUtil {}

class _MockPackageInfo extends Mock implements PackageInfoUtil {}

class _MockRequestHandler extends Mock implements RequestInterceptorHandler {}

void main() {
  late _MockDeviceInfo deviceInfo;
  late _MockPackageInfo packageInfo;
  late HeaderInterceptor interceptor;

  setUp(() {
    deviceInfo = _MockDeviceInfo();
    packageInfo = _MockPackageInfo();
    when(() => deviceInfo.osVersion).thenReturn('14.0');
    when(() => deviceInfo.deviceModel).thenReturn('Pixel 8');
    when(() => deviceInfo.deviceName).thenReturn('My Phone');
    when(() => packageInfo.getAppVersion()).thenAnswer((_) async => '1.2.3');

    interceptor = HeaderInterceptor(
      envType: EnvType.staging,
      deviceInfo: deviceInfo,
      packageInfo: packageInfo,
    );
  });

  test('attaches device / app / platform headers then continues', () async {
    final options = RequestOptions(path: '/x');
    final handler = _MockRequestHandler();

    await interceptor.onRequest(options, handler);

    final headers = options.headers;
    expect(headers[RequestHeader.osVersion], '14.0');
    expect(headers[RequestHeader.device], 'Pixel 8');
    expect(headers[RequestHeader.deviceName], 'My Phone');
    expect(headers[RequestHeader.appVersion], '1.2.3');
    expect(headers[RequestHeader.contentType], 'application/json');
    expect(headers[RequestHeader.xDataSource], EnvType.staging.rawValue);
    // Platform-derived headers resolve against the host running the test.
    expect(
      headers[RequestHeader.platform],
      Platform.isAndroid ? RequestHeader.android : RequestHeader.ios,
    );
    expect(headers[RequestHeader.contentLanguage], Platform.localeName);

    verify(() => handler.next(options)).called(1);
  });

  test('reads the app version through package info', () async {
    final options = RequestOptions(path: '/x');

    await interceptor.onRequest(options, _MockRequestHandler());

    verify(() => packageInfo.getAppVersion()).called(1);
  });
}
