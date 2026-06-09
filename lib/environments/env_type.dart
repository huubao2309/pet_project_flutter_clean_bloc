import '../base/enums/enum_interface.dart';
import '../base/app_constants.dart';

enum EnvType implements EnumInterface {
  production('production', kAppName),
  uat('uat', '$kAppName UAT'),
  staging('staging', '$kAppName Staging');

  const EnvType(this._enumValue, this._appName);

  final String _enumValue;
  final String _appName;

  @override
  String get rawValue => _enumValue;

  @override
  String get displayValue => _enumValue;

  String get displayAppName => _appName;

  bool get isProduction => this == EnvType.production;

  bool get isUat => this == EnvType.uat;

  bool get isStaging => this == EnvType.staging;
}
