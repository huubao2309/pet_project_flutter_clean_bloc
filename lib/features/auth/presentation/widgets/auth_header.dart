import 'package:benny_style/theme/theme_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';

/// Shared header for the auth form screens: a navy title and an optional
/// caption. The app bar already carries the back affordance, so no logo/app
/// icon is shown here — keeping the form screens clean and focused.
class AuthHeader extends StatelessWidget {
  const AuthHeader({
    required this.titleKey,
    this.captionKey,
    this.captionArgs,
    super.key,
  });

  final String titleKey;
  final String? captionKey;

  /// Named args for the caption (e.g. the phone number on the OTP screen).
  final Map<String, String>? captionArgs;

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleKey.tr(),
          style: theme.textStyle.heading.copyWith(
            color: theme.colors.brand800,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (captionKey != null) ...[
          SizedBox(height: theme.spacing.spacing8),
          Text(
            captionKey!.tr(namedArgs: captionArgs),
            style: theme.textStyle.paragraphDefault
                .copyWith(color: theme.colors.neutral600),
          ),
        ],
      ],
    );
  }
}
