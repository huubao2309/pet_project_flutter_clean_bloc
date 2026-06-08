import '../base/enums/enum_interface.dart';
import '../base/app_constants.dart';

enum EnvType implements EnumInterface {
  production("production", kAppName),
  uat("uat", "$kAppName UAT"),
  staging("staging", "$kAppName Staging");

  final String _enumValue;
  final String _appName;

  @override
  String get rawValue => _enumValue;

  @override
  String get displayValue => _enumValue;

  String get displayAapName => _appName;

  const EnvType(this._enumValue, this._appName);

  bool get isProduction => this == EnvType.production;

  bool get isUat => this == EnvType.uat;

  bool get isStaging => this == EnvType.staging;
}
