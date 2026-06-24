import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/base/app_constants.dart';
import 'package:pet_project_flutter_clean_bloc/base/enums/enum_interface.dart';
import 'package:pet_project_flutter_clean_bloc/environments/env_type.dart';

void main() {
  group('EnvType rawValue / displayValue', () {
    test('rawValue equals the enum value string', () {
      expect(EnvType.production.rawValue, 'production');
      expect(EnvType.uat.rawValue, 'uat');
      expect(EnvType.staging.rawValue, 'staging');
    });

    test('displayValue matches rawValue', () {
      expect(EnvType.production.displayValue, EnvType.production.rawValue);
      expect(EnvType.uat.displayValue, 'uat');
      expect(EnvType.staging.displayValue, 'staging');
    });
  });

  group('EnvType displayAppName', () {
    test('builds the app name from kAppName', () {
      expect(EnvType.production.displayAppName, kAppName);
      expect(EnvType.uat.displayAppName, '$kAppName UAT');
      expect(EnvType.staging.displayAppName, '$kAppName Staging');
    });
  });

  group('EnvType predicates', () {
    test('isProduction is exclusive to production', () {
      expect(EnvType.production.isProduction, isTrue);
      expect(EnvType.uat.isProduction, isFalse);
      expect(EnvType.staging.isProduction, isFalse);
    });

    test('isUat is exclusive to uat', () {
      expect(EnvType.uat.isUat, isTrue);
      expect(EnvType.production.isUat, isFalse);
      expect(EnvType.staging.isUat, isFalse);
    });

    test('isStaging is exclusive to staging', () {
      expect(EnvType.staging.isStaging, isTrue);
      expect(EnvType.production.isStaging, isFalse);
      expect(EnvType.uat.isStaging, isFalse);
    });
  });

  group('EnvType type', () {
    test('implements EnumInterface', () {
      expect(EnvType.production, isA<EnumInterface>());
    });

    test('declares exactly three environments', () {
      expect(EnvType.values,
          [EnvType.production, EnvType.uat, EnvType.staging],);
    });
  });
}
