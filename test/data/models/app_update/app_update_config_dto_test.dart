import 'dart:io' show Platform;

import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/data/models/app_update/app_update_config_dto.dart';

void main() {
  group('AppUpdateConfigDto.fromJson', () {
    test('parses full payload incl nested store_url', () {
      final dto = AppUpdateConfigDto.fromJson({
        'latest_version': '2.5.0',
        'min_required_version': '2.0.0',
        'force_update': true,
        'release_notes': 'Bug fixes',
        'store_url': {
          'android': 'https://play.example/app',
          'ios': 'https://apps.example/app',
        },
      });
      expect(dto.latestVersion, '2.5.0');
      expect(dto.minRequiredVersion, '2.0.0');
      expect(dto.forceUpdate, true);
      expect(dto.releaseNotes, 'Bug fixes');
      expect(dto.androidUrl, 'https://play.example/app');
      expect(dto.iosUrl, 'https://apps.example/app');
    });

    test('applies defaults when keys are missing', () {
      final dto = AppUpdateConfigDto.fromJson({});
      expect(dto.latestVersion, '0.0.0');
      expect(dto.minRequiredVersion, '0.0.0');
      expect(dto.forceUpdate, false);
      expect(dto.androidUrl, '');
      expect(dto.iosUrl, '');
      expect(dto.releaseNotes, isNull);
    });

    test('defaults store urls to empty when store_url absent', () {
      final dto = AppUpdateConfigDto.fromJson({
        'latest_version': '1.2.3',
      });
      expect(dto.androidUrl, '');
      expect(dto.iosUrl, '');
    });

    test('releaseNotes stays null when only that key is absent', () {
      final dto = AppUpdateConfigDto.fromJson({
        'latest_version': '1.0.0',
        'min_required_version': '1.0.0',
        'force_update': false,
        'store_url': {'android': 'a', 'ios': 'i'},
      });
      expect(dto.releaseNotes, isNull);
    });
  });

  group('AppUpdateConfigDto.toEntity', () {
    test('maps fields and resolves platform-specific store url', () {
      const dto = AppUpdateConfigDto(
        latestVersion: '2.5.0',
        minRequiredVersion: '2.0.0',
        forceUpdate: true,
        androidUrl: 'android-url',
        iosUrl: 'ios-url',
        releaseNotes: 'notes',
      );
      final entity = dto.toEntity();
      expect(entity.latestVersion, '2.5.0');
      expect(entity.minRequiredVersion, '2.0.0');
      expect(entity.forceUpdate, true);
      expect(entity.message, 'notes');
      // Platform-resolved: iOS -> iosUrl, otherwise androidUrl.
      expect(entity.storeUrl, Platform.isIOS ? 'ios-url' : 'android-url');
    });

    test('maps null releaseNotes to null message', () {
      const dto = AppUpdateConfigDto(
        latestVersion: '1.0.0',
        minRequiredVersion: '1.0.0',
        forceUpdate: false,
        androidUrl: 'a',
        iosUrl: 'i',
      );
      expect(dto.toEntity().message, isNull);
    });
  });
}
