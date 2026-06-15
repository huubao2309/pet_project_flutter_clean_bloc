import 'package:benny_style/benny_style.dart';

class ThemeBorderRadius {
  final _borderRadius = BennyStyle.instance.borderRadius;

  double get borderRadiusZero => _borderRadius.zer0;
  double get borderRadius4 => _borderRadius.small;
  double get borderRadius8 => _borderRadius.medium;
  double get borderRadius16 => _borderRadius.large;
}
