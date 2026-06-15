import 'package:flutter/material.dart';
import 'package:benny_style/benny_style.dart';

class ThemeTextStyle {
  final _textStyle = BennyStyle.instance.textStyle;
  final _color = BennyStyle.instance.color;

  Color get _defaulTextColor => _color.neutral.color600;

  TextStyle get heading {
    if (_getDeviceFontSize == 1) {
      return _textStyle.heading.medium.copyWith(color: _defaulTextColor);
    } else if (_getDeviceFontSize > 1) {
      return _textStyle.heading.large.copyWith(color: _defaulTextColor);
    } else {
      return _textStyle.heading.small.copyWith(color: _defaulTextColor);
    }
  }

  TextStyle get paragraphLabel {
    if (_getDeviceFontSize == 1) {
      return _textStyle.paragraph.label.medium
          .copyWith(color: _defaulTextColor);
    } else if (_getDeviceFontSize > 1) {
      return _textStyle.paragraph.label.large.copyWith(color: _defaulTextColor);
    } else {
      return _textStyle.paragraph.label.small.copyWith(color: _defaulTextColor);
    }
  }

  TextStyle get paragraphDefault {
    if (_getDeviceFontSize == 1) {
      return _textStyle.paragraph.defaultPrimary.medium
          .copyWith(color: _defaulTextColor);
    } else if (_getDeviceFontSize > 1) {
      return _textStyle.paragraph.defaultPrimary.large
          .copyWith(color: _defaulTextColor);
    } else {
      return _textStyle.paragraph.defaultPrimary.small
          .copyWith(color: _defaulTextColor);
    }
  }

  TextStyle get paragraphInlineLink {
    if (_getDeviceFontSize == 1) {
      return _textStyle.paragraph.inlineLink.medium.copyWith(
          color: _defaulTextColor, decoration: TextDecoration.underline);
    } else if (_getDeviceFontSize > 1) {
      return _textStyle.paragraph.inlineLink.large.copyWith(
          color: _defaulTextColor, decoration: TextDecoration.underline);
    } else {
      return _textStyle.paragraph.inlineLink.small.copyWith(
          color: _defaulTextColor, decoration: TextDecoration.underline);
    }
  }

  TextStyle get paragraphMono {
    if (_getDeviceFontSize == 1) {
      return _textStyle.paragraph.mono.medium.copyWith(color: _defaulTextColor);
    } else if (_getDeviceFontSize > 1) {
      return _textStyle.paragraph.mono.large.copyWith(color: _defaulTextColor);
    } else {
      return _textStyle.paragraph.mono.small.copyWith(color: _defaulTextColor);
    }
  }

  TextStyle get paragraphLabelLink {
    if (_getDeviceFontSize == 1) {
      return _textStyle.paragraph.labelLink.medium.copyWith(
          color: _defaulTextColor, decoration: TextDecoration.underline);
    } else if (_getDeviceFontSize > 1) {
      return _textStyle.paragraph.labelLink.large.copyWith(
          color: _defaulTextColor, decoration: TextDecoration.underline);
    } else {
      return _textStyle.paragraph.labelLink.small.copyWith(
          color: _defaulTextColor, decoration: TextDecoration.underline);
    }
  }

  TextStyle get captionDefault {
    if (_getDeviceFontSize == 1) {
      return _textStyle.caption.defaultPrimary.medium
          .copyWith(color: _defaulTextColor);
    } else if (_getDeviceFontSize > 1) {
      return _textStyle.caption.defaultPrimary.large
          .copyWith(color: _defaulTextColor);
    } else {
      return _textStyle.caption.defaultPrimary.small
          .copyWith(color: _defaulTextColor);
    }
  }

  TextStyle get captionMono {
    if (_getDeviceFontSize == 1) {
      return _textStyle.caption.mono.medium.copyWith(color: _defaulTextColor);
    } else if (_getDeviceFontSize > 1) {
      return _textStyle.caption.mono.large.copyWith(color: _defaulTextColor);
    } else {
      return _textStyle.caption.mono.small.copyWith(color: _defaulTextColor);
    }
  }

  TextStyle get captionInlineLink {
    if (_getDeviceFontSize == 1) {
      return _textStyle.caption.inlineLink.medium.copyWith(
          color: _defaulTextColor, decoration: TextDecoration.underline);
    } else if (_getDeviceFontSize > 1) {
      return _textStyle.caption.inlineLink.large.copyWith(
          color: _defaulTextColor, decoration: TextDecoration.underline);
    } else {
      return _textStyle.caption.inlineLink.small.copyWith(
          color: _defaulTextColor, decoration: TextDecoration.underline);
    }
  }

  double get _getDeviceFontSize {
    return WidgetsBinding.instance.platformDispatcher.textScaleFactor;
  }
}
