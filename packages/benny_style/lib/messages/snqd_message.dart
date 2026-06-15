import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:benny_style/benny_locator.dart';
import 'package:benny_style/card/benny_card.dart';
import 'package:benny_style/messages/base_message_type.dart';
import 'package:benny_style/theme/theme_spacing.dart';
import 'package:benny_style/theme/theme_state.dart';

class BennyMessage extends StatelessWidget {
  final BaseMessageType type;
  final String title;
  final Color? titleColor;
  final TextStyle? titleTextStyle;
  final String message;
  final Color? messageColor;
  final TextStyle? messageTextStyle;
  final Widget? child;
  final bool? hasBorder;

  const BennyMessage(
      {super.key,
      required this.type,
      this.hasBorder = true,
      this.child,
      required this.title,
      required this.message,
      this.titleColor,
      this.titleTextStyle,
      this.messageTextStyle,
      this.messageColor});
  final double headerLine = 4;

  ThemeSpacing get _spacing => bennyLocator<ThemeState>().spacing;

  @override
  Widget build(BuildContext context) {
    return BennyCard(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      clipBehavior: Clip.hardEdge,
      borderColor: hasBorder == true ? type.borderColor : null,
      isExpanded: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: headerLine,
            color: type.headerColor,
          ),
          Container(
            padding: EdgeInsets.all(_spacing.spacing16)
                .copyWith(top: _spacing.spacing12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _iconBox(name: type.iconName, color: type.icColor),
                    SizedBox(
                      width: _spacing.spacing4,
                    ),
                    Expanded(
                      child: Text(
                        title,
                        style: titleTextStyle ??
                            type.titleTextStyle
                                .copyWith(color: titleColor ?? type.titleColor),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: _spacing.spacing8,
                ),
                Text(
                  message,
                  textAlign: TextAlign.left,
                  style: messageTextStyle ??
                      type.messageTextStyle
                          .copyWith(color: messageColor ?? type.messageColor),
                ),
                if (child != null) ...[
                  SizedBox(
                    height: _spacing.spacing8,
                  ),
                  Container(
                    child: child,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  _iconBox({required String name, required Color color}) => Container(
        height: 20,
        width: 20,
        alignment: Alignment.center,
        child: SvgPicture.asset(
          name,
          height: 16,
          width: 16,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
      );
}
