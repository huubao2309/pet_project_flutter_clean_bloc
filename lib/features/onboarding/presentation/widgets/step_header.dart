import 'package:benny_style/theme/theme_state.dart';
import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';

/// App-bar title for the onboarding steps: a title plus a "current/total"
/// step badge. Ported from the source `SNDQStepWidget`.
class StepHeader extends StatelessWidget {
  const StepHeader({
    required this.title,
    required this.currentStep,
    required this.totalStep,
    super.key,
  });

  final String title;
  final int currentStep;
  final int totalStep;

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: theme.textStyle.paragraphLabel
              .copyWith(color: theme.colors.neutral900),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: theme.colors.neutral100,
            borderRadius:
                BorderRadius.circular(theme.borderRadius.borderRadius8),
          ),
          child: Text(
            '$currentStep/$totalStep',
            style: theme.textStyle.captionDefault
                .copyWith(color: theme.colors.neutral700),
          ),
        ),
      ],
    );
  }
}
