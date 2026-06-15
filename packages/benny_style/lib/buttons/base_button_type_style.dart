import 'base_button_item_style.dart';

class BaseButtonTypeStyle {
  late final BaseButtonItemStyle primary;
  late final BaseButtonItemStyle secondary;
  late final BaseButtonItemStyle ghost;
  late final BaseButtonItemStyle tertiary;

  BaseButtonTypeStyle(
      {required this.primary,
      required this.secondary,
      required this.ghost,
      required this.tertiary});
}
