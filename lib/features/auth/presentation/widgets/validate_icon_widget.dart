import 'package:benny_style/benny_locator.dart';
import 'package:benny_style/generated/assets.gen.dart';
import 'package:benny_style/theme/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum ValidIconState { unknown, valid, invalid }

/// A single password-rule row: a status icon + label. Ported from the source
/// app and de-GetX'd (theme resolved via [bennyLocator]).
class ValidateIconWidget extends StatelessWidget {
  ValidateIconWidget({
    super.key,
    this.state = ValidIconState.unknown,
    this.title,
    this.textStyle,
    this.sizeIcon = 24,
    this.spacing,
  });

  final ValidIconState state;
  final String? title;
  final TextStyle? textStyle;
  final double sizeIcon;
  final double? spacing;

  final ThemeState _theme = bennyLocator<ThemeState>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: sizeIcon,
          height: sizeIcon,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: _iconBackgroundColor,
            borderRadius: BorderRadius.circular(sizeIcon / 2),
          ),
          child: SvgPicture.asset(
            _iconName,
            colorFilter:
                ColorFilter.mode(_theme.colors.onColor, BlendMode.srcIn),
          ),
        ),
        if (title != null)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: spacing ?? 8),
              child: Text(
                title!,
                style: textStyle ?? _theme.textStyle.paragraphDefault,
                maxLines: 2,
              ),
            ),
          ),
      ],
    );
  }

  String get _iconName => switch (state) {
        ValidIconState.valid => Assets.svg.icCheckSmall.keyName,
        ValidIconState.invalid => Assets.svg.icCloseSmall.keyName,
        ValidIconState.unknown => Assets.svg.icCheckSmall.keyName,
      };

  Color get _iconBackgroundColor => switch (state) {
        ValidIconState.valid => _theme.colors.brand700,
        ValidIconState.invalid => _theme.colors.error700,
        ValidIconState.unknown => _theme.colors.neutral100,
      };
}
