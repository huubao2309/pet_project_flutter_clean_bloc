import 'package:flutter/material.dart';
import 'package:benny_style/benny_locator.dart';
import 'package:benny_style/theme/theme_state.dart';

import 'base_button_type.dart';
import 'base_button_type_style.dart';

class BennyButtonStyle {
  late final BaseButtonType type;
  late final BaseButtonTypeStyle _colorStyle;
  late final bool isIconButton;

  BennyButtonStyle({required this.type, this.isIconButton = false}) {
    _init();
  }

  ThemeState get _theme => bennyLocator<ThemeState>();
  EdgeInsets get _defaultPadding => EdgeInsets.symmetric(
      horizontal: _theme.spacing.spacing12, vertical: _theme.spacing.spacing8);

  _init() {
    switch (type) {
      case BaseButtonType.brand:
        _colorStyle = type.brandColor;
      case BaseButtonType.success:
        _colorStyle = type.successColor;
      case BaseButtonType.neutral:
        _colorStyle = type.neutralColor;
      case BaseButtonType.error:
        _colorStyle = type.errorColor;
    }
  }

  ButtonStyle primary({
    MaterialTapTargetSize tapTargetSize = MaterialTapTargetSize.padded,
  }) {
    return ButtonStyle(
      elevation: WidgetStateProperty.all(0),
      shape: WidgetStateProperty.resolveWith(
        (Set<WidgetState> states) {
          return states.contains(WidgetState.disabled)
              ? RoundedRectangleBorder(
                  side:
                      BorderSide(color: _colorStyle.primary.borderDisableColor),
                  borderRadius: BorderRadius.circular(
                    _theme.borderRadius.borderRadius8,
                  ),
                )
              : RoundedRectangleBorder(
                  side:
                      BorderSide(color: _colorStyle.primary.borderActiveColor),
                  borderRadius: BorderRadius.circular(
                    _theme.borderRadius.borderRadius8,
                  ),
                );
        },
      ),
      iconColor: WidgetStateProperty.resolveWith(
        (Set<WidgetState> states) {
          return states.contains(WidgetState.disabled)
              ? _colorStyle.primary.foregroundDisableColor
              : _colorStyle.primary.foregroundActiveColor;
        },
      ),
      foregroundColor: WidgetStateProperty.resolveWith(
        (Set<WidgetState> states) {
          return states.contains(WidgetState.disabled)
              ? _colorStyle.primary.foregroundDisableColor
              : _colorStyle.primary.foregroundActiveColor;
        },
      ),
      overlayColor: WidgetStateProperty.resolveWith(
        (Set<WidgetState> states) {
          return _colorStyle.primary.overlayActiveColor;
        },
      ),
      backgroundColor: WidgetStateProperty.resolveWith(
        (Set<WidgetState> states) {
          return states.contains(WidgetState.disabled)
              ? _colorStyle.primary.backgroundDisableColor
              : _colorStyle.primary.backgroundActiveColor;
        },
      ),
      padding: isIconButton ? null : WidgetStateProperty.all(_defaultPadding),
      textStyle: WidgetStateProperty.resolveWith(
        (Set<WidgetState> states) {
          return states.contains(WidgetState.disabled)
              ? _theme.textStyle.paragraphLabel
              : _theme.textStyle.paragraphLabel;
        },
      ),
      tapTargetSize: tapTargetSize,
    );
  }

  ButtonStyle secondary({
    MaterialTapTargetSize tapTargetSize = MaterialTapTargetSize.padded,
  }) {
    return ButtonStyle(
      elevation: WidgetStateProperty.all(0),
      shape: WidgetStateProperty.resolveWith(
        (Set<WidgetState> states) {
          return states.contains(WidgetState.disabled)
              ? RoundedRectangleBorder(
                  side: BorderSide(
                      color: _colorStyle.secondary.borderDisableColor),
                  borderRadius: BorderRadius.circular(
                    _theme.borderRadius.borderRadius8,
                  ),
                )
              : RoundedRectangleBorder(
                  side: BorderSide(
                      color: _colorStyle.secondary.borderActiveColor),
                  borderRadius: BorderRadius.circular(
                    _theme.borderRadius.borderRadius8,
                  ),
                );
        },
      ),
      foregroundColor: WidgetStateProperty.resolveWith(
        (Set<WidgetState> states) {
          return states.contains(WidgetState.disabled)
              ? _colorStyle.secondary.foregroundDisableColor
              : _colorStyle.secondary.foregroundActiveColor;
        },
      ),
      backgroundColor: WidgetStateProperty.resolveWith(
        (Set<WidgetState> states) {
          return states.contains(WidgetState.disabled)
              ? _colorStyle.secondary.backgroundDisableColor
              : _colorStyle.secondary.backgroundActiveColor;
        },
      ),
      overlayColor: WidgetStateProperty.resolveWith(
        (Set<WidgetState> states) {
          return _colorStyle.secondary.overlayActiveColor;
        },
      ),
      padding: isIconButton ? null : WidgetStateProperty.all(_defaultPadding),
      textStyle: WidgetStateProperty.resolveWith(
        (Set<WidgetState> states) {
          return states.contains(WidgetState.disabled)
              ? _theme.textStyle.paragraphLabel
              : _theme.textStyle.paragraphLabel;
        },
      ),
      tapTargetSize: tapTargetSize,
    );
  }

  ButtonStyle tertiary({
    bool isHasShadow = true,
    MaterialTapTargetSize tapTargetSize = MaterialTapTargetSize.padded,
  }) {
    return ButtonStyle(
      elevation: WidgetStateProperty.all(0),
      shape: WidgetStateProperty.resolveWith(
        (Set<WidgetState> states) {
          return states.contains(WidgetState.disabled)
              ? RoundedRectangleBorder(
                  side: BorderSide(
                      color: _colorStyle.tertiary.borderDisableColor),
                  borderRadius: BorderRadius.circular(
                    _theme.borderRadius.borderRadius8,
                  ),
                )
              : RoundedRectangleBorder(
                  side:
                      BorderSide(color: _colorStyle.tertiary.borderActiveColor),
                  borderRadius: BorderRadius.circular(
                    _theme.borderRadius.borderRadius8,
                  ),
                );
        },
      ),
      foregroundColor: WidgetStateProperty.resolveWith(
        (Set<WidgetState> states) {
          return states.contains(WidgetState.disabled)
              ? _colorStyle.tertiary.foregroundDisableColor
              : _colorStyle.tertiary.foregroundActiveColor;
        },
      ),
      backgroundColor: WidgetStateProperty.resolveWith(
        (Set<WidgetState> states) {
          return states.contains(WidgetState.disabled)
              ? _colorStyle.tertiary.backgroundDisableColor
              : _colorStyle.tertiary.backgroundActiveColor;
        },
      ),
      overlayColor: WidgetStateProperty.resolveWith(
        (Set<WidgetState> states) {
          return _colorStyle.tertiary.overlayActiveColor;
        },
      ),
      padding: isIconButton ? null : WidgetStateProperty.all(_defaultPadding),
      textStyle: WidgetStateProperty.resolveWith(
        (Set<WidgetState> states) {
          return states.contains(WidgetState.disabled)
              ? _theme.textStyle.paragraphLabel
              : _theme.textStyle.paragraphLabel;
        },
      ),
      tapTargetSize: tapTargetSize,
    );
  }

  ButtonStyle ghost({
    MaterialTapTargetSize tapTargetSize = MaterialTapTargetSize.padded,
  }) {
    return ButtonStyle(
      elevation: WidgetStateProperty.all(0),
      shape: WidgetStateProperty.resolveWith(
        (Set<WidgetState> states) {
          return states.contains(WidgetState.disabled)
              ? RoundedRectangleBorder(
                  side: BorderSide(color: _colorStyle.ghost.borderDisableColor),
                  borderRadius: BorderRadius.circular(
                    _theme.borderRadius.borderRadius8,
                  ),
                )
              : RoundedRectangleBorder(
                  side: BorderSide(color: _colorStyle.ghost.borderActiveColor),
                  borderRadius: BorderRadius.circular(
                    _theme.borderRadius.borderRadius8,
                  ),
                );
        },
      ),
      foregroundColor: WidgetStateProperty.resolveWith(
        (Set<WidgetState> states) {
          return states.contains(WidgetState.disabled)
              ? _colorStyle.ghost.foregroundDisableColor
              : _colorStyle.ghost.foregroundActiveColor;
        },
      ),
      backgroundColor: WidgetStateProperty.resolveWith(
        (Set<WidgetState> states) {
          return states.contains(WidgetState.disabled)
              ? _colorStyle.ghost.backgroundDisableColor
              : _colorStyle.ghost.backgroundActiveColor;
        },
      ),
      overlayColor: WidgetStateProperty.resolveWith(
        (Set<WidgetState> states) {
          return _colorStyle.ghost.overlayActiveColor;
        },
      ),
      padding: isIconButton ? null : WidgetStateProperty.all(_defaultPadding),
      textStyle: WidgetStateProperty.resolveWith(
        (Set<WidgetState> states) {
          return states.contains(WidgetState.disabled)
              ? _theme.textStyle.paragraphLabel
              : _theme.textStyle.paragraphLabel;
        },
      ),
      tapTargetSize: tapTargetSize,
    );
  }
}
