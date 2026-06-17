import 'package:benny_style/theme/theme_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';

/// Row with a section title and an optional "see all" action, used between
/// dashboard sections.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.titleKey,
    this.onSeeAll,
    super.key,
  });

  final String titleKey;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          titleKey.tr(),
          style: theme.textStyle.paragraphLabel.copyWith(
            color: theme.colors.brand800,
            fontWeight: FontWeight.w700,
            fontSize: 17,
          ),
        ),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            child: Text(
              'home.see_all'.tr(),
              style: theme.textStyle.captionInlineLink
                  .copyWith(color: theme.colors.secondary600),
            ),
          ),
      ],
    );
  }
}
