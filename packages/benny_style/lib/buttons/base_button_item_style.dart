import 'package:flutter/material.dart';

class BaseButtonItemStyle {
  late final Color borderDisableColor;
  late final Color borderActiveColor;
  late final Color foregroundActiveColor;
  late final Color foregroundDisableColor;
  late final Color backgroundActiveColor;
  late final Color backgroundDisableColor;
  late final Color overlayActiveColor;

  late final Map<String, Color> _dataSource;

  BaseButtonItemStyle({required Map<String, Color> dataSource})
      : _dataSource = dataSource {
    _init();
  }

  _init() {
    borderDisableColor = _getColor("borderDisableColor");
    borderActiveColor = _getColor("borderActiveColor");
    foregroundActiveColor = _getColor("foregroundActiveColor");
    foregroundDisableColor = _getColor("foregroundDisableColor");
    backgroundActiveColor = _getColor("backgroundActiveColor");
    backgroundDisableColor = _getColor("backgroundDisableColor");
    overlayActiveColor = _getColor("overlayActiveColor");
  }

  Color get _defaultColor => Colors.white;

  Color _getColor(String key) {
    return _dataSource[key] ?? _defaultColor;
  }
}
