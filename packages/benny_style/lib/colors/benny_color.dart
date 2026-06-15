import 'package:benny_style/colors/data_source_color.dart';

import 'base_color_item.dart';

class BennyColor {
  late final BaseColorItem neutral;
  late final BaseColorItem success;
  late final BaseColorItem warning;
  late final BaseColorItem error;
  late final BaseColorItem brand;
  late final Map<String, String> brandSourceColor;

  BennyColor({required Map<String, String> brandSourceColor}) {
    neutral = BaseColorItem(dataSource: DataSourceColor.neutral);
    success = BaseColorItem(dataSource: DataSourceColor.success);
    warning = BaseColorItem(dataSource: DataSourceColor.warning);
    error = BaseColorItem(dataSource: DataSourceColor.error);
    brand = BaseColorItem(dataSource: brandSourceColor);
  }
}
