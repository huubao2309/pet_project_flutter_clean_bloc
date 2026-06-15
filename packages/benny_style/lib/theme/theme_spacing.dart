import 'package:benny_style/benny_style.dart';

class ThemeSpacing {
  final _spacing = BennyStyle.instance.spacing;

  double get spacingZero => _spacing.zer0;
  double get spacing2 => _spacing.superTiny;
  double get spacing4 => _spacing.tiny;
  double get spacing8 => _spacing.small;
  double get spacing12 => _spacing.smallX;
  double get spacing16 => _spacing.medium;
  double get spacing20 => _spacing.mediumX;
  double get spacing24 => _spacing.large;
  double get spacing28 => _spacing.largeX;
  double get spacing32 => _spacing.largeXX;
  double get spacing36 => _spacing.extraLarge;
  double get spacing40 => _spacing.extraLargeX;
}
