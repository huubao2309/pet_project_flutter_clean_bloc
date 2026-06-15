import 'base_button_item_style.dart';
import 'base_button_type_style.dart';
import 'data_source_base_button_item.dart';

enum BaseButtonType { brand, success, error, neutral }

extension BaseButtonTypeExt on BaseButtonType {
  BaseButtonTypeStyle get brandColor => BaseButtonTypeStyle(
        primary:
            BaseButtonItemStyle(dataSource: BrandDataSourceStyle.brandPrimary),
        secondary: BaseButtonItemStyle(
            dataSource: BrandDataSourceStyle.brandSecondary),
        ghost: BaseButtonItemStyle(dataSource: BrandDataSourceStyle.brandGhost),
        tertiary:
            BaseButtonItemStyle(dataSource: BrandDataSourceStyle.brandTertiary),
      );
  BaseButtonTypeStyle get successColor => BaseButtonTypeStyle(
        primary: BaseButtonItemStyle(
            dataSource: SuccessDataSourceStyle.successPrimary),
        secondary: BaseButtonItemStyle(
            dataSource: SuccessDataSourceStyle.successSecondary),
        ghost: BaseButtonItemStyle(
            dataSource: SuccessDataSourceStyle.successGhost),
        tertiary: BaseButtonItemStyle(
            dataSource: SuccessDataSourceStyle.successTertiary),
      );
  BaseButtonTypeStyle get errorColor => BaseButtonTypeStyle(
        primary:
            BaseButtonItemStyle(dataSource: ErrorDataSourceStyle.errorPrimary),
        secondary: BaseButtonItemStyle(
            dataSource: ErrorDataSourceStyle.errorSecondary),
        ghost: BaseButtonItemStyle(dataSource: ErrorDataSourceStyle.errorGhost),
        tertiary:
            BaseButtonItemStyle(dataSource: ErrorDataSourceStyle.errorTertiary),
      );
  BaseButtonTypeStyle get neutralColor => BaseButtonTypeStyle(
        primary: BaseButtonItemStyle(
            dataSource: NeutralDataSourceStyle.neutralPrimary),
        secondary: BaseButtonItemStyle(
            dataSource: NeutralDataSourceStyle.neutralSecondary),
        ghost: BaseButtonItemStyle(
            dataSource: NeutralDataSourceStyle.neutralGhost),
        tertiary: BaseButtonItemStyle(
            dataSource: NeutralDataSourceStyle.neutralTertiary),
      );
}
