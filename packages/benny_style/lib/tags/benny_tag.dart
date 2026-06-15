import 'package:flutter/material.dart';
import 'package:benny_style/tags/base_tag_type.dart';
import 'package:benny_style/tags/benny_base_tag.dart';

import 'base_tag_style_type.dart';

class BennyTag extends StatelessWidget {
  const BennyTag({
    super.key,
    required this.title,
    this.type = BaseTagType.brand,
    this.styleType = BaseTagStyleType.saturated,
    this.isMono = true,
  });

  final BaseTagType type;
  final BaseTagStyleType styleType;
  final bool isMono;
  final String title;

  @override
  Widget build(BuildContext context) {
    return BennyBaseTag(
      title: title,
      backgroundColor: _backgroundColor,
      style: _textStyle.copyWith(color: _textColor),
    );
  }

  Color get _backgroundColor {
    switch (styleType) {
      case BaseTagStyleType.unSaturated:
        return isMono
            ? type.unSaturated.mono.color
            : type.unSaturated.unMono.color;
      case BaseTagStyleType.saturated:
        return isMono ? type.saturated.mono.color : type.saturated.unMono.color;
    }
  }

  Color get _textColor {
    switch (styleType) {
      case BaseTagStyleType.unSaturated:
        return isMono
            ? type.unSaturated.mono.textColor
            : type.unSaturated.unMono.textColor;
      case BaseTagStyleType.saturated:
        return isMono
            ? type.saturated.mono.textColor
            : type.saturated.unMono.textColor;
    }
  }

  TextStyle get _textStyle {
    switch (styleType) {
      case BaseTagStyleType.unSaturated:
        return isMono
            ? type.unSaturated.mono.textStyle
            : type.unSaturated.unMono.textStyle;
      case BaseTagStyleType.saturated:
        return isMono
            ? type.saturated.mono.textStyle
            : type.saturated.unMono.textStyle;
    }
  }
}
