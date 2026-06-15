import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:benny_style/benny_locator.dart';
import 'package:benny_style/theme/theme_state.dart' show ThemeState;

class BennyListItem extends StatelessWidget {
  final String title;
  final String caption;
  final List<Widget>? actions;
  final String? svgIcon;
  final bool isSelected;
  final VoidCallback? onTap;

  const BennyListItem({
    super.key,
    required this.title,
    required this.caption,
    this.actions,
    this.svgIcon,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = bennyLocator<ThemeState>();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? theme.colors.brand50 : theme.colors.white,
          borderRadius: BorderRadius.circular(theme.borderRadius.borderRadius8),
          border: Border.all(
            color: isSelected ? theme.colors.brand700 : theme.colors.neutral100,
            width: 1,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(theme.spacing.spacing12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (svgIcon != null)
                Container(
                  height: 44,
                  width: 44,
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    svgIcon!,
                    colorFilter: ColorFilter.mode(
                        theme.colors.brand700, BlendMode.srcIn),
                  ),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textStyle.paragraphDefault,
                    ),
                    Text(
                      caption,
                      style: theme.textStyle.captionDefault,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
