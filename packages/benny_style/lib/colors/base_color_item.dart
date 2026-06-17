import 'dart:ui';
import 'hex_color.dart';

class BaseColorItem {
  late final Map<String, String> _dataSource;
  late final Color color25;
  late final Color color50;
  late final Color color100;
  late final Color color200;
  late final Color color300;
  late final Color color400;
  late final Color color500;
  late final Color color600;
  late final Color color700;
  late final Color color800;
  late final Color color900;

  BaseColorItem({required Map<String, String> dataSource})
      : _dataSource = dataSource {
    _init();
  }

  _init() {
    color25 = colorHexCode("25");
    color50 = colorHexCode("50");
    color100 = colorHexCode("100");
    color200 = colorHexCode("200");
    color300 = colorHexCode("300");
    color400 = colorHexCode("400");
    color500 = colorHexCode("500");
    color600 = colorHexCode("600");
    color700 = colorHexCode("700");
    color800 = colorHexCode("800");
    color900 = colorHexCode("900");
  }

  Color get _defaultColor => const Color(0xFF008A27);

  Color colorHexCode(String colorValue) {
    final hex = _dataSource[colorValue] ?? "";
    if (hex.isEmpty) {
      return _defaultColor;
    }
    return HexColor(hex);
  }
}
