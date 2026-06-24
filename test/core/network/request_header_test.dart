import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/network/interceptors/request_header.dart';

void main() {
  group('RequestHeader constants', () {
    test('expose the expected HTTP header names', () {
      expect(RequestHeader.authorization, 'Authorization');
      expect(RequestHeader.platform, 'platform');
      expect(RequestHeader.android, 'android');
      expect(RequestHeader.ios, 'ios');
      expect(RequestHeader.osVersion, 'os-version');
      expect(RequestHeader.device, 'device');
      expect(RequestHeader.deviceName, 'device-name');
      expect(RequestHeader.appVersion, 'version');
      expect(RequestHeader.contentLanguage, 'Content-Language');
      expect(RequestHeader.deviceRegId, 'x-device-id');
      expect(RequestHeader.contentType, 'Content-Type');
      expect(RequestHeader.xDataSource, 'X-Data-Source');
    });
  });
}
